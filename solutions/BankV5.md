## BankV5 issue explanation

The issue here is in Arbitrum WETH implementation itself. The protocol uses `transferFrom()` function to transfer assets from the Bank to the Client. This is like the Bank should approve itself first.

In Ethereum `WETH` will not check for approving if the `spender` address (the address calling the function) is the `from` address (the address that will take his tokens). So using `transferFrom()` in that case will act like normal `transfer()`.

In Arbitrum, `WETH` tokens don't support this, if the caller (spender) is the same as `from` address, WETH token will deal with this as a normal `transferFrom` operation and try to spend allowance, which will result in revert as there is no previous approving of Bank to itself. And this is the standard `ERC20`, that checks approvals even if the caller is the spender.

### Mitigation
To overcome this issue, the Developers should use `transfer()` function instead of `transferFrom()` when withdrawing. But our developers get tired of this and will leave the Web3 ecosystem and return to Web2 xD

