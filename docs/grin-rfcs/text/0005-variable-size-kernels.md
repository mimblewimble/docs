
- Title: `variable-size-kernels`
- Authors: [Antioch Peverell](mailto:apeverell@protonmail.com)
- Start date: Aug 13, 2019
- RFC PR: [mimblewimble/grin-rfcs#21](https://github.com/mimblewimble/grin-rfcs/pull/21)
- Tracking issue: [mimblewimble/grin#3038](https://github.com/mimblewimble/grin/issues/3038)

---

# Summary
[summary]: #summary

We minimize the size of binary serialized transaction kernels by including only the data applicable for each kernel variant. Height locked kernels include a fee and a lock height. Plain kernels include only a fee. Coinbase kernels include neither a fee nor a lock height. Each kernel feature variant will serialize to a fixed size in bytes but this size will differ across the kernel variants.

# Motivation
[motivation]: #motivation

We were originally including both fee and lock_height on _every_ kernel in the binary serialization format. We were storing a fee of 0 on coinbase kernels and a lock_height of 0 on both plain and coinbase kernels. Kernels are never pruned and must be maintained forever so this overhead is relatively expensive. By only serializing data strictly necessary for each kernel variant we minimize storage and transmission costs. This also provides the flexibility necessary to introduce new kernel variants in the future, for example the proposed [relative kernels][0].

# Community-level explanation
[community-level-explanation]: #community-level-explanation

Each transaction kernel variant may have associated data. For example, height locked kernels include an associated lock height and non-coinbase kernels have an associated fee. Each kernel variant serializes to a fixed size in bytes but this size may be different for each kernel variants. This allows kernels to be serialized efficiently and provides flexibility to introduce new kernel variants that have additional associated data in the future.

A plain kernel is 106 bytes compared to 114 bytes for a height locked kernel. Omitting the lock height from plain kernels saves approximately 7% in kernel storage costs.

These changes affect serialization/deserialization of transaction kernels. Kernels are included in p2p messages for transactions and full blocks. Older nodes will serialize transaction kernels differently so nodes on the network need to be able to handle old and new serialization formats. The kernel MMR is also included in the txhashset state file during fast sync so nodes need to be able to support old and new formats of the state file.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

### Protocol Version 1 (Previous Version)

In protocol version 1 all transaction kernels are serialized using the same structure, regardless of kernel variant. All kernels include 8 bytes for the fee and 8 bytes for the lock_height, even if unused.

```
features (1 byte) | fee (8 bytes) | lock_height (8 bytes) | excess (33 bytes) | signature (64 bytes)

00 | 00 00 00 00 01 f7 8a 40 | 00 00 00 00 00 00 00 00 | 08 b1 ... 22 d8 | 33 11 ... b9 69
```

All kernels contain a feature byte to determine the variant. Kernels always include an excess commitment and signature, 33 bytes and 64 bytes respectively. The proposal is to have variant specific data follow the feature byte.

The initial feature byte would determine the number of subsequent bytes to read for variant specific data.

```
00 (plain): following 8 bytes for the fee.
01 (coinbase): no additional bytes.
02 (height locked): following 8 bytes for the fee and additional 8 bytes for the lock height.
```

This would always be followed by a fixed 33 bytes for the excess commitment and 64 bytes for the kernel signature.

### Protocol Version 2 (Current Version)

Plain kernel, includes fee.

```
features (1 byte) | fee (8 bytes) | excess (33 bytes) | signature (64 bytes)

00 | 00 00 00 00 01 f7 8a 40 | 08 b1 ... 22 d8 | 33 11 ... b9 69
```

Coinbase kernel, no fee, no lock height.

```
features (1 byte) | excess (33 bytes) | signature (64 bytes)

01 | 08 b2 ... 15 36 | 08 14 ... 98 96
```

Height locked kernel, include fee and lock height.

```
features (1 byte) | fee (8 bytes) | lock_height (8 bytes) | excess (33 bytes) | signature (64 bytes)

02 | 00 00 00 00 00 6a cf c0 | 00 00 00 00 00 00 04 14 | 09 4d ... bb 9a | 09 c7 ... bd 54
```

### Backward Compatibility (Protocol Version Support)

#### Network p2p messages

The following p2p messages include serialized transaction kernels -

* transaction
* full block
* compact block (incl. coinbase kernel)

Each node has a "local" protocol version. Nodes exchange protocol versions during the initial handshake when setting up a connection.

If both nodes are running protocol version 2 then no translation is required and transaction kernels can be serialized using protocol version 2.

If both nodes are running protocol version 1 then again no translation is required.

The complexity arises when one node is running protocol version 2 and the other node is running protocol version 1.

* Node A: protocol version 2
* Node B: protocol version 1

If node A and node B are communicating they must both send and receive using a protocol version compatible with both nodes. In this case protocol version 1.

__Receiving messages using previous protocol version__

Node B will broadcast transactions and blocks using protocol version 1. Node A will need to use the previous protocol version and not the local version when deserializing these messages.

__Sending messages using previous protocol version__

Node A will need to ensure anything broadcast to Node B is compatible with protocol version 1. In both cases node A is responsible for translating to and from the previous protocol version.

#### Local db storage

Each node has a "db" protocol version. All entries in the db serialize/deserialize using that protocol version. Nodes support a process for local migration of data. On startup, the db is inspected and if necessary a migration is performed upgrading all entries in the db to the latest protocol version. This process can be disabled locally to allow nodes to run against old databases without upgrading the protocol version. This is useful in cases where nodes do not wish to immediately upgrade the db, allowing for previous versions of code to run without problems.

#### Kernel MMR storage

Each node maintains a kernel MMR as part of the txhashset data structure. Each node has an MMR protocol version. The node will serialize/deserialize kernel entries in the kernel MMR data file according to the MMR protocol version.

##### Fast sync (txhashset.zip state file)

Internally nodes are free to use any protocol version but the kernel MMR is also provided to other nodes during initial fast sync. A node joining the network requests a txhashset state file and this includes the kernel MMR. It is important that nodes send and receive the txhashset file using a compatible protocol version. This is a special case of "p2p messages" above with the txhashset state file provided as an attachment to the txhashset message.

If node A (protocol version 2) requests a txhashset from node B (protocol version 1) then it must read the file using protocol version 1. Similarly, if node B requests txhashset from node A then node A must provide the file such that it is compatible with protocol version 1.

The simplest way to achieve this is for all nodes to continue to use protocol version 1 internally for MMR storage, even if they use protocol version 2 externally for p2p messages. A transition period will be in place until a majority of nodes support protocol version 2 at which time nodes can migrate their MMR storage to protocol version 2.

### Wallet Compatibility

Interactive transaction building involves a transaction "slate" passed between parties. This includes a json serialized representation of the transaction.

To minimize compatibility issues between wallets we have maintained this existing json format. Transaction kernels are represented in a single consistent json format, with fee and lock_height both included, regardless of kernel variant. Plain kernels have an associated lock_height of 0 and coinbase kernels include a 0 fee. This is consistent with the current "v2" slate.

```
"kernels": [
  {
	"features": "Plain",
	"fee": "7000000",
	"lock_height": "0",
	"excess": "08b1...22d8",
	"excess_sig": "3311...b969"
  },
  ...
]
```

# Future possibilities
[future-possibilities]: #future-possibilities

Support for variable size kernels allows new kernel variants to be introduced in the future. One proposed kernel variant is [No Recent Duplicate (NRD) kernels][0]. Kernels with relative lock heights will have an associated reference to a prior kernel in addition to a lock height based on that prior kernel.

# References
[references]: #references

* [RFC 0000-nrd-kernels][0] [fix link once RFC merged]
* [PR #2734 Support for variable size MMRs][1]
* [PR #2824 Protocol version support][2]
* [PR #2859 Kernel feature variants][3]

[0]: https://github.com/mimblewimble/grin-rfcs/blob/master/text/0000-relative-kernels.md
[1]: https://github.com/mimblewimble/grin/pull/2734
[2]: https://github.com/mimblewimble/grin/pull/2824
[3]: https://github.com/mimblewimble/grin/pull/2859
