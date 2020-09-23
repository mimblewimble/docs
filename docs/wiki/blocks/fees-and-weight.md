# Economic Policy: Fees and Mining Reward

**(there are several mentions oh weight and fees, one of them the document below written by igno in 2016, by you should probably wait until they're revisited (tromp rfc) before the last hard fork).
**WORK IN PROGRESS**

## Considerations

Most cryptocurrencies rely on 2 important parameters: fees dictating the cost of transacting and block rewards compensating miners for securing the chain. Rewards also play the important role of being the only source of new money creation: the total amount of tokens in existence is the sum of every reward since the genesis block.

No cryptocurrency so far has established a fee market that would allow to fully compensate for block rewards. Even bitcoin, with its fees significantly raising (as of Oct. 2016), is still far from reaching that goal. Given the current block space supply, bitcoin fees would have to raise by at least an order of magnitude, reaching $4 USD. Even then, the stability of the currency when mining is only paid out in fee is questionable[^1]. We also note that the security provided by a large hashrate is desirable to all participants in a cryptocurrency's economy, and not only to active transactors.

For all these reasons we favor a constant reward over time, remarking that it asymptotically leads to zero dilution[^2].

However, any cryptocurrency needs to protect itself against malicious spamming attacks that would flood the network and bloat storage. Proof of work is an efficient and elegant way to do so but difficult to adopt due to the complex computing ecosystem a cryptocurrency evolves in (from mobile wallets to cheap super-computing). So transaction fees remain the simplest way to protect a blockchain against malicious spam.

By acknowledging that transaction fees only act as spam prevention we gain a framework to gauge how they should be priced: proportionately to the cost incurred by the network when accepting and safekeeping the transaction.
Fee Levels and Incentives

Given that block reward is the only way new currency is introduced, and supply greatly influences value, it makes sense to price fees based on how much supply is injected in the system. It also makes sense to study this for Grin, to establish a fee baseline. We introduce the notion of fees per reward per minute.

For example in Bitcoin, at this time the reward per minute is 1.25BTC. Transaction fees average 70 satoshis per byte for a fast confirmation, putting the average transaction price around 16,000 with a median transaction size of 230 bytes. So the fees for a transaction are priced at 0.00128% of the reward per minute. In Ethereum, factoring in the current gas price, the transaction fees are priced around 0.0028% of the reward per minute.

It may come as a surprise that this number would be higher for Ethereum than Bitcoin, but keep in mind that it only factors supply and not demand. It also only reflects how fast supply is injected, not how much total supply is currently in existence. Nonetheless, these 2 numbers are surprisingly close, giving us a good baseline.

[^1]: http://randomwalker.info/publications/mining_CCS.pdf
[^2]: By introducing new currency, each block reward dilutes all existing participants,
