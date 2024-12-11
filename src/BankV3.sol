// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract BankV3 {
    mapping(address => uint256) private accountsBalances;
    mapping(address => bool) private trustedContracts;

    address public immutable USDT;
    address private owner;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdraw(address indexed withdrawer, address indexed recipient, uint256 amount);
    event FallbackCalled(address indexed recipient, bytes data, bool success);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier noReentrant() {
        require(!locked, "Reentrant call detected");
        locked = true;
        _;
        locked = false;
    }

    bool private locked;

    constructor(address usdt) {
        USDT = usdt;
        owner = msg.sender;
    }

    function setTrustedContract(address contractAddress, bool isTrusted) external onlyOwner {
        trustedContracts[contractAddress] = isTrusted;
    }

    function isTrustedContract(address contractAddress) internal view returns (bool) {
        return trustedContracts[contractAddress];
    }

    

    function depositUSD(uint256 amount) external payable {
        require(amount > 0, "Deposit amount must be greater than zero");

        IERC20 usdt = IERC20(USDT);
        bool success = usdt.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed during deposit");

        accountsBalances[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

      function withdrawUSD(uint256 amount, address receipent) external {
        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount >= amount, "Amount to withdraw exceeds balance");

        accountsBalances[msg.sender] -= amount;
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfering Failed");
    }

    function withdrawFallbackUSD(uint256 amount, address receipent, bytes memory data) external noReentrant {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(accountsBalances[msg.sender] >= amount, "Amount to withdraw exceeds balance");
        require(receipent != address(0), "Recipient cannot be the zero address");
        require(isTrustedContract(receipent), "Recipient not authorized");
     
        accountsBalances[msg.sender] -= amount;

        (bool fallbackSuccess,) = receipent.call(data);
        require(fallbackSuccess, "Fallback function call failed");

        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Token transfer failed");
    }
}
