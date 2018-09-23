# Current state of Grin's data stores

The db_root = .grin setting in grin.toml decides where grin stores its big
and small data.

The chain is the biggest in size. It's stored in a key-value database
using Rocksdb (like Leveldb) and has the following contents:

````
.grin/chain - handled by chain::store (key prefix: "chain")
	"h" + hash -> block header
	"b" + hash -> block
	"H" + hash -> head
	"I" + ? -> header head
	"s" + ? -> sync head
	"8" + ? -> header height
	"o" + ... -> output by commit  -- to be deprecated
	"p" + ... -> header by output  -- to be deprecated
	"c" + ? -> commit pos
	"k" + ? -> kernel pos
````
A grin node that does not archive the full chain can prune a lot of this data.

There is also a small rocksdb listing all known peers:
````
.grin/peers - handled by peer::store (prefix: "peers")
	"p" + some id -> serde-serialized peer (address, status, ban timeout)
````
The PMMR data structure is used for several things, and the biggest
in size is utxo - the full list of unspent coins.
````
sumtrees/kernel  Just an append-only Merklish tree, neither sum nor pruning are used.
sumtrees/rangeproof  The PMMR is just a prunable tree. The summation isn't used.
sumtrees/utxo Summation, Merklish tree of all valid UTXOs
````

# Understanding kernels

@dmdeemer pasted https://pastebin.com/aCdznJW1 and there was a Lobby discussion with @tromp

Q: Is it necessary for all nodes to store the set of tx kernels?

A: They're needed for new full nodes to sync, so archival full nodes must store them.

Q: Do we need to store all kernels, forever?

A: ....yes.... they are necessary for a new client to validate the chain.

JT: If the whole history is A->B with kernel kAB and B->C (same amount, i.e. 0 change) with kernel kBC then you cannot forget kAB, even though there's only 1 UTXO. Only the sum of kAB and kBC proves 0-inflation. B and C cannot sign for kAB+kBC, that would still need A.

JT: Excess values combine blinding factors from different parties, and therefore need both parties to sign. Excess values must relate inputs and outputs in order to prove 0 inflation. Specifically, they prove that sum outputs minus sum inputs is a commitment to 0.

D: Ok, I need a concrete example...
````
Alice has 1 Grin. She sends it to Bob

Half-transaction:
(b1*G + 1*H) + (e1*G) = ...

Bob needs to know the amount, 1 Grin, and the sum 
of the blinding values (b1+e1)  Alice can tell 
him that, because she remembers b1 and e1.

Bob then picks b2 and e2, such that b1+e1 = b2+e2,
and completes the transaction:

(b1*G + 1*H) + (e1*G) = (b2*G + 1*H) + (e2*G)
````

D: And now I see the problem... Alice just told bob exactly the opening information Bob will later need to spend his output. D'oh!

JT: It's not safe for parties to tell each other blinding factors. See the mailing list discussion for how to transact properly. Specifically https://lists.launchpad.net/mimblewimble/msg00087.html and the later https://lists.launchpad.net/mimblewimble/msg00091.html

# Grin dev discussion about #215 (the lock_height switch commit stuff)

To land https://github.com/mimblewimble/grin/pull/215 the plan is:

 * Extend wallet (for now) to store a Merkle proof.
   (for starters it's simpler to store these in the wallet, before we endpoints in place. And recreating them from scratch could be made part of `wallet recover`)
 * Remove both get_output_by_commit and get_block_header_by_output_commit (see changes in https://github.com/mimblewimble/grin/pull/580)
 * The only commitment or output index is what the sumtrees offer. Any additional information needs to be provided to spend.
 * (No new index needed to map commitment|block_hash -> pmmr pos. We can lookup the block with that hash)
 * Only full (archival) nodes can surely know if a coinbase output is locked or not (1000 confirms)
 * Wallet recovery still works.
 * Miners must remember which output they mined where, or rely on `wallet recover`

The changes to the pmmr to maintain switch commits should be fairly small.

For the output pmmr on a non-archival node, instead of a block hash, we'll require a Merkle proof.
	 (The path has a list of hashes in the MMR from the output to the root.)
	 This is going to be large. We can figure out more succinct encoding later.
	 Output PMMR looks the exact same, but you don't have any older block data.
	 The output hash is first on the path, and the root which is at the end of the path is in the block header,
	 so the path can't be falsified.

We save the roots (which we recalculate for every block) on the block header.
The Merkle proof proves that the output is in that block header.
We might need an index from UTXO root to block hash but that's good to have anyway.
If I send you a UTXO set as of block 1000, the roots tie the headers to what I sent you, and the headers tie up proof-of-work not for inclusion no, but the roots will be checked by fast sync.

# Grin dev - questions about tracking/validating coinbases via features flags/height

@sesam - to your earlier question, we've been battling the issue around "do we need info in addition to the commitment" and we've come to consensus that we do - we cannot get this to work without storing something additional.

The approach in #615 takes the path of hashing the features into the values in the output MMR (in addition to the commitment)

Without this we have no reliable way of knowing if

  a) the miner is not being honest about spending a coinbase output (potentially early before it matures)

  b) if the output we find in the MMR is actually the one we think it is (in the presence of a fork in the chain)

