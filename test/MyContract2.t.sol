// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/MyContract2.sol";

contract MyContract2Test is Test {
    MyContract2 public myContract;
    address user1;
    address user2;
    address user3;
    event Send(address to, uint256 amount);

    function setUp() public {
        string
            memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey1 = vm.deriveKey(mnemonic, 0);
        uint256 privateKey2 = vm.deriveKey(mnemonic, 1);
        uint256 privateKey3 = vm.deriveKey(mnemonic, 2);
        user1 = vm.addr(privateKey1);
        user2 = vm.addr(privateKey2);
        user3 = vm.addr(privateKey3);

        myContract = new MyContract2(user1, user2);
        vm.deal(address(myContract), 1 ether);
        console.log(address(myContract).balance);
    }

    function testOnly2User() public {
        vm.prank(user1);
        myContract.send(user1, 1);
        vm.prank(user3);
        vm.expectRevert(bytes("only user1 or user2 can send"));
        myContract.send(user3, 1);
    }

    function testAmountSmallerThanBallance() public {
        vm.prank(user1);
        vm.expectRevert(bytes("insufficient balance"));
        myContract.send(user2, 2 ether);
    }

    function testContractTransferToUser() public {
        vm.prank(user1);
        myContract.send(user2, 1 ether);
        assertEq(address(user2).balance, 1 ether);
    }

    function testContractEmitEvent() public {
        vm.prank(user1);
        vm.expectEmit(false, false, false, true);
        emit Send(user2, 1 ether);

        myContract.send(user2, 1 ether);
    }
}
