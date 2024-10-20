## BankV3 Challenge Explanation

The developers understood the concept of Reentrancy, and they understood that they should transfer balance in the end of execution.

They made a new version `BankV3`, and they chose `USDT` ERC20 token for their token instead of native Ether, they didn't do the mistake they did before, they implemented a feature in that version, that allows users to withdraw their tokens only, or they can withdraw, and after withdrawing they can call random function.

They launched the protocol, but they noticed that one user was able to take all the `USDT` balances in the Bank (same as BankV2).

You need to know what is the problem that makes the Attacker being able to drain the Bank Balance.
