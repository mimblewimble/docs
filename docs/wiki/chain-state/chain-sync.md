# Chain Sync

> *Read (part of) this in other languages: [Korean](https://github.com/mimblewimble/grin/blob/master/doc/chain/chain_sync_KR.md).* </br>

We describe here the different methods used by a new node when joining the network to catch up with the latest chain state. We start with reminding the reader of the following assumptions, which are all characteristics of Grin or Mimblewimble:

* All block headers include the root hash of all unspent outputs in the chain at
  the time of that block.
* Inputs or outputs cannot be tampered with or forged without invalidating the
  whole block state.

We intentionally only focus on major node types and high level algorithms that may impact the security model. Detailed heuristics that can provide some additional improvements (like header first), while useful, will not be mentioned in this document.

## Full History Syncing

This model is the one used by full nodes on most major public blockchains. The
new node has prior knowledge of the genesis block. It connects to other peers in
the network and starts asking for blocks until it reaches the latest block known to its peers.

The security model here is similar to Bitcoin. We're able to verify the whole
chain, the total work, the validity of each block, their full content, etc.
In addition, with Mimblewimble and full UTXO set commitments, even more integrity validation can be performed.

We do not try to do any space or bandwidth optimization in this mode (for example, once validated the range proofs could possibly be deleted). The point here is to provide history archival and allow later checks and verifications to be made.

However, such full history sync, also called Initial Block Download (IBD), is unnecessary for a new node to fully validate the Grin chain history, as most blocks may be only partially downloaded.

## Fast Sync

We call `fast sync` the process of synchronizing a new node, or a node that hasn't been keeping up with the chain for a while, and bringing it up to the latest known most-worked block. In this model we try to optimize for very fast syncing while sacrificing as little security assumptions as possible. As a matter of fact, the security model is almost identical as a full history sync, despite requiring orders of magnitude less data to download.

At a high level, a fast-sync goes through the following process:

1. Sync all block headers on the most worked chain as advertized by other nodes. Also, pick a header sufficiently back from the chain head. This is called the node horizon as it's the furthest a node can reorganize its chain on a new fork if it were to occur without triggering another new full sync.
1. Once all headers have are synced, Download the full state as it was at the horizon, including the unspent output, range proof and kernel data, as well as all corresponding MMRs. This is just one large zip file named `txhashset`.
1. Validate the full state.
1. Download full blocks since the horizon to reach the chain head.

A new node is pre-configured with a horizon `Z`, which is a distance in number of blocks from the head. For example, if horizon `Z=5000` and the head is at height `H=23000`, the block at horizon is the block at height `h=18000` on the most worked chain.

The new node also has prior knowledge of the genesis block. It connects to other
peers and learns about the head of the most worked chain. It asks for the block
header at the horizon block, requiring peer agreement. If consensus is not reached at `h = H - Z`, the node gradually increases the horizon `Z`, moving `h` backward until consensus is reached. Then it gets the full UTXO set at the horizon block.

With this information it can verify:

* The total difficulty on that chain (present in all block headers).
* The sum of all UTXO commitments equals the expected money supply.
* The root hash of all UTXOs match the root hash in the block header.

Once the validation is done, the peer can download and validate the blocks content
from the horizon up to the head.

While this algorithm still works for very low values of `Z` (or in the extreme case
where `Z=1`), low values may be problematic due to the normal forking activity that
can occur on any blockchain. To prevent those problems and to increase the amount
of locally validated work, we recommend values of `Z` of at least a few days worth
of blocks, up to a few weeks.

## Security Discussion

While this sync mode is simple to describe, it may seem non-obvious how it still
can be secure. We describe here some possible attacks, how they're defeated and
other possible failure scenarios.

### An attacker tries to forge the state at horizon

This range of attacks attempt to have a node believe it is properly synchronized
with the network when it's actually is in a forged state. Multiple strategies can
be attempted:

* Completely fake but valid horizon state (including header and proof of work).
  Assuming at least one honest peer, neither the UTXO set root hash nor the block
  hash will match other peers' horizon states.
* Valid block header but faked UTXO set. The UTXO set root hash from the header
  will not match what the node calculates from the received UTXO set itself.
* Completely valid block with fake total difficulty, which could lead the node down
  a fake fork. The block hash changes if the total difficulty is changed, no honest
  peer will produce a valid head for that hash.

### A fork occurs that's older than the local UTXO history

Our node downloaded the full UTXO set at horizon height. If a fork occurs on a block
at an older horizon H+delta, the UTXO set can't be validated. In this situation the
node has no choice but to put itself back in sync mode with a new horizon of
`Z'=Z+delta`.

Note that an alternate fork at Z+delta that has less work than our current head can
safely be ignored, only a winning fork of total work greater than our head would.
To do this resolution, every block header includes the total chain difficulty up to
that block.

### The chain is permanently forked

If a hard fork occurs, the network may become split, forcing new nodes to always
push their horizon back to when the hard fork occurred. While this is not a problem
for short-term hard forks, it may become an issue for long-term or permanent forks.
To prevent this situation, peers should always be checked for hard fork related
capabilities (a bitmask of features a peer exposes) on connection.

### Several nodes continuously give fake horizon blocks

If a peer can't reach consensus on the header at h, it gradually moves back. In the
degenerate case, rogue peers could force all new peers to always become full nodes
(move back until genesis) by systematically preventing consensus and feeding fake
headers.

While this is a valid issue, several mitigation strategies exist:

* Peers must still provide valid block headers at horizon `Z`. This includes the
  proof of work.
* A group of block headers around the horizon could be asked to increase the cost
  of the attack.
* Differing block headers providing a proof of work significantly lower could be
  rejected.
* The user or node operator may be asked to confirm a block hash.
* In last resort, if none of the above strategies are effective, checkpoints could
  be used.
