# Privacy

## Overview

Privacy is the foundation of a peer-to-peer electronic cash. In its essence, cash cannot distinguish between individuals, it does not reveal the amounts transferred or owned, and it holds no bias to the history of a specific coin or person. Cash is neutral, the way money should be.

By cleverly employing mimblewimble along with several other methods, grin is able to achieve these qualities, while also keeping in mind its core design attributes of simplicity and scalability. Let's explore how and to what extent.

### Amounts

First, there are no amounts. A mimblewimble implementation natively uses Confidential Transactions, meaning all amounts are hidden; They are provably impossible to uncover, yet easily verified. Even before anything else, simply hiding amounts makes any analysis significantly more challenging.

### Addresses

Notably, there are no on-chain addresses either, as transaction building is interactive. Transactions hold minimal information, and each output is simply a commitment; a point on the curve. A transaction might look like this:

:   *transaction*

    | Inputs      | Outputs                              |
    | ----------- | ------------------------------------ |
    | 08c482407fac2.....e335bf2f10d82      | 085cc6944467b.....a3f1d4274b79b |
    |                                      | 097b2588fd494.....494e43580476b |

!!! note ""
    Each transaction also carries rangeproofs and a kernel, which are mostly irrelevant for this topic.

The above illustrates a normal transaction of 1 input and 2 outputs. The outputs (an input is also a reference to an output) are commitments, a 33 bytes blurb to any observer. There's no address to tie an identity to, and it's not clear which output is the change of the sender, and which belongs to the receiver.

In a Bitcoin-like system, there are multiple ways in which a user might (accidentally or intentionally) link an address to his identity. Consequently, it is often trivial for analysis to link many of his addresses. Not only does his own privacy suffer, but also the entire network's privacy diminishes as a result.

While a grin commitment is one unique output, a bitcoin address may be used to receive an unlimited amount of outputs. An interesting analogy could then be used to emphasize the difference:

* A commitment, once on-chain, is like a one-time-use address. Both of them only ever "contain" a single output.
* A commitment is *not* used to form transactions, unlike an address. A commitment is in fact a *result* of a transaction after it was built peer-to-peer. This makes it significantly harder to link an identity to.

### Aggregation

Furthermore, a key concept of mimblewimble transactions is that several of them can be safely merged together, resulting in what looks like a single transaction. When done at the block level, every block essentially becomes one large transaction:

:   *block*

    | Inputs      | Outputs                              |
    | ----------- | ------------------------------------ |
    | 08c482407fac2.....e335bf2f10d82    | 097b2588fd494.....494e43580476b  |
    | 0857b6b7eb6a2.....a0a283ed35974    | 09f731e071316.....42dae69672dca |
    | 085e205dea687.....8b8aeac7562c6    | 085cc6944467b.....a3f1d4274b79b |
    | 09035d331b17a.....bb76238f605fb    | 094262a95a67a.....2f246f6ce60ce |
    | 0961ee1db49ad.....602489c9c4517    | 09cf2db66b748.....7327297b8e69c |
    |                                    | 09c2751af8fe9.....fc745808238b6 |
    |                                    | 0900015eec3c1.....d52d78fca78de |

The outcome is a non-interactive CoinJoin with hidden amounts. It is named non-interactive since all transactions are aggregated into one without any coordination required between the different parties. This is possible to do at the protocol level, and is simply done automatically whenever several transactions meet each other.

An observer knows how many transactions are included in the block, since each one carries a kernel, but nothing more. Any further information is impossible to obtain by looking at the chain.

### Cut-through

Another trick mimblewimble sets the stage for is to perform cut-through. In an example scenario where `A` sent funds to `B`, and then `B` sent them over to `C`, any trace of `B`'s involvement can be completely removed, such that the result is seen as `A -> C`.

:   *cut-through*

    | Inputs     | Outputs      |  &rArr;  | Inputs     | Outputs      |
    | :--------: | :----------: | :------: | :--------: | :----------: |
    | A          | B            |  &rArr;  | A          |              |
    | B          | C            |  &rArr;  |            | C            |

This is could be done at any level of transaction building; Before broadcast, during peer propagation, or in a block. While this trick's use cases are limited, it is a unique manifestation of the "right to be forgotten" in a blockchain.

## Transaction Graph

Despite the fact that chain analysis can extract very little (if any) information about users and outputs, it is possible to monitor peer-to-peer network activity and obtain the transactions before they're included in a block and aggregated with others. By setting up sniffing nodes connected to many peers, you can figure out which outputs are being spent by what transaction, allowing you to build a partial transaction graph by separating the aggregation done at the block level. It's unclear at this point if meaningful information could be derived from this, as the trail of data stops there.

As of today, an almost complete transaction graph can be constructed. But as usage grows this will gradually become harder. Likewise, many privacy-enhancing techniques can be employed to easily remove linkability of outputs. Fortunately, with mimblewimble these may be added natively, such that nobody knows when a user takes extra privacy precautions to obfuscate the transaction graph, therefore no coins become "tainted".

## Dandelion

An important piece of information that commonly leaks is the *IP address* that originally sent the transaction. Normally, a transaction is just broadcast to all connected peers and immediately spreads on the network, allowing for statistical analysis to deduce where it originated. In a peer-to-peer network, this might be hard as transactions are relayed, but over multiple transactions it becomes trivial.

To tackle this issue, grin employs Dandelion++ (originally proposed as a BIP), a protocol designed to hide a transaction's origin IP address. Dandelion has two phases; a `stem` phase and a `fluff` phase. Once a transaction is initially broadcast, it enters the `stem` phase, in which it hops between individual peers. At a random point, the transaction enters its `fluff` phase and is spread (fluffed) among the entire network.

This makes it almost impossible to deduce a reliable IP address, and renders statistical analysis impractical.

![dandelion](../assets/images/dandelion.png)

Moreover, Dandelion provides an additional benefit unique to mimblewimble, as it allows for transactions to be aggregated at a very early stage. Right before a transaction starts its fluff phase, it enters a 30s waiting period in which it will be aggregated with any other transactions it meets, thus obscuring linkability of inputs and outputs that a sniffing node may have learned. However, the privacy gained from aggregation before fluffing depends on having many other transactions.

## Afterword

Privacy is complex and information leakage is surprisingly easy. Privacy-preserving systems need to be extremely strong to ensure reasonable amounts of protection. Unfortunately, they often fail in practice simply because they are cumbersome to use, causing people to revert to convenience.

Grin is committed  to long term privacy protection and will continue to advance in that direction, while remaining practical and accessible to all, regardless of a person's sophistication or available resources.
