// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";


contract BankV4 is AccessControl {
    mapping(address => uint256) public accountsBalances;

    bytes32 public constant BLACKLISTED_WITHDRAW = keccak256("BLACKLISTED_WITHDRAW");
    address public immutable USDT;

    event BlacklistedAccountDrained(address indexed account, address indexed receipent, uint256 amount);
    event AccountBlacklisted(address indexed account);
    event AccountUnBlacklisted(address indexed account);

    constructor(address usdt, address admin) {
        USDT = usdt;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        require(usdt != address(0), "Invalid token address");
    }

    modifier notBlacklisted(address account) {
        require(!hasRole(BLACKLISTED_WITHDRAW, account), "Account is BlackListed");
        _;
    }

    function depositUSD(uint256 amount) external notBlacklisted(msg.sender) {
        require(amount > 0, "Deposit amount must be greater than zero");

        bool success = IERC20(USDT).transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer Failed");

        accountsBalances[msg.sender] += amount;
    }

    function withdrawUSD(uint256 amount, address receipent)
        external
        notBlacklisted(msg.sender)
        
    {
        require(receipent != address(0), "Invalid receipent address");

        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount >= amount, "Amount to withdraw exceeds balance");

        accountsBalances[msg.sender] -= amount;
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfer Failed");
    }

    function blackListAccount(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(hasRole(BLACKLISTED_WITHDRAW, account), "Account already blacklisted");
        _grantRole(BLACKLISTED_WITHDRAW, account);
        emit AccountBlacklisted(account);
    }

    function unBlackListAccount(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!hasRole(BLACKLISTED_WITHDRAW, account), "Account not blacklisted");
        _revokeRole(BLACKLISTED_WITHDRAW, account);
        emit AccountUnBlacklisted(account);
    }

    function drainBlackListedBalance(address account, address receipent)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
        
    {
        require(hasRole(BLACKLISTED_WITHDRAW, account), "Account is not BlackListed");
        
    require(account != receipent, "Cannot send funds back to the blacklisted account");
        require(receipent != address(0), "Invalid receipent address");

        uint256 amount = accountsBalances[account];
        require(amount > 0, "Account balance is zero");

        accountsBalances[account] = 0; // Prevent reentrancy
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfer Failed");

        emit BlacklistedAccountDrained(account, receipent, amount);
    }
}
