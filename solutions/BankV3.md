## BankV3 issue explanation

The problem is V3, is in `withdrawFallbackUSD()`, the developers support a new feature that allows users to withdraw their `USDT` tokens, and make a custom function after they receive `USDT`.

The problem here is that the user can call any function on any address, where the `receipent` and `fallback function data` are given by the user, so if the user made the recipient the `USDT` ERC20 token itself, and makes the function to get called `approve()` function that gives himself allowance to spend `USDT` tokens owned by the Bank, he can make a small withdraw function, setting USDT token as a recipient by approving himself, then he can simply transfer all the tokens held by the Bank to himself, as he is allowed to take them. 
