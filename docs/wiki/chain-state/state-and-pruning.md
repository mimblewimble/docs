# State and Pruning

> *Read this in other languages: [Korean](https://github.com/mimblewimble/grin/blob/master/doc/translations/pruning_KR.md), [简体中文](https://github.com/mimblewimble/grin/blob/master/doc/translations/pruning_ZH-CN.md).*

## State Storage

Recall that the Grin chain includes the following data:

1. Outputs, which include for each output:
    1. A Pedersen commitment (33 bytes).
    1. A range proof (640KB).
1. Inputs, which are just output references (32 bytes).
1. Transaction kernels, which include for each transaction:
    1. The excess commitment sum for the transaction (33 bytes).
    1. A signature generated with the excess (~70 bytes).
1. A block header with a valid proof of work and roots of the Merkle trees.

Each node maintains 3 MMRs:

* An output set MMR.
* Rangeproofs MMR.
* Transaction kernels MMR.

!!! info ""
    All outputs, rangeproofs and kernels are added in their respective MMRs in the order they occur in each block (recall that block data is required to be sorted).

## Pruning

As outputs get spent, both their commitment and rangeproof data can be
removed. In addition, the corresponding output and range proof MMRs can be
pruned of their hash entires.

!!! note "PMMR"
    A pruned MMR is referred to as a PMMR.

Following pruning, the full state of the chain consists of the following data:

* The unspent output set (UTXO).
* A rangeproof for each unspent output.
* All transaction kernels.

In addition, all block headers are required to anchor the above state
with a valid proof of work (the state corresponds to the most worked chain).

## Validation

Pruning removes as much data as possible while keeping all the
guarantees of a full Mimblewimble-style validation. This is necessary to keep
a pruning node state's sane, but also on first fast sync, where only the
minimum amount of data is sent to a new node.

The full validation of the chain state requires that:

* All kernel signatures verify against their public keys (excess commitments).
* The sum of all UTXO commitments minus the supply is a valid public key.
* The sum of all kernel public keys equals the above public key (sum of UTXO commitments minus supply).
* The root hashes of the UTXO PMMR, the range proofs PMMR and the kernels MMR
  match a block header with a valid proof of work chain.
* All range proofs are valid.

While not necessary to validate the full chain state, accepting and validating new blocks also requires the output features (coinbase or plain), making the full output data necessary for all UTXOs.

At minimum, this requires the following data:

* The block headers chain.
* All kernels, in order of inclusion in the chain. This also allows the
  reconstruction of the kernel MMR.
* All unspent outputs.
* The UTXO MMR and the range proof MMR (to learn the hashes of pruned data).
