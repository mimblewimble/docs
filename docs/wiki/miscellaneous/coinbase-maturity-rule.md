# Coinbase Maturity Rule (aka Output Lock Heights)

*Read this in other languages: [Korean](https://github.com/mimblewimble/grin/blob/master/doc/translations/coinbase_maturity_KR.md), [简体中文](https://github.com/mimblewimble/grin/blob/master/doc/translations/coinbase_maturity_ZH-CN.md).*

## Overview

Coinbase outputs (block rewards & fees) are "locked" and require 1,440 confirmations (i.e 24 hours worth of blocks added to the chain) before they mature sufficiently to be spendable. This is to reduce the risk of later txs being reversed if a chain reorganization occurs.

Bitcoin does something very similar, requiring 100 confirmations (Bitcoin blocks are every 10 minutes, Grin blocks are every 60 seconds) before mining rewards can be spent.

Grin enforces coinbase maturity in both the transaction pool and the block validation pipeline. A transaction containing an input spending a coinbase output cannot be added to the transaction pool until it has sufficiently matured. Similarly a block is invalid if it contains an input spending a coinbase output before it has sufficiently matured.

The maturity rule *only* applies to coinbase outputs, regular transaction outputs have an effective lock height of zero.

## Mimblewimble Output Lock Height

An output consists of:

* Features (currently coinbase vs. non-coinbase)
* Commitment `rG+vH`
* Rangeproof

To spend a regular transaction output two conditions must be met. We need to show the output has not been previously spent and we need to prove ownership of the output.

A Grin transaction consists of the following:

* A set of inputs, each referencing a previous output being spent.
* A set of new outputs that include -
    * A value `v` and a blinding factor (private key) `r` multiplied on a curve and summed to be `rG+vH`
    * A range proof that shows that v is non-negative.
* An explicit transaction fee in the clear.
* A signature, computed by taking the excess blinding value (the sum of all outputs plus the fee, minus the inputs) and using it as the private key.

We can show the output is unspent by looking for the commitment in the current Output set. The Output set is authoritative; if the output exists in the Output set we know it has not yet been spent. If an output does not exist in the Output set we know it has either never existed, or that it previously existed and has been spent (we will not necessarily know which).

To prove ownership we can verify the transaction signature. We can *only* have signed the transaction if the transaction sums to zero *and* we know both `v` and `r`.

Knowing `v` and `r` we can uniquely identify the output (via its commitment) *and* we can prove ownership of the output by validating the signature on the original coinbase transaction.

Grin does not permit duplicate commitments to exist in the Output set at the same time.
But once an output is spent it is removed from the Output set and a duplicate commitment can be added back into the Output set.
This is not necessarily recommended but Grin must handle this situation in a way that does not break consensus across the network.

Several things complicate this situation -

1. It is possible for two blocks to have identical rewards, particularly for the case of empty blocks, but also possible for non-empty blocks with transaction fees.
1. It is possible for a non-coinbase output to have the same value as a coinbase output.
1. It is possible (but not recommended) for a miner to reuse private keys.

Grin does not allow duplicate commitments to exist in the Output set simultaneously.
But the Output set is specific to the state of a particular chain fork. It *is* possible for duplicate *identical* commitments to exist simultaneously on different concurrent forks.
And these duplicate commitments may have different "lock heights" at which they mature and become spendable on the different forks.

* Output O<sub>1</sub> from block B<sub>1</sub> spendable at height h<sub>1</sub> (on fork f<sub>1</sub>)
* Output O<sub>1</sub>' from block B<sub>2</sub> spendable at height h<sub>2</sub> (on fork f<sub>2</sub>)

The complication here is that input I<sub>1</sub> will spend either O<sub>1</sub> or O<sub>1</sub>' depending on which fork the block containing I<sub>1</sub> exists on. And crucially I<sub>1</sub> may be valid at a particular block height on one fork but not the other.

Said another way - a commitment may refer to multiple outputs, all of which may have different lock heights. And we *must* ensure we correctly identify which output is actually being spent and that the coinbase maturity rules are correctly enforced based on the current chain state.

A coinbase output, locked with the coinbase maturity rule at a specific lock height, *cannot* be uniquely identified, and *cannot* be safely spent by their commitment alone. To spend a coinbase output we need to know one additional piece of information -

* The block the coinbase output originated from

Given this, we can verify the height of the block and derive the "lock height" of the output (+ 1,000 blocks).
