
- Title: enable-faster-sync
- Authors: [Antioch Peverell](mailto:apeverell@protonmail.com), [John Tromp](mailto:john.tromp@gmail.com)
- Start date: Oct 25, 2019
- RFC PR: [mimblewimble/grin-rfcs#29](https://github.com/mimblewimble/grin-rfcs/pull/29) 
- Tracking issue: [mimblewimble/grin-wallet#3173](https://github.com/mimblewimble/grin-wallet/issues/3173)

---

# Summary
[summary]: #summary

This RFC introduces changes that reduce the time it takes for a node joining the Grin network to fully sync. Data can be downloaded in batches and partially verified without the bottleneck of waiting to receive all data. These batches can be requested from multiple peers in parallel and verified as they are received. This improves the performance and the robustness of the "fast sync" process and allows for futher improvements to be explored in the future. A consensus change is required to facilitate this, with a change to what we commit to in each block header. We propose making this consensus change as part of the upcoming scheduled hardfork (HF2 scheduled for Jan 2020).

# Motivation
[motivation]: #motivation

The initial sync process involves downloading all kernels, all unspent outputs and their corresponding rangeproofs. The unspent outputs are maintained in a "Prunable Merkle Mountain Range" (PMMR). Briefly, this consists of unpruned output data, a set of intermediate hashes representing pruned subtrees and a "leafset" bitmap representing the position of unpruned, unspent outputs in the PMMR.

The previous implementation packaged all of the above data into a single zip file, requested and received from a single peer. This was both a performance bottleneck and a single point of failure. To increase reliability and performance we split this data up into smaller chunks and request from multiple peers.

It was previously only possible to validate the _full_ set of unspent outputs. We were unable to validate a partial set of outputs as we compared the total output sum to the total kernel sum plus the total kernel offset. By design, there is no partial kernel sum to compare against a partial output sum.

This RFC describes how we split the output PMMR into subtrees, requesting these subtrees along with the corresponding bitmap fragment and the necessary Merkle proofs. Each output subtree can be verified with its corresponding bitmap fragment. By committing to the leafset bitmap in addition to the output PMMR we can verify the output subtrees.

The final "sum to zero" validation remains unchanged but the partial verification of the individual output subtrees allows for more granular, and earlier verification of the data as it is received.

# Community-level explanation
[community-level-explanation]: #community-level-explanation

Validation of full transaction history is not necessary when joining the Grin network and access to full block history is not required. The initial sync process involves downloading all block headers, all kernels, all unspent outputs and their corresponding rangeproofs. Historical spent outputs are not necessary for validation. Nodes prune historical spent outputs, with a few days of recent history retained. Kernels are not pruned and must be retained indefinitely.

The unspent outputs are maintained in a "Prunable Merkle Mountain Range" (PMMR). Briefly, this consists of unpruned output data, a set of intermediate hashes representing pruned subtrees and a "leafset" bitmap representing the position of unpruned, unspent outputs in the PMMR. Subtrees of the output PMMR are requested from peers and these subtrees are verified together with the corresponding fragment of the leafset bitmap. Merkle proofs are provided to prove inclusion of both the output subtree and bitmap fragments beneath the root committed to in the block header. Once all subtrees are received and verified, the unspent outputs are summed together and checked against the sum of all kernels plus the kernel offset from the block header.

This allows us to download outputs from multiple peers, in parallel and verify them as they are received.
The node does not need to wait for the full output PMMR to be received before validation can begin.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

The leafset bitmap is committed to by splitting the bitmap into smaller fragments, adding these fragments to an MMR and committing to the root of the bitmap MMR.

The leafset bitmap represents leaf positions, in insertion order, of the underlying output PMMR. The output PMMR is append-only and the order of these outputs does not change. The first (leftmost) bit in the bitmap maps directly to the first output inserted into the output PMMR. The next bit in the bitmap maps to the second output inserted into the output PMMR etc. The bitmap `11100010` represents outputs `[0, 1, 2, 6]` in the PMMR. The bitmap is then split into smaller fragments of 1024 bits, representing contiguous sequences of bits of the bitmap. The two fragments `0000...0001, 1000...0000` represent outputs `[1023, 1024]` in the output PMMR. Every fragment is exactly 1024 bits in length with the final fragment padded with `0` values to fill the full 1024 bits.

The bitmap MMR itself is not append-only as fragments of the bitmap will be updated over time as outputs are spent. Recent outputs are more likely to be spent than old output, resulting in updates clustering around the most recent (rightmost) fragments in the MMR. This has the nice property of minimizing the amount of updating and rehashing necessary to keep the bitmap MMR updated over time as older fragments will change only rarely.

Merkle proofs can be provided for both a subtree of the output PMMR and a fragment in the bitmap MMR. These are used during validation to locate the output subtree in the overall output PMMR and to verify the bitmap fragment corresponds to the same output positions.

To commit to the root of both the output PMMR and the root of the bitmap MMR we hash the roots together 
and commit to this single composite root `H(output_root|bitmap_root)` in the the block header.
This allows us to reuse the existing `output_root` field on the header to commit to both MMR roots.


# Drawbacks
[drawbacks]: #drawbacks

These changes necessitate a change to the data committed to in the block header. This is a consensus breaking change and comes with all risks and complexity inherent to any consensus breaking change. As block headers are retained indefinitely the implementation will need to maintain compatibility for headers pre and post hardfork indefinitely.

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

We believe we cannot make the desired changes to fast sync without committing to the leafset bitmap. 
The previous approach of implicitly validating this as part of the overall "sum to zero" kernel validation does not allow for a batched approach. The previous approach was by design "all or nothing" with validation only possible once we have downloaded the full set of kernels and unspent outputs.

The details are around precisely how to commit to this bitmap and there are various alternatives possible here.
The leafset bitmap is implemented as a "roaring bitmap" internally but we want to commit to a canonical representation of this data. The obvious choice here is the uncompressed bitmap data itself. We could simply hash the full bitmap but this is not efficient as we would need to rehash all the data for every block header. The other extreme would be to treat each individual bit in the bitmap as a leaf of a Merkle tree. This would also be inefficent as we would require a 32 byte hash for every individual bit. The proposed solution is to break the bitmap up into smaller chunks and add these chunks as leaves of an MMR. Recent outputs are more likely to be spent than older outputs and bitmap chunks to the right of the MMR
are more likely to change over time. These rightmost chunks have shorter paths to the associated peak in the MMR with correspondingly shorter Merkle proofs. The cost of updating more recent fragments is also minimized as the number of rehashing operations up to the peak is small.

The proposal is to break the bitmap up into 1024 bit (128 byte) chunks and use these as leaves in the bitmap MMR.

The other question is what data to add to the header itself. We propose combining the bitmap root and the output MMR root into a single `output_root` hash on the block header. This changes the semantics of the existing `output_root` field. This solutiuon has the advantage of maintaining the existing header serialization. No new header field would be necessary.
An alternative solution would be to keep the two MMR roots separate and to introduce the new bitmap root as a new header field. The would affect serialization at both the p2p layer and the local database and would add significant complexity to the implementation. 

The two roots are closely related and we propose committing to them together as a single combined hash.

# References
[references]: #references

* [Merkle Mountain Range (OpenTimestamps)](https://github.com/opentimestamps/opentimestamps-server/blob/532033b465c3b09c9db2a9064de03230c7e2e28e/doc/merkle-mountain-range.md)

* [Prunable Merkle Mountain Ranges (Grin)](https://github.com/mimblewimble/grin/blob/67057ab36d606072c543b2741e33496c6affd6ab/doc/mmr.md)
