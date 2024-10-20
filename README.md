# Web3 Security Tutorial | Bank Challenge

This repository is a simple tutorial in Web3 Security (EVM), the idea of this tutorial is to understand some common bugs in Web3 and concepts you should understand.

This repo is like CTF challenges, but it differs in the structure. Our tutorial is like a game, or to be more accurately, a story, a Story of a group of developers trying to make a Decentralized Bank and launch it on Mainnet. The challenges are in sequence. You should pass the First Challenge to go to the second, and the second to go to the third, etc.

## Installation
To install the Repo, you must have `Foundry` framework installed on your PC. If you don't have one, you can install it from [here](https://getfoundry.sh/)

If you already have Foundry installed, it is better to update `Foundry` version to be compatible with that version. You can update it using the following command

```powershell
foundryup
```

Once you updated or installed `Foundry` successfully, you can start setting up our Tutorial.

1. Clone the GitHub repository into your PC, and open the Repo folder on your Code Editor
```powershell
git clone https://github.com/Al-Qa-qa/bank-web3-security-tutorial.git
```

2. Install Dependencies
```powershell
forge install
```

3. Run Tests to check everything is OK (All tests should pass)
```powershell
forge test
```

## Tutorial Explanation
Our tutorial is simple. We have different files in the `/src` folder, each representing a smart contract with an issue. To simulate the issue's solution, you will find it in the `/test` file, which has the same name as that in the `/src` file. For example, the contract `/src/BankV1.sol` has its solution in `/test/BankV1.t.sol`.

### Tutorial Start (Challenge 1)
We have a group of people who want to start a new business and build their first Smart Contract on BlockChain, they came from a Web2 background with some information in Bank Systems, and they wanted to make a Decentralized Bank system in Web3.

They started their project, by building the logic of bank contracts similar to Banks in Web2. The Bank stores Clients in `activatedAccounts`. Each client should have a password that will be used to authenticate withdrawals. and there is `accountsBalances` that stores the balance of clients. They made all variables private to prevent anyone from reading them.

Users started to use the bank, `Ahmed` has put `1 ETH` on the bank, after he created a password. But Ahmed noticed that his balance gets decreased to `0`, and someone withdrawed his balance, which means he knows `Ahmed` password, and Ahmed didn't say his password to any one.

Ahmed contacted Bank Support and Bank Supports gets a lot of issues like this.

You need to know what is the problem that allows anyone to withdraw, and how anyone can see the passwords and information of other accounts.

---

### Challenge 2
After the Team understood the Blockchain System, where everything is public, and no one can store secret information, They made another version.

The new version `BankV2` is simpler. They made a simple Bank system that allows accepting and withdrawing ETH, the project is life and users starts using it.

The Bank Contract Ether increases, as users are depositing, but Bank Developers noticed that the Bank Ether balance is zero. They investigated the issue and found that just a single user withdrew his balance, but other users still had a balance in the Bank.

You need to know what is the problem that makes the Attacker being able to drain the Bank Balance.

---

### Challenge 3
The developers understood the concept of Reentrancy, and they understood that they should transfer balance in the end of execution.

They made a new version `BankV3`, and they chose `USDT` ERC20 token for their token instead of native Ether, they didn't do the mistake they did before, they implemented a feature in that version, that allows users to withdraw their tokens only, or they can withdraw, and after withdrawing they can call random function.

They launched the protocol, but they noticed that one user was able to take all the `USDT` balances in the Bank (same as BankV2).

You need to know what is the problem that makes the Attacker being able to drain the Bank Balance.

---

### Challenge 4
The Developers understood that making an Arbitrary call is dangerous, and they made another version.

In the new version `BankV4`, they removed the feature of withdrawing by doing a fallback function, and for more security, they implement the `BlackList` mechanism that allows them to prevent Bad actors from withdrawing their tokens (To combat money laundering).

After they launched the Protocol, they found that a User had put a large amount of tokens in the Bank, they received a call from an Authorized Entity, that this Wallet was a wallet for an attacker that just stolen some funds, and asked Bank Develeoprs to prevent him from withdrawing tokens.

Bank developers Blacklisted that user immediately after the call, and prevented him from withdrawing.

The Developers meet with Officials to plan to take that stolen money back and give it to that Entity to return it. But in the meeting when they decided to take that user money, they noticed that the user was able to withdraw his money, not only this, but he is also not a `BlackListed` user anymore.

 You need to know what is the problem that makes the Attacker being able to withdraw his balance although it gets blacklisted by developers.

---

### Challenge 5
The developers learned the lesson that they should understand the libraries they are using, and they made a new version.

In the new version `BankV5`, they decided to use `WETH` instead of `USDT`, with simple logic for deposit and withdrawing.

They launched there bank on Ethereum, everything is find, users are depositing and withdrawing easily, and no attack or unintended behavior occurs.

After a while, the number of Bank users increases, and it becomes a popular Bank on Ethereum BlockChain. The developers' business is growing, so they decided to extend their busniess and deploy their bank on `Arbitrum`.

After deploying on `Arbitrum`, and users starts using it on Arbitrum, they receive messages from clients that they are unable to withdraw their tokens. The Bank Developers are shocked by this as the Protocol is working fine on Ethereum, and withdrawal is not working on `Arbitrum`.

 You need to know what is the problem that prevents withdrawing functionality from working on `Arbitrum`.




