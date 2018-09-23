### Block Header
General format of a **Block Header** in a MilbleWimble/Grin block:

| Field        | Description           | Size  |
|:-------------|:-------------|:-----|
| version   | Version of the block | 2 bytes  |
| - | - | - |
| height   | Height of this block since the genesis block (height 0)  | 8 bytes  |
| timestamp   | Timestamp at which the block was built | 8 bytes  |
| total_difficulty | Total accumulated difficulty since genesis block |  8 bytes |
| output_mmr_size | Total size of the output MMR after applying this block. | 8 bytes  |
| kernel_mmr_size | Total size of the kernel MMR after applying this block. | 8 bytes  |
| nonce | Nonce increment used to mine this block. | 8 bytes  |
| scaling_difficulty | Difficulty scaling factor between the different proofs of work. | 8 bytes  |
| - | - | - |
| previous   | Hash of the block previous to this in the chain | 32 bytes  |
| output_root  | Merkle root of all the commitments in the TxHashSet | 32 bytes  |
| range_proof_root | Merkle root of all range proofs in the TxHashSet | 32 bytes  |
| kernel_root | Merkle root of all transaction kernels in the TxHashSet | 32 bytes  |
| total_kernel_offset | Total accumulated sum of kernel offsets since genesis block. | 32 bytes  |
| total_kernel_sum | Total accumulated sum of kernel commitments since genesis block. | 33 bytes  |
| - | - | - |
| pow  | Proof of work data | in case cuckoo 30: 154 bytes.<br>cuckoo_size: 1byte<br>cuckoo_solution: 42*29bits=153bytes |
|   |   | Total: 405 bytes  |

## Example
Here is a **principle example** of a MimbleWimle/Grin block header. The related block is included in Testnet3: [101888](https://grinscan.net/block/101888).

<pre><p>
{
  "header": {
    "hash": "05d13a2c577d61aa14dbfec7c45d9e29f6d11061cad1d661f5c87ca01c54e3ff",
    "version": 2,
    "height": 101888,
    "previous": "00b71c2d61396cc8c8d4ceab5873fe02fce6ae04551215587965ba886da1237e",
    "timestamp": "2018-09-19T08:01:05+00:00",
    "output_root": "8ff517ead8629c976efa1e563837a8bf22350ff34814e6a6fb1b4fca566c8328",
    "range_proof_root": "dc7b23682174cae34b02133a3dd75aa7e59569f1ebb70ee83cf062ffa47cc25f",
    "kernel_root": "10e35fe2c53b6f02f897d96590018c94ae1d725f6f2379ea2f98f48e815075c9",
    "nonce": 5433731719227262135,
    "cuckoo_size": 30,
    "cuckoo_solution": [
      3529900,
      20756386,
      26687989,
      39915563,
      58664656,
      61742168,
      63254288,
      71098734,
      83570003,
      92674712,
      99388329,
      150235082,
      159108923,
      186105999,
      188490539,
      191860971,
      197357411,
      223582317,
      226904112,
      240419493,
      243932605,
      305146957,
      322564448,
      358066753,
      363881523,
      365986157,
      368466480,
      386129065,
      403519432,
      415295811,
      430013252,
      452008276,
      456646007,
      469313754,
      470927182,
      472356191,
      476693937,
      489734253,
      501080796,
      501333167,
      502672154,
      533114222
    ],
    "total_difficulty": 45101558,
    "total_kernel_offset": "2c76d088abae094dcdd858a492d2ee57e107727db63889f342eeb4ea7ad1aef2"
  },
}
</p></pre>

## Description

TODO