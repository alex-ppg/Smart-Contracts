// SPDX-License-Identifier: MIT
// DELTA-BUG-BOUNTY
pragma abicoder v2;
pragma solidity ^0.7.6;

import "../../interfaces/IDELTAToken.sol";
import "../../interfaces/IOVLBalanceHandler.sol";

import "../../common/OVLTokenTypes.sol";


contract OVLLPRebasingBalanceHandler is IOVLBalanceHandler {
    IDELTAToken private immutable DELTA_TOKEN;

    constructor() {
        DELTA_TOKEN = IDELTAToken(msg.sender);
    }

    function handleBalanceCalculations(address account, address) external view override returns (uint256) {
        UserInformationLite memory ui = DELTA_TOKEN.getUserInfo(account);
        return ui.maxBalance;
    }
}