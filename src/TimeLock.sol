// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

contract Timelock is TimelockController {

    /**
     * 
     * @param minDelay how long to wait before executing
     * @param proposers List of addresses that can propose
     * @param executors List of proposals that can execute
     */
    constructor(uint256 minDelay, address[] memory proposers, address[] memory executors) TimelockController(minDelay, proposers, executors, msg.sender) {}

}