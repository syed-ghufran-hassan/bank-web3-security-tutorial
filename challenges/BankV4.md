## BankV4 Challenge Explanation

The Developers understood that making an Arbitrary call is dangerous, and they made another version.

In the new version `BankV4`, they removed the feature of withdrawing by doing a fallback function, and for more security, they implement the `BlackList` mechanism that allows them to prevent Bad actors from withdrawing their tokens (To combat money laundering).

After they launched the Protocol, they found that a User had put a large amount of tokens in the Bank, they received a call from an Authorized Entity, that this Wallet was a wallet for an attacker that had just stolen some funds, and asked Bank Develeoprs to prevent him from withdrawing tokens.

Bank developers Blacklisted that user immediately after the call, and prevented him from withdrawing.

The Developers meet with Officials to plan to take that stolen money back and give it to that Entity to return it. But in the meeting when they decided to take that user's money, they noticed that the user was able to withdraw his money, not only this, but he is also not a `BlackListed` user anymore.

You need to know what is the problem that makes the Attacker being able to withdraw his balance although it gets blacklisted by developers.
