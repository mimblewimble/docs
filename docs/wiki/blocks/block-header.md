# Block Header

General format of a **Block Header** in a Mimblewimble/Grin:

| Field        | Description           | Size  |
|:-------------|:-------------|:-----|
| version   | Version of the block | 2 bytes  |
| height   | Height of this block since the genesis block (height 0)  | 8 bytes  |
| timestamp   | Timestamp at which the block was built | 8 bytes  |
| prev_hash   | Hash of the block previous to this in the chain | 32 bytes  |
| prev_root   | Root hash of the header MMR at the previous header | 32 bytes  |
| output_root  | Merkle root of all the commitments in the TxHashSet | 32 bytes  |
| range_proof_root | Merkle root of all range proofs in the TxHashSet | 32 bytes  |
| kernel_root | Merkle root of all transaction kernels in the TxHashSet | 32 bytes  |
| total_kernel_offset | Total accumulated sum of kernel offsets since genesis block. | 32 bytes  |
| output_mmr_size | Total size of the output MMR after applying this block. | 8 bytes  |
| kernel_mmr_size | Total size of the kernel MMR after applying this block. | 8 bytes  |
|   |   | Sub-Total: **226** bytes  |
| - | - | - |
| pow  | Proof of work data | For cuck(AR)oo 29: 174 bytes.<br>For cuck(AT)oo 32: 189 bytes. |
|   |   | Total:<br> **400** bytes for C29<br>or **415** bytes for C32  |

## PoW

General format of a **Proof Of Work** in a Mimblewimble/Grin:

| Field        | Description           | Size  |
|:-------------|:-------------|:-----|
| total_difficulty   | Total accumulated difficulty since genesis block | 8 bytes  |
| secondary_scaling   | Variable difficulty scaling factor for secondary proof of work  | 4 bytes  |
| nonce | Nonce increment used to mine this block. | 8 bytes  |
| proof   | Proof of work data | cuckoo_size: 1byte<br>cuckoo_solution of C29: 42&lowast;29 bits=153 bytes<br>cuckoo_solution of C32: 42&lowast;32 bits=168 bytes  |
|   |   | Sub-Total: **174** bytes for C29 and **189** bytes for C32  |

## Example

Here is a **principle example** of a Mimblewimble/Grin block header. The related block is included in Mainnet chain block: [1869](https://grinscan.net/block/1869).

| Offset        | Field           | Hex Value  |
|:-------------|:-------------|:-----|
|   0   | version               | 0001 |
|   2   | height                | 000000000000074d |
|  10   | timestamp             | 000000005c3ff107 |
|  18   | prev_hash             | 00001915c97bfad5bf9bb30a1035771446770502a937bd16a8c8a8f1fc6db730 |
|  50   | prev_root             | 2eb356e36c03f16796dd4a6eef8cbcbeabaade84eecf013516367b376d646db7  |
|  82   | output_root           | b56ccc990181d04d57585d3f0163b4f636fe3208a024596d14221bfa7739e693 |
| 114   | range_proof_root      | a341b87862f430f9dda5fd0b88be175b6cc81b5e84bf6882d98cc31750b5001a |
| 146   | kernel_root           | b3e9708378ef256d479c6b166ba0a56c26d1b2e985c5e48065dbaa8a1fa6e606 |
| 178   | total_kernel_offset   | 0755f37fa67bc3d3f0a7eddec7117013be42afff3602e7480d7271fff92763f1 |
| 210   | output_mmr_size       | 0000000000001445 |
| 218   | kernel_mmr_size       | 0000000000001130 |
| 226   | total_difficulty      | 00000108e24af3bb |
| 234   | secondary_scaling     | 00000473 |
| 238   | nonce                 | 712493895227b883 |
| 246   | edge_bits             | 1d |
| 247   | edge_nonces           | 43c8d2e098ba28f4f3748aab7d8be1aab3353259e6c6d4c046293f1c2f92afe7c5868bc5007fc51bae789ab3776d7efefb71547144b70ae8e764921bad8cb821a0c5d2adb455e1c406e1b2e39a2db51d7c552e4c1dd78bde1eea91f0843da6b3f1cb86e4ccb93371452b66c0ab292cd42525bcbf832fe358a3b22bcf7615e8397516ad8135a709213a77347cf4de104df5585984df0246fa03 |
| 400 |
