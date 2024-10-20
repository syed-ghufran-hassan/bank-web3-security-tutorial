## BankV2 issue explanation

The problem in the second version is Reentrancy. The developers allow the Clients to withdraw all their money at once, but they reset their balance after sending Ethereum to them, not before. So the attacker can reenter the `withdraw()` function again and again until they drain the Contract Balance totally.
