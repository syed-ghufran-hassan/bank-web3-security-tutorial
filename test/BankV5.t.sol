// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {BankV5} from "../src/BankV5.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

// https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2#code#L69
contract WETH_ETHEREUM is ERC20Mock {
    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        address spender = _msgSender();
        if (spender != from) {
            _spendAllowance(from, spender, value);
        }
        _transfer(from, to, value);
        return true;
    }
}

// https://arbiscan.io/address/0x8b194beae1d3e0788a1a35173978001acdfba668#code#F9#L163
contract WETH_ARBITRUM is ERC20Mock {}

contract BankV3Test is Test {
    BankV5 public bank;

    // This is with 18 decimals as it is Mock, but in reality it is 6 decimals
    ERC20Mock public WETH;

    address mohamed = makeAddr("Mohamed");
    address ahmed = makeAddr("Ahmed");
    address asmaa = makeAddr("Asmaa");
    address attacker = makeAddr("Attacker");

    function setUp() public {}

    function test_bankV5_ok_Ethereum() public {
        WETH_ETHEREUM wethEthereum = new WETH_ETHEREUM();
        bank = new BankV5(address(wethEthereum));

        vm.startPrank(mohamed);
        wethEthereum.mint(mohamed, 1e18);
        wethEthereum.approve(address(bank), 1e18);
        bank.depositWETH(1e18);
        bank.withdrawWETH(0.5e18, mohamed);
        vm.stopPrank();
    }

    // This function will revert
    function test_bankV5_withdraw_revert_Arbitrum() public {
        WETH_ARBITRUM wethArbitrum = new WETH_ARBITRUM();
        bank = new BankV5(address(wethArbitrum));

        vm.startPrank(mohamed);
        wethArbitrum.mint(mohamed, 1e18);
        wethArbitrum.approve(address(bank), 1e18);
        bank.depositWETH(1e18);

        bank.withdrawWETH(0.5e18, mohamed);
        vm.stopPrank();
    }
}
