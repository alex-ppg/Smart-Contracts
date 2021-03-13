// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.7.6;

interface IRebasingLiquidityToken {
    function rebase(uint256, uint256) external;
}