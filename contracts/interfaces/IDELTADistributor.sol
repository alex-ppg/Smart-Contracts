// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.7.6;

interface IDELTADistributor {
    function creditUser(address,uint256) external;
}