
`lock height`
  For coinbase coins (outputs), they must be locked for a while (1000 confirmations or around 17 hours) or else chain reorganisations will cause a lot of trouble.

`mmr`
  Merkle Mountain Range

`pmmr`
  Pruneable Merkle Mountain Range

`output` [(defined here)](https://github.com/mimblewimble/grin/blob/master/core/src/core/transaction.rs#L479)
	OutputFeatures - currently a Boolean == coinbase or not ("Options for an output's structure or use")
	Commitment - `rG+vH` The homomorphic commitment representing the output's amount
	SwitchCommitHash - `blake2(rJ)` The switch commitment hash, a 160 bit length blake2 hash of blind*J
	RangeProof - A proof that the commitment is in the right range

`input` [(defined here)](https://github.com/mimblewimble/grin/blob/master/core/src/core/transaction.rs#L375)
	A reference to an output being spent by a transaction.

`switch commitment`
      a hash of something, like the blinding pubkey

`grins`, `milligrins`
  used to denominate coins (chosen by popular vote on the mailing list)

`kernel`
  the core piece of a transaction, and one that must be kept also when transactions are merged.
  A kernel consists of the sum of the commitments of that tx, rangeproofs and a tx fee.

`pre-image`
  A is a preimage of B if B = hash(A)

`sumtree`
   used before - replaced with something similar but witout including any sums

### Elliptic algebra

`C`
  is a Pedersen commitment (homomorphic commitment) [(defined here)](https://download.wpsoftware.net/bitcoin/wizardry/mimblewimble.txt). `C = rG+vH`

`G` and `H` are fixed nothing-up-my-sleeve elliptic curve group generators.

`v` is the amount. 

`r` is a secret random blinding key

`rJ`
  [switch commitment](https://people.mmci.uni-saarland.de/~truffing/papers/switch-commitments.pdf). Kept private. Derived from wallet private keys.

`kG`
  (Excess values?)

`bJ` (to be verified)
   is a public key on generator J, with b = blind, J=curve generator? ("compute b (by solving dlog) [...] and you know nothing about `x` Also look at Lemma 4.1 in 
https://eprint.iacr.org/2017/604 or Lemma 1 in https://eprint.iacr.org/
2013/606.pdf." /Tim Ruffing)

`r + hash(vH + rG || v || r)`
   [Discussed here](https://gitter.im/grin_community/dev?at=5ab2e2d1fa066c532558de57) as a possible solution both to QC and wallet restore. Too good? This idea come out as a reaction after we tried to cut out [grins Switch Commitments](https://lists.launchpad.net/mimblewimble/msg00373.html).