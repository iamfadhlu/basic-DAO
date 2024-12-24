// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Box is Ownable {

    uint256 private s_number;

    event NumberChanged(uint256 number);

    constructor() Ownable(msg.sender) {}

    function store (uint256 value) public onlyOwner {
        s_number = value;
        emit NumberChanged(value);
    }

    function getNumber() external view returns (uint256) {
        return s_number;
    }
}