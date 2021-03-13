// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.7.6;

import "../common/OVLTokenTypes.sol";

interface IOVLTransferHandler {
    function getTransactionDetail(VestingTransaction memory) external view returns (VestingTransactionDetailed memory);
}