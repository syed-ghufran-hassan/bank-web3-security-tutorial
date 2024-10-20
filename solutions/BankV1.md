## BankV1 issue explanation

The problem is that the developers deal with blockchain and the Web3 ecosystem as they do with Web2. They used `private` variables to secure clients' data and prevent anyone from knowing it.

But in the Ethereum Blockchain (public Blockchain), all data is public. There is no way to store data and prevent users from knowing it. All data on the Ethereum blockchain is public even if they are declared with the `private` modifier, and anyone can see the storage of the contract.

The attacker reads the stored variables that contain the Client's password and withdraws their money to himself.
