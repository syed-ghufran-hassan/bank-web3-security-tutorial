## BankV1 Challenge Explanation

We have a group of people who want to start a new business and build their first Smart Contract on BlockChain, they came from a Web2 background with some information in Bank Systems, and they wanted to make a Decentralized Bank system in Web3.

They started their project, by building the logic of bank contracts similar to Banks in Web2. The Bank stores Clients in `activatedAccounts`. Each client should have a password that will be used to authenticate withdrawals. and there is `accountsBalances` that stores the balance of clients. They made all variables private to prevent anyone from reading them.

Users started to use the bank, `Ahmed` has put `1 ETH` on the bank, after he created a password. But Ahmed noticed that his balance gets decreased to `0`, and someone withdrawed his balance, which means he knows `Ahmed` password, and Ahmed didn't say his password to any one.

Ahmed contacted Bank Support and Bank Supports gets a lot of issues like this.

You need to know what is the problem that allows anyone to withdraw, and how anyone can see the passwords and information of other accounts.
