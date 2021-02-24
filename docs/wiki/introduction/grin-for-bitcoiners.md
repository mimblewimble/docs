# Grin for Bitcoiners

> *Read this in other languages: [Korean](https://github.com/mimblewimble/grin/blob/master/doc/translations/grin4bitcoiners_KR.md), [简体中文](https://github.com/mimblewimble/grin/blob/master/doc/grin4bitcoiners_ZH-CN.md).*

## Privacy and Fungibility

There are 3 main properties of Grin transactions that make them private:

1. There are no addresses.
1. There are no amounts.
1. 2 transactions, one spending the other, can be merged in a block to form only one, removing all intermediary information.

The 2 first properties mean that all transactions are indistinguishable from one another. Unless you directly participated in the transaction, all inputs and outputs look like random pieces of data (in lingo, they're all random curve points).

Moreover, there are no more transactions in a block. A Grin block looks just like one giant transaction and all original association between inputs and outputs is lost.

## Scalability

As explained in the previous section, thanks to the Mimblewimble transaction and block format we can merge transactions when an output is directly spent by the input of another. It's as if when Alice gives money to Bob, and then Bob gives it all to Carol, Bob was never involved and his transaction is actually never even seen on the blockchain.

Pushing that further, between blocks, most outputs end up being spent sooner or later as a transaction input. So all spent outputs can be safely removed.
That leaves only the kernel of a transaction as having a lasting impact (at around 100 bytes) on the size of the blockchain.

Asymptotically, a Mimblewimble blockchain grows at roughly one quarter the rate of a bitcoin blockchain, while offering much better privacy.

## Scripting

Maybe you've heard that Mimblewimble doesn't support scripts. And in some way, that's true. But thanks to [cryptographic trickery](https://lists.launchpad.net/mimblewimble/msg00029.html), many contracts that in Bitcoin would require a script can be achieved with Grin using properties of Elliptic Curve Cryptography. So far, we know how to do:

* Multi-signature transactions.
* Atomic swaps.
* Time-locked transactions and outputs.
* Lightning Network

## Emission Rate

Bitcoin's 10 minute block time has its initial 50 btc reward cut in half every 4 years until there are 21 million bitcoin in circulation. Grin's emission rate is linear, meaning it never drops. The block reward is currently set at 60 grin with a block goal of 60 seconds. This still works because 1) dilution trends toward zero and 2) a non-negligible amount of coins gets lost or destroyed every year.

## FAQ

### Wait, what!? No address?

Nope, no address. All outputs in Grin are unique and have no common data with any previous output. Instead of relying on a known address to send money, transactions have to be built interactively, with two (or more) wallets exchanging data with one another. This interaction **does not require both parties to be online at the same time**. Practically speaking, there are many ways for two programs to interact privately and securely. This interaction could even take place over email or Signal (or carrier pigeons).

### If transaction information gets removed, can I just cheat and create money?

No, and this is where Mimblewimble and Grin shine. Confidential transactions are a form of [homomorphic encryption](https://en.wikipedia.org/wiki/Homomorphic_encryption). Without revealing any amount, Grin can verify that the sum of all transaction inputs equal the sum of transaction outputs, plus the fee. Going even further, comparing the sum of all money created by mining with the total sum of money that's being held, Grin nodes can check the correctness of the total money supply.

### If I listen to transaction relay, can't I just figure out who they belong to before being cut-through?

You can figure out which outputs are being spent by which transaction, but the trail of data stops here. All inputs and outputs look like random pieces of data, so you can't tell if the money was transferred, still belongs to the same person, which output is the actual transfer and which is the change, etc. Grin transactions are built with *no identifiable piece of information*.

In addition, Grin leverages [Dandelion relay](../miscellaneous/dandelion.md), which provides additional anonymity as to which IP or client the transaction originated from, and allows for transactions to be aggregated.

### What about the quantum computaggedon?

In every Grin output, we also include a bit of hashed data, which is quantum safe. If quantum computing was to become a reality, we can safely introduce additional verification that would protect existing coins from being hacked.

### How does all this magic work?

Click *Next* down below.
