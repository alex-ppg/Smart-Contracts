// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "./OVLTokenTypes.sol";
import "@openzeppelin/contracts/math/SafeMath.sol"; 

contract OVLVestingCalculator {
    using SafeMath for uint256;

    function getTransactionDetails(VestingTransaction memory _tx) public view returns (VestingTransactionDetailed memory dtx) {
        return getTransactionDetails(_tx, block.timestamp);
    }

    function getTransactionDetails(VestingTransaction memory _tx, uint256 _blockTimestamp) public pure returns (VestingTransactionDetailed memory dtx) {
        if(_tx.fullVestingTimestamp == 0) {
            return dtx;
        }
        dtx.amount = _tx.amount;
        dtx.fullVestingTimestamp = _tx.fullVestingTimestamp;
        // at precision E4, 1000 is 10%
        uint256 timeRemaining;
        if(_blockTimestamp >= dtx.fullVestingTimestamp) {
            // Fully vested
            timeRemaining = 0;
        }
        else {
            timeRemaining = dtx.fullVestingTimestamp - _blockTimestamp;
        }

        uint256 percentWaitingToVestE4 = timeRemaining.mul(1e4) / FULL_EPOCH_TIME;
        uint256 percentWaitingToVestE4Scaled = percentWaitingToVestE4.mul(90) / 100;

        dtx.immature = _tx.amount.mul(percentWaitingToVestE4Scaled) / 1e4;
        dtx.mature = _tx.amount.sub(dtx.immature);
    }

    function getMatureBalance(VestingTransaction memory _tx, uint256 _blockTimestamp) public pure returns (uint256 mature) {
        if(_tx.fullVestingTimestamp == 0) {
            return 0;
        }
        
        uint256 timeRemaining;
        if(_blockTimestamp >= _tx.fullVestingTimestamp) {
            // Fully vested
            timeRemaining = 0;
        }
        else {
            timeRemaining = _tx.fullVestingTimestamp - _blockTimestamp;
        }

        uint256 percentWaitingToVestE4 = timeRemaining.mul(1e4) / FULL_EPOCH_TIME;
        uint256 percentWaitingToVestE4Scaled = percentWaitingToVestE4.mul(90) / 100;

        mature = _tx.amount.mul(percentWaitingToVestE4Scaled) / 1e4;
        mature = _tx.amount.sub(mature); // the subtracted value represents the immature balance at this point
    }

    function calculateTransactionDebit(VestingTransactionDetailed memory dtx, uint256 matureAmountNeeded, uint256 currentTimestamp) public pure returns (uint256 outputDebit) {
        if(dtx.fullVestingTimestamp > currentTimestamp) {
            // Only a partially vested transaction needs an output debit to occur
            // Precision Multiplier -- this many zeros (23) seems to get all the precision needed for all 18 decimals to be only off by a max of 1 unit
            uint256 pm = 1e23;

            // This will be between 0 and 100*pm representing how much of the mature pool is needed
            uint256 percentageOfMatureCoinsConsumed = matureAmountNeeded.mul(pm).div(dtx.mature);
            require(percentageOfMatureCoinsConsumed <= pm, "OVLTransferHandler: Insufficient funds");

            // Calculate the number of immature coins that need to be debited based on this ratio
            outputDebit = dtx.immature.mul(percentageOfMatureCoinsConsumed).div(pm);
        }

        // shouldnt this use outputDebit
        require(dtx.amount <= dtx.mature.add(dtx.immature), "DELTAToken: Balance maximum problem"); // Just in case
    }
}