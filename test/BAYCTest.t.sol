// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

interface BAYC {
    function mintApe(uint numberOfTokens) external payable;

    function balanceOf(address owner) external view returns (uint256 balance);
}

contract BAYCTest is Test {
    string MAINNET_RPC_URL =
        "https://eth-mainnet.g.alchemy.com/v2/rTJXBixdNRsXN7vL5mb10WFddBpSRZ8j";
    uint256 forkId;
    address user1;
    uint BLOCK_NUMBER = 12_299_047;

    function setUp() public {
        string
            memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey1 = vm.deriveKey(mnemonic, 0);

        user1 = vm.addr(privateKey1);
        // why this line doesn't work?
        vm.deal(address(user1), 10 ether);

        forkId = vm.createFork(MAINNET_RPC_URL, BLOCK_NUMBER);
        vm.selectFork(forkId);
    }

    function testCreateFork() public {
        assertEq(block.number, BLOCK_NUMBER);
        emit log_address(address(user1));
    }

    function testSelectFork() public {
        assertEq(vm.activeFork(), forkId);
    }

    function testMintBAYC() public {
        BAYC baycContract = BAYC(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
        uint originalContractBalance = address(baycContract).balance;

        emit log_uint(address(user1).balance);
        vm.startPrank(user1);
        vm.deal(address(user1), 10 ether);
        emit log_uint(address(user1).balance);
        baycContract.mintApe{value: 0.8 ether}(10);
        assertEq(baycContract.balanceOf(user1), 10);

        assertEq(
            address(baycContract).balance,
            originalContractBalance + 0.8 ether
        );
        vm.stopPrank();
    }
}
