## BankV4 issue explanation

the problem is that `AccessControl` lib by OpenZeppelin, implements a function called `renounceRole()` which makes anyone can remove the role he took, So if the Admins blacklisted a malicious user,  preventing him from withdrawing. He can simply call this function and unBlackList himself, and he will be able to withdraw his tokens.
