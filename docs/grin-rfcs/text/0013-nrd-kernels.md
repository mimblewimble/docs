
- Title: `nrd-kernels`
- Authors: [Antioch Peverell](mailto:apeverell@protonmail.com)
- Start date: Mar 24, 2020
- RFC PR: Edit if merged: [mimblewimble/grin-rfcs#47](https://github.com/mimblewimble/grin-rfcs/pull/47)
- Tracking issue: [mimblewimble/grin#3288](https://github.com/mimblewimble/grin/issues/3288)

---

# Summary
[summary]: #summary

Grin supports a limited implementation of "relative timelocks" with "No Recent Duplicate" (NRD) transaction kernels. Transactions can be constructed such that they share duplicate kernels. An NRD kernel instance is not valid within a specified number of blocks relative to a prior duplicate instance of the kernel. A minimum height difference must therefore exist between two instances of an NRD kernel. This provides the relative height lock between transactions.

# Motivation
[motivation]: #motivation

Relative timelocks are a prerequisite for robust payment channels. NRD kernels can be used to implement a _revocable_ channel close mechanism.
A mandatory revocation period can be introduced through a relative timelock between two transactions. Any attempt to close an old invalid channel state can be safely revoked during the revocation period.

Recently, Ruben Somsen announced a design for [Succinct Atomic Swaps (SAS)][10] reducing the number of on-chain transactions required to implement the swap. This design uses a combination of relative locks and [adaptor signatures][11]. SAS would appear to be compatible with Grin/MW but with some caveats, namely the need for an additional transaction kernel as the NRD lock and the adaptor signature cannot co-exist on the same kernel. This is discussed in [Unresolved questions](#unresolved-questions) below.

# Community-level explanation
[community-level-explanation]: #community-level-explanation

A minimum distance in block height is enforced between successive duplicate instances of a given NRD kernel. This can be used to enforce a relative lock height between two transactions. A transaction containing an NRD kernel will not be accepted as valid within the specified block height relative to any prior instance of the NRD kernel.

Transactions can be constructed around an existing transaction kernel by introducing either an additional kernel or in some cases by simply adjusting the kernel offset. This allows NRD kernels to be used across any pair of transactions.

The NRD kernel implementation aims for simplicity and a minimal approach to solving the problem of "relative locks". Grin does not support a general solution for arbitrary length locks between arbitrary kernels. The implementation is limited in scope to avoid adversely impacting performance and scalability. References between duplicate kernels are _implicit_, avoiding the need to store kernel references. Locks are limited in length to _recent_ history, avoiding the need to inspect the full historical kernel set during verification.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

An NRD kernel is not valid within a specified number of blocks of a previous duplicate instance of the same NRD kernel. We define duplicate here as two NRD kernels sharing the same public excess commitment. NRD kernels with different excess commitments are not treated as duplicates. An NRD kernel and a non-NRD kernel (plain kernel, coinbase kernel etc.) sharing the same excess commitment are not treated as duplicates.

An NRD kernel has an associated _relative_ lock height. For a block _B_ containing this kernel to be valid, no duplicate instance of the kernel can exist in the last _RH_ blocks (up to and including _B_), where _RH_ is the relative lock height.
For example, a transaction containing an NRD kernel with relative lock height 1440 (24 hours) is included in a block at height 1000000. This block is only valid if no duplicate instance of this kernel exists in any block from height 998561 (h-1439) to height 1000000 (h-0) inclusive. A duplicate instance _is_ permitted at height 998560 (h-1440), with the transaction seen as valid.
If no duplicate instance of the kernel exists within this range then the lock criteria is met.

A kernel can be delayed by the existence of a previous kernel. The _non-existence_ of a previous kernel has no impact on the lock criteria. Note that this implies the _first_ singular occurrence of any NRD kernel meets the lock criteria trivially as it cannot, by definition, be locked by a previous kernel. Thus, the relative lock defaults to "fail open" semantics.

Each node maintains an index of _recent_ NRD kernels to enable efficient checking of NRD relative lock heights. Note we only need to index NRD locks and we only need to index those within recent history. Relative locks longer than 7 days are not valid. This is believed to be sufficient to cover all proposed use cases.

The minimum value for a relative lock height is 1 meaning a prior instance of the kernel can exist in the previous block for the lock criteria to be met.
An instance of the NRD kernel in the _same_ block will invalidate the block as the lock criteria will not be met.

NRD lock heights of 0 are invalid and it is never valid for two duplicate instances of the _same_ NRD kernel to exist in the same block.

It follows that two transactions containing duplicate instances of the same NRD kernel cannot be accepted as valid in the transaction pool concurrently.
Current txpool behavior is "first one wins" semantics when receiving transactions and this will also apply to transactions containing NRD kernels. We plan to revisit this in a future "fee" RFC and plan to investigate the feasibility of introducing "replace by fee" semantics at that time.

Grin supports "rewind" back through recent history to handle fork and chain reorg scenarios. 1 week of full blocks are maintained on each node and up to 10080 blocks can be rewound. To support relative lock heights each node must maintain an index over sufficient kernel history for an _additional_ 10080 blocks beyond this rewind horizon. Each node should maintain 2 weeks of kernel history in the local NRD kernel index. This will cover the pathological case of a 1 week rewind and the validation of a 1 week long relative lock beyond that. The primary use case is for revocable payment channel close operations. We believe a 7 day period is more than sufficient for this. We do not require long, extended revocation periods and limiting this to a few days is preferable to keep the cost of verification low. The need for these revocable transactions to be included on chain should be low as these are only required in a non-cooperative situation but where required we want to minimize the cost of verification which must be performed across all nodes.

----

The following kernel variants are supported in Grin -

* Plain
* Coinbase
* HeightLocked
* NoRecentDuplicate

These are implemented as kernel "feature" variants -

```
pub enum KernelFeatures {
	/// Plain kernel (default for Grin txs).
	Plain = 0,
	/// A coinbase kernel.
	Coinbase = 1,
	/// A kernel with an explicit absolute lock height.
	HeightLocked = 2,
	/// A relative height locked NRD kernel.
	NoRecentDuplicate = 3,
}
```

Each kernel variant includes feature specific data -

```
# Plain
{    
  "fee": 8
}
# Coinbase
{
  # empty
}
# Height Locked
{
  "fee": 8,
  "lock_height": 295800
}
# No Recent Duplicate (NRD)
{
  "fee": 8,
  "relative_height": 1440,
}
```

Note that NRD kernels require no additional data beyond that required for absolute height locked kernels. The reference to the previous kernel is _implicit_ and based on a duplicate NRD kernel excess commitment.

The maximum supported NRD _relative_height_ is 10080 (7 days) and the relative height can be safely and conveniently represented as a `u16` (2 bytes). This differs from absolute lock heights where `u64` (8 bytes) is necessary to specify the lock height.

The minimum supported NRD _relative_height_ is 1 and a value of 0 is not valid. Two duplicate instances of a given NRD kernel cannot exist simultaneously in the same block. There must be a relative height of at least 1 block between them.

----

Nodes on the Grin network currently support two serialization versions for transaction kernels -

__V1 "fixed size kernels"__

In V1 all kernels are serialized to the same "fixed" number of bytes:

	feature (1 byte) | fee (8 bytes) | additional_data (8 bytes) | excess commitment (33 bytes) | signature (64 bytes)

	03 | 00 00 00 00 01 f7 8a 40 | 00 00 00 00 00 00 05 A0 | 08 b1 ... 22 d8 | 33 11 ... b9 69

NRD kernels use the last 2 bytes of feature specific data for the relative lock height as big-endian u16. 
The first 6 bytes of feature specific data must be all zero:

	00 00 00 00 00 00 05 A0

Note: absolute lock height (u64) and relative lock height (u16) have identical serialization in practice. 

V1 is supported for backward compatibility with nodes that do not support V2 "variable size kernels".

__V2 "variable size kernels"__

V2 kernels have been supported since Grin `v2.1.0` and V2 supports the notion of "variable size" kernels. See [RFC-0005 "Varible Size Kernels"][12] for details of this.

NRD kernels include 8 bytes for the fee as big-endian u64 and 2 bytes for the relative lock height:

	feature (1 byte) | fee (8 bytes) | relative_height (2 bytes) | excess commitment (33 bytes) | signature (64 bytes)

	03 | 00 00 00 00 00 6a cf c0 | 05 A0 | 09 4d ... bb 9a | 09 c7 ... bd 54

In V2 relative lock height is 2 bytes as big-endian u16:

	05 A0

Note: the serialization strategy is used for both network "on the wire" serialization of both transactions and full blocks, and local storage, both the database for full blocks and the kernel MMR backend files.
Version negotiation occurs during the initial peer connection setup process and determines which version is used for p2p message serialization.
If a node uses V2 serialization for the kernel MMR backend file then it will provide a V2 txhashset based on these underlying files.

__Kernel Signature Message__

Every kernel contains a signature proving the excess commitment is a commitment to zero. The message being signed includes the features, fee and other associated data to prevent malleability of the transaction kernel and the overall transaction. The transaction fee cannot be modified after signing, for example.

For NRD kernels the message being signed is constructed as follows with
the relative lock height serialized as 2 bytes.

```
Hash(feature | fee | relative_height)

Hash(03 | 00 00 00 00 01 f7 8a 40 | 05 A0)
```

----

No additional data is introduced with NRD kernels beyond the 2 bytes representing the relative lock height. There is no opportunity to include arbitrary data. Any additional kernel included in a transaction is itself still a fully valid kernel. There is no explicit reference necessary that could be misused to include arbitrary data.

An additional NRD kernel in a transaction will increase the "weight" of the transaction by this single additional kernel and allows for a simple way to deal with additional fees. A transaction with an additional kernel must provide additional fees to cover the additional "weight". NRD kernels cannot be added for free. Note that in some limited situations it is possible to _replace_ a kernel with an NRD kernel. If the NRD lock can be introduced without adding an additional kernel then the fee does not have to be increased and the lock is effectively added for free.

----

A transaction kernel consists of an excess commitment and an associated signature showing this excess is indeed a commitment to 0.

A transaction with a single kernel can always be represented as a transaction with multiple kernels, provided the kernels excess commitments sum to the correct total excess.

Given an existing NRD kernel with excess commitment -

* _r'G + 0H_

And a transaction with single excess commitment -

* _rG + 0H_

This transaction can be represented as a pair of kernels with excess commitments -

* _rG + 0H =
    (r'G + 0H) + (r-r'G + 0H)_

We take advantage of this to allow an arbitrary NRD kernel to be included in any transaction at construction time.

Additionally the kernel offset included in each transaction can be used in certain situations to allow the replacement of a single transaction kernel with an NRD kernel without needing to introduce an additional kernel.

Given an existing NRD kernel with excess commitment -

* _r'G + 0H_

And a transaction with single excess commitment and kernel offset -

* _rG + 0H, o_

This transaction can be rewritten to use the NRD kernel -

* _r'G + 0H, (o+r-r')_

These two "degrees of freedom", introducing multiple kernels and adjusting the kernel offset, allowing for flexibility to introduce an NRD kernel in a variety of ways.

* Introduce NRD kernel to transaction, compensate with additional kernel.
* Introduce NRD kernel to transaction, compensate with kernel offset.

----

#### Payment Channel Implementation

NRD kernels can be used to delay alternate "branches" of conflicting transactions, enabling a payment channel implementation.

A payment channel is represented as a single multi-party output. Each channel state transition is represented as a pair of "close" and "settle" transactions with an NRD kernel enforcing a delay between them. Funds are held in an intermediate multi-party output while delayed. The NRD kernel is reused across both transactions by adjusting kernel offsets.

_X -> Y, K<sub>nrd_a</sub>_ \
_Y -> [Z<sub>a</sub>, Z<sub>b</sub>], K<sub>nrd_a</sub>_

Alice closes the channel _X_ with their "close" transaction. After a delay Alice can "settle" the funds out to Alice and Bob.

_Attribution_ of "close" and "settle" transactions for each channel state is provided through endpoint specific NRD kernels. This allows the other party to "revoke" old invalid state without the NRD delay.

Each channel state transition involves a new pair of "close" and "settle" transactions for each participant along with a shared "revoke" transaction. The "revoke" transaction simply spends funds back to the channel output and a plain kernel suffices.

_[Z<sub>a</sub>, Z<sub>b</sub>] -> X, K<sub>rev</sub>_

Alice attempts to close old invalid state (_Y<sub>1</sub>_):

_X -> Y<sub>1</sub>, K<sub>nrd_a1</sub>_

Bob can immediately revoke and close current state (_Y<sub>1</sub> -> Y<sub>2</sub>_):

_Y<sub>1</sub> -> ~[Z<sub>a</sub>, Z<sub>b</sub>]~, K<sub>nrd_b1</sub>_ \
_~[Z<sub>a</sub>, Z<sub>b</sub>]~ -> ~X~, K<sub>rev_1</sub>_ \
_~X~ -> Y<sub>2</sub>, K<sub>nrd_b2</sub>_ \
_=> Y<sub>1</sub> -> Y<sub>2</sub>, [K<sub>nrd_b1</sub>, K<sub>rev_1</sub>, K<sub>nrd_b2</sub>]_

Bob publishes only the final cut-through multi-kernel transaction (_Y<sub>1</sub> -> Y<sub>2</sub>_). Bob's individual settle transaction is not revealed.

Neither party can self-revoke without introducing the NRD delay. The other party always has the opportunity to revoke first. Self-revocation cannot be used to lock funds up indefinitely.

----

#### Rollout/Deployment (HF3)

The following rules will be enforced during rollout as part of HF3 -

__Assumptions:__

1. HF3 will occur at height 786,240.
2. Blocks at height >= 786,240 will have block version >= 4.

__Block Specific Rules:__

1. A block containing NRD kernel(s) is only be valid if block version >= 4.
2. A block containing NRD kernel(s) is only valid if all defined relative lock height rules are met.
3. Two duplicate NRD kernel instances cannot exist in the same block.

__Transaction Specific Rules:__

1. A transaction containing NRD kernel(s) will not be accepted by the local txpool/stempool unless chain head version >= 4.
2. A transaction containing NRD kernel(s) will not be relayed or broadcast to other nodes unless chain head version >= 4.
3. A transaction containing NRD kernel(s) will not be accepted by the local txpool/stempool unless it meets the defined relative lock height rule in the next block.
4. A transaction containing NRD kernel(s) will not be relayed or broadcast to other nodes unless it meets the defined relative lock height rule in the next block.
5. Two duplicate NRD kernel instances cannot exist in the txpool/stempool concurrently.

#### Weights & Fees

For the purpose of block weight calculations, each kernel is treated as 3 "weight units" where each unit is approximately 32 bytes. This covers the excess commitment and the associated signature common across all kernel variants.
The additional 2 bytes of "relative height" on NRD kernels are ignored for the purposes of calculating block weight.

For the purpose of minimum transaction relay fees all kernels are treated as 1 "fee unit" with each unit being 1 milligrin.
We plan to revisit the entire transaction fee structure in a future RFC. Kernel variants may affect the transaction fee calculations differently in the future.

# Drawbacks
[drawbacks]: #drawbacks

NRD kernels are a limited and restricted form of "relative locks" between kernels. These locks are limited to a period of 7 days and "fail open" beyond that window. This approach meets the requirements for limited revocable payment channel operations but there are likely to be use cases where this approach is not sufficient or unsuitable.

While it would be nice to provide a fully general purpose solution that would allow arbitrary locks to be implemented, it does appear to be hard, if not impossible, to do this in Grin/MW.

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

Referencing historical data in Grin and in Mimblewimble in general is difficult due to the possibility of pruning historical data. It is not possible to reference old outputs once they are spent. Historical validators must have access to any referenced data to validate consensus rules. This leaves transaction kernels as the only available data to be referenced. While arbitrary historical kernels _can_ be referenced this is not desirable as we do not want to impose additional constraints on nodes, requiring them to maintain historical data that would otherwise be prunable.

An earlier design iteration was "No Such Kernel Recently" (NSKR) locks. Where NRD references were implicit, with duplicate kernel excess commitments, NSKR kernels referenced prior kernels explicitly. These explicit references were problematic for several reasons -

* Additional overhead, both local storage and network traffic due to the explicit references.
* Optimization by referencing prior kernel based on MMR position introduced a dependency on external data (kernels can no longer be validated in isolation).
* Permitting non-existence of references due to limited window of history, opened up a vector for "spam" where arbitrary data could be used in place of a valid reference.

To prevent "spam" a signature can be used to verify the reference was indeed a valid commitment. By including a signature along with the commitment, the reference is effectively a full transaction kernel.

The idea of using Merkle proofs to verify inclusion of a historical referenced kernel in the kernel MMR was also considered. This gets expensive both in terms of transaction size and increased verification cost. There is also the problem of position not yet being known at transaction creation time, necessitating Merkle proof generation at block creation time by miners which adds complexity.

# Prior art
[prior-art]: #prior-art

Bitcoin allows transaction inputs to be "encumbered" with a relative locktime based on the sequence number field. This restricts an input from spending the associated output until a certain number of blocks have passed. BIP112 describes the CHECKSEQUENCEVERIFY opcode in Bitcoin and BIP68 describes the underlying consensus changes around the sequence number field.

* [Timelock#CheckSequenceVerify (bitcoin wiki)][6]
* [CheckSequenceVerify (bitcoin wiki)][7]
* [Bitcoin BIP-0068][8]
* [Bitcoin BIP-0112][9]

Note that relative locks in Bitcoin are based on transaction _inputs_ and _outputs_, with inputs only able to spend outputs once confirmed beneath a certain number of blocks. We cannot do this in Grin due to the pruning of old data. Spent outputs will eventually be removed and cannot be relied upon as part of the validation process. Bitcoin encumbers individual outputs whereas in Grin we encumber transactions via the constituent transaction kernels.

# Unresolved questions
[unresolved-questions]: #unresolved-questions

Some investigation is still needed around the conditions necessary to allow a kernel to simply be reused with an adjustment to the kernel offset and where an additional kernel is necessary. An adjustment to the kernel offset will expose the private excess under certain conditions and cannot be done safely for all transactions.

One outstanding question is what use cases are not covered by NRD kernels. We believe them to be sufficient for the revocable payment channel close mechanism. But they may not be sufficient for all use cases.

[Succinct Atomic Swaps (SAS)][10] describes the use of both relative locks and [adaptor signatures][11] to implement atomic swaps with only two on-chain transactions. The secret associated with the adaptor signature is swapped to allow funds to be claimed while the relative lock locks funds prior to a refund being claimed. We note that NRD kernels and adaptor signatures are not directly compatible as a prior instance of an NRD kernel would have revealed the secret associated with the adaptor signature. That said we can produce transactions with multiple kernels and we can use this to isolate the adaptor signature on a separate kernel alongside an NRD kernel. It is an unresolved question if there is a way to modify the SAS protocol and avoid the need for these additional kernels in Grin/MW.  

# References
[references]: #references

* [Original "triggers" mailing list post by Ruben Somsen][1]
* ["No Such Kernel Recently" post by John Tromp][2]
* ["Duplicate Kernels" post by Antioch][3]
* ["NRD based payment channel" post by John Tromp][4]
* [Earlier NSKR based payment channel design)][5]
* [Timelock#CheckSequenceVerify (bitcoin wiki)][6]
* [CheckSequenceVerify (bitcoin wiki)][7]
* [Bitcoin BIP-0068][8]
* [Bitcoin BIP-0112][9]
* [Succinct Atomic Swaps by Ruben Somsen][10]
* [Scriptless Scripts][11]
* [RFC-0005 "Variable Size Kernels"][12]

[1]: https://lists.launchpad.net/mimblewimble/msg00025.html 
[2]: https://lists.launchpad.net/mimblewimble/msg00635.html 
[3]: https://lists.launchpad.net/mimblewimble/msg00635.html 
[4]: https://lists.launchpad.net/mimblewimble/msg00636.html 
[5]: https://gist.github.com/antiochp/78fe813b6c2c0612593f8747390a8aae
[6]: https://en.bitcoin.it/wiki/Timelock#CheckSequenceVerify
[7]: https://en.bitcoin.it/wiki/CheckSequenceVerify
[8]: https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki
[9]: https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki
[10]: https://www.reddit.com/r/Bitcoin/comments/gi6ciw/sas_succinct_atomic_swaps_half_the_number_of/
[11]: http://diyhpl.us/wiki/transcripts/layer2-summit/2018/scriptless-scripts/ 
[12]: https://github.com/mimblewimble/grin-rfcs/blob/master/text/0005-variable-size-kernels.md
