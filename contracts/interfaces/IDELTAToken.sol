// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.7.6;

import "../common/OVLTokenTypes.sol";

interface IDELTAToken {
    function vestingTransactions(address, uint256) external view returns (VestingTransaction memory);
    function getUserInfo(address) external view returns (UserInformationLite memory);
    function getMatureBalance(address, uint256) external view returns (uint256);
    function liquidityRebasingPermitted() external view returns (bool);
    function lpTokensInPair() external view returns (uint256);
}