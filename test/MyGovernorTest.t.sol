// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MyGovernor} from "src/MyGovernor.sol";
import {Timelock} from "src/TimeLock.sol";
import {GovToken} from "src/GovToken.sol";
import {Box} from "src/Box.sol";

contract MyGovernorTest is Test {

    MyGovernor governor;
    Timelock timelock;
    GovToken govToken;
    Box box;

    address public USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant VOTING_DELAY = 7200;
    uint256 constant DELAY = 3600;
    uint256 constant VOTING_PERIOD = 50400;

    address[] proposers;
    address[] executors;
    uint256[] values;
    bytes[] callDatas;
    address[] targets;

    

    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, STARTING_BALANCE);

        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new Timelock(DELAY, proposers, executors);
        governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);
        
        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timelock));
    }

    function testCantUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    function testGovernanceUpdatesBox() public {
        uint256 valueToStore = 888;
        string memory description = "store 888 in the box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueToStore);
        values.push(0);
        callDatas.push(encodedFunctionCall);
        targets.push(address(box));

        // 1. Propose to the DAO
        uint256 proposalId = governor.propose(targets, values, callDatas, description);

        // View the state
        console.log("Proposal State: %d", uint256(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);

        // View the state
        console.log("Proposal State: %d", uint256(governor.state(proposalId)));

        // 2. Vote
        string memory reason = "I want to store 888 in the box";

        vm.prank(USER);
        governor.castVoteWithReason(proposalId, 1, reason);
        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        // 3. Queue
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        // View the state
        console.log("Proposal State: %d", uint256(governor.state(proposalId)));
        governor.queue(targets, values, callDatas, descriptionHash);
        vm.warp(block.timestamp + DELAY + 1);
        vm.roll(block.number + DELAY + 1);

        // 4. Execute
        
        governor.execute(targets, values, callDatas, descriptionHash);
        // Check the value
        uint256 storedValue = box.getNumber();
        assertEq(storedValue, valueToStore); 

    }
}