its "possible" for a miner to construct a set of outputs (reusing wallet keys in a subversive way) to attempt to spend a coinbase output by "pretending" it is actually a non-coinbase output with a value of 60 grin (same as a coinbase one) - thus attempting to circumvent the coinbase maturity rules intentionally (or accidentally)

I'm willing to bet some test grin at least that some of the consensus issues we've seen on testnet1 are related to this issue. Specifically around a miner restoring their wallet or starting a wallet from scratch (and reusing some keys) as they generate new coinbase outputs, potentially on their own fork.


> s: So, for a) there must be something tying the mining coinbase reward so it's spent only once, and there must be some way to verify its lock height = birth + 1000.
> But for b) how can features help with tying in coinbase outputs?
> I admit I've only been thinking on the information carrying - logical part, with no regard to how cut-through could affect things.

We got rid of the rocksdb index that mapped commitments to outputs, so the only way to retrieve a full output now is to go get the full block from rocksdb and look in the outputs.

But - we do not want to do this for every output, only for coinbase outputs - and we identify coinbase outputs by their feature flags.

So basically features is the smallest piece of additional data to pass around that lets us go find the full output (actually go find the height of the block itself) in a way that we can validate the miner/sender is not being dishonest with.
So actually we need features + optional block hash.
Non-coinbase can be validated without the block hash.
Coinbase we go find the block and calculate the lock_height.
And this approach is still going to work for non-archival nodes once we implement "merkle proofs" - so we can verify an output was included in a block, just using the block_header and not the full block.
But we will still need to prove somehow that the miner is being honest about coinbase vs non-coinbase - and we will do this with the features passed as part of the input
does that make sense?

> S: keeping 8 extra bits per output to avoid I/O seems nice. I wrote on the mailing list about what other feature flags could be foreseen. If none are, there would still be an option to track coinbases and typical outputs in separate piles, and forcing miners to convert their coinbases to typical outputs within some time window; and when they do the conversion, the burden is on them to supply all the data needed, so someone with only headers could validate. Though I suspect such an approach instead would mean adding a hash (160+ bits?) to each block header, compared to 8bits for each Output.

right - you either track "coinbase" on the output itself or on the block/block_header somehow

> s: Good. Is tx lock_height going to be supported for transactions also going forward?

I think the benefit of maintaining this on the output itself is the output is "just another output" from the perspective of most of the system and network

The tx lock_height was something I implemented early on - I believe so yes, its a simpler concept than the coinbase maturity.
A tx is only accepted by the network if its lock_height is <= the current height of the chain.

> s: Sure, encapsulating outputs like that is great, and there are no secrets in the features flags (yet) so even if we later decide for different storage models, the same way to hash outputs can be kept

so you could in theory create and sign a tx "offline" - but you need to wait for a specific height before you can broadcast it to the network
(wallet impl today does not provide any mechanism to do this)

> s: are we also hashing in the lock_height, or are we carrying that information around in the output at all times? I'm thinking that after an output is created, in a way, only its owner might need all the data, or a compounded form of all data, while validators would only need "the right numbers" and rely on that nobody found a way to break the hashes. Assuming birthday collision isn't enough.

Ahh so the lock_height is now implicit - we don't pass it around and we don't store it anywhere - we know we can recreate it based on the height of output block (that created the coinbase output) -- which loops us back to needing the block hash and the feature flags.
