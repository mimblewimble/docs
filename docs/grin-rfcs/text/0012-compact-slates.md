
- Title: Slate V4 (Compact Slates)
- Authors: [Michael Cordner](mailto:yeastplume@protonmail.com)
- Start date: April 3, 2020
- RFC PR: [mimblewimble/grin-rfcs#49](https://github.com/mimblewimble/grin-rfcs/pull/49)
- Tracking issue: [mimblewimble/grin-wallet#317](https://github.com/mimblewimble/grin-wallet/issues/317)

---

# Summary
[summary]: #summary

This RFC describes the changes between version 3 and version 4 of the Slate transaction exchange format, which had the goal of reducing the contents of the Slate to be as minimal as possible.

# Motivation
[motivation]: #motivation

Previously, the definition of Slate versions up to V3 had been put together with no regard for its size or/and redundant/irrelevant content. In order to facilitate future exchange method possibilities, it's desirable to ensure the Slate is as compact as possible, particularly on the 'first leg' of a transaction exchange which only actually requires minimal information from the transaction initiator. 

This RFC aims to define the contents of a streamlined "compact" slate by:

* Removing all redundant or unnecessary Slate fields
* Shortening the names of many Slate fields
* Reducing the size of the Slate to at all phases of a transaction
* Defining an optional highly-minimized binary format for Slate output

Although this RFC doesn't address any particular transaction exchange methods that might be facilitated by this streamlining, one could envisage possibilities such as:

* An exchange placing the entire initial slate in a QR code
* Encoding the initial slate as an easily-cut-and-paste chunk

# Community-level explanation
[community-level-explanation]: #community-level-explanation

There are two basic transaction workflows in a two-party Grin transaction:

* In the Basic workflow, a sender adds their inputs and change outputs to a transaction, and sends them, along with the fee, the amount and their signature data to the recipient. The recipient adds a output for the amount to the transaction, adds their signature data and returns to the sender, who completes the transaction and posts.

* In the Invoice workflow, the invoice creator adds a new output to a transaction, and sends the amount and signature data to the payer. The payer adds their inputs and change outputs to the transaction along with their signature data and fee information, then returns to the invoicer, who completes the transaction and posts.

Although previous versions of the Slate included every party's complete inputs and outputs at every stage of the transaction, it is not technically necessary for the initiator to provide their inputs and outputs to the other party. It suffices for the initiator to store the input/output listing in their local transaction context, and only provide the amount, fee, excess and signature data to the other party. Recognising this, it is possible to ensure that the 'first-leg' of a transaction stage is extremely compact.

For instance, version 3 of the Slate on transaction initiation may have looked something like the following:

```
{
  "version_info": {
    "version": 3,
    "orig_version": 3,
    "block_header_version": 2
  },
  "num_participants": 2,
  "id": "0436430c-2b02-624c-2032-570501212b00",
  "tx": {
    "offset": "d202964900000000d302964900000000d402964900000000d502964900000000",
    "body": {
      "inputs": [
        {
          "features": "Coinbase",
          "commit": "087df32304c5d4ae8b2af0bc31e700019d722910ef87dd4eec3197b80b207e3045"
        },
        {
          "features": "Coinbase",
          "commit": "08e1da9e6dc4d6e808a718b2f110a991dd775d65ce5ae408a4e1f002a4961aa9e7"
        }
      ],
      "outputs": [
        {
          "features": "Plain",
          "commit": "0812276cc788e6870612296d926cba9f0e7b9810670710b5a6e6f1ba006d395774",
          "proof": "dcff6175390c602bfa92c2ffd1a9b2d84dcc9ea941f6f317bdd0f875244ef23e696fd17c71df79760ce5ce1a96aab1d15dd057358dc835e972febeb86d50ccec0dad7cfe0246d742eb753cf7b88c045d15bc7123f8cf7155647ccf663fca92a83c9a65d0ed756ea7ebffd2cac90c380a102ed9caaa355d175ed0bf58d3ac2f5e909d6c447dfc6b605e04925c2b17c33ebd1908c965a5541ea5d2ed45a0958e6402f89d7a56df1992e036d836e74017e73ccad5cb3a82b8e139e309792a31b15f3ffd72ed033253428c156c2b9799458a25c1da65b719780a22de7fe7f437ae2fccd22cf7ea357ab5aa66a5ef7d71fb0dc64aa0b5761f68278062bb39bb296c787e4cabc5e2a2933a416ce1c9a9696160386449c437e9120f7bb26e5b0e74d1f2e7d5bcd7aafb2a92b87d1548f1f911fb06af7bd6cc13cee29f7c9cb79021aed18186272af0e9d189ec107c81a8a3aeb4782b0d950e4881aa51b776bb6844b25bce97035b48a9bdb2aea3608687bcdd479d4fa998b5a839ff88558e4a29dff0ed13b55900abb5d439b70793d902ae9ad34587b18c919f6b875c91d14deeb1c373f5e76570d59a6549758f655f1128a54f162dfe8868e1587028e26ad91e528c5ae7ee9335fa58fb59022b5de29d80f0764a9917390d46db899acc6a5b416e25ecc9dccb7153646addcc81cadb5f0078febc7e05d7735aba494f39ef05697bbcc9b47b2ccc79595d75fc13c80678b5e237edce58d731f34c05b1ddcaa649acf2d865bbbc3ceda10508bcdd29d0496744644bf1c3516f6687dfeef5649c7dff90627d642739a59d91a8d1d0c4dc55d74a949e1074427664b467992c9e0f7d3af9d6ea79513e8946ddc0d356bac49878e64e6a95b0a30214214faf2ce317fa622ff3266b32a816e10a18e6d789a5da1f23e67b4f970a68a7bcd9e18825ee274b0483896a40"
        }
      ],
      "kernels": [
        {
          "features": "Plain",
          "fee": "7000000",
          "lock_height": "0",
          "excess": "000000000000000000000000000000000000000000000000000000000000000000",
          "excess_sig": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        }
      ]
    }
  },
  "amount": "60000000000",
  "fee": "7000000",
  "height": "5",
  "lock_height": "0",
  "ttl_cutoff_height": null,
  "payment_proof": null,
  "participant_data": [
    {
      "id": "0",
      "public_blind_excess": "033ac2158fa0077f087de60c19d8e431753baa5b63b6e1477f05a2a6e7190d4592",
      "public_nonce": "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f",
      "part_sig": null,
      "message": null,
      "message_sig": null
    }
  ]
}
```

In version 4 of the Slate format, the initial Slate now looks like the following:

```
{
  "ver": "4:2"
  "id": "0436430c-2b02-624c-2032-570501212b00",
  "sta": "S1",
  "off": "d202964900000000d302964900000000d402964900000000d502964900000000",
  "amt": "6000000000",
  "fee": "8000000",
  "sigs": [
    {
      "xs": "023878ce845727f3a4ec76ca3f3db4b38a2d05d636b8c3632108b857fed63c96de"
      "nonce": "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f",
    }
  ],
}
```

While a "return" slate might look something like the following:

```
{
  "ver": "4:3",
  "id": "0436430c-2b02-624c-2032-570501212b00",
  "sta": "S2",
  "off": "a4052c9200000001a6052c9200000002ed564fab50b75fc5ea32ce052fc9bebf",
  "sigs": [
    {
      "xs": "03b0d73a044f1f9ae06cf96ef91593f121864b66bf7f7e7ac481b0ce61e39847fe",
      "nonce": "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f",
      "part": "8f07ddd5e9f5179cff19486034181ed76505baaad53e5d994064127b56c5841b54735cb9ed2f59fb457144f7b1c8226d08b54cbdd0eb7e6492950751b0bb54f9"
    }
  ],
  "coms": [
    {
      "c": "091582c92b99943b57955e52b5ccf1223780c2a2e55995c00c86fca2bcb46b6b9f",
      "p": "49972a8d5b7c088e7813c3988ebe0982f8f0b12b849b1788df7da07b549408b0d6c99f80c0e2335370c104225ef5d282d79966e9044c959bedc3be03af6246fa07fc13eb3c60c90213c9f3a7a5ecf9a34c8fbaddc1a72e49e12dba9495e5aaa53bb6ac6ed63d8774707c57ab604d6bdc46de18da57a731fe336c3ccef92b4dae967417ffdae2c7d75864d46d30e287dd9cc15882e15f296b9bab0040e4432f4024be33924f112dd26c90cc800ac09a327b0ac3a661f63da9945fb1bcc82a7777d61d97cbe657675e22d035d2cf9ea03a89cfa410960ebc18a0a18b1909f4c5bef20b0fd13ffcf5a818ad8768d354b1c0f2e9b16dd7a9cf0641546f57d1945a98b8684d067dd085b90b40457e4c14665fb1b94feecf30a90f508ded16ba1bba8080a6866dffd0b1f01738fff8c62ce5e38e677835752a1b4072124dd9ff14ba8ff92126baebbb5f6e14fbb052f5d5b09aec11bfd880d7d4640a295aa83f184034d26f00cbdbabf9b89fddd7a7c9cc8c5d4b53fc39971e4495a8d984ac9607be89780fde528ee3f2d6b912908b4caf04f5c93f64431517af6b32d0b9c18255959f6903c6696ec71f615a0c877630a2d871f3f8a107fc80f306a94b6ad5790070f7d2535163bad7feae9263a9d3558ea1acecc4e61ff4e05b0162f6aba1a3b299ff1c3bb85e4109e550ad870c328bedc45fed8b504f679bc3c1a25b2b65ede44602f21fac123ba7c5f132e7c786bf9420a27bae4d2559cf7779e77f96b747b6d3ad5c13b5e8c9b49a7083001b2f98bcf242d4644537bb5a3b5b41764812a93395b7ab372c18be575e02c3763b4170234e5fddeb43420aadb71cb80f75cc681c1e7ffee3e6a8868c6076fd1da539ab9a12fef1c8cbe271b6de60100c9f82d826dc97b47b57ee9804e60112f556c1dce4f12ecc91ef34d69090b8c9d2ae9cbae38994a955cb"
    }
  ]
}
```

The 'return' slate from the recipient to the originator is expected to be larger, as it must include the recipient's outputs/inputs and proofs (as the party who posts the transaction needs all of this information). However, compacting the slate at each stage of its journey allows for future possibilities that may have been more difficult in previous iterations of the slate format. For instance, an initiator taking Grin payments might be expected to be better equipped to receive Grin transactions. They could present the payer with an invoice transaction for the amount compacted to the size of a QR code, which the payer could scan, accept, and then post back to the invoicer's listening wallet infrastructure.

Compacting the slate also acts as a minor privacy-enhancer by hiding the initiator's outputs from the other party.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

### Slate Definition - JSON

Entries prefixed with `//` denote fields that may be omitted, as well as their default assumed values. `#` denotes a comment for the purposes of illustration.

Field ordering is canonical.

```
{
# These fields are always present
  "ver": "4:3",
  "id": "0436430c-2b02-624c-2032-570501212b00",
  "sta": "S1",
  "off": "d202964900000000d302964900000000d402964900000000d502964900000000",

# These fields may or may not be present
//"num_parts: 2,
//"fee": "8000000",
//"amt": "1000000000",
//"feat": 0,
//"ttl": null,

# Sigs is always present with at least one entry
  "sigs": [
    {
      "xs": "03b0d73a044f1f9ae06cf96ef91593f121864b66bf7f7e7ac481b0ce61e39847fe",
//    "part": null,
      "nonce": "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f",
    }
  ]

# These structs may or may not be present

//"coms": null,
//"proof": null,
//"feat_args": null
}
```

A description of all fields and their meanings is as follows:

### Top-Level Slate Struct

##### Fields - Always present
* `ver` - The slate version and supported block header version, separated by a `:`
* `id` - The slate's UUID, standard hex-string encoding for UUIDs
* `sta` - 2 character String representing the current stage of the the transaction. See [Status Codes](#status-codes)
* `off` - The running transaction offset total, hex-string encoded. All parties select a random offset at the beginning of the transaction and subtract their offset from the excess value of their outputs.
They then subtract the value of the inputs from the offset when committing to inputs, updating the total offset before sending to the next stage.

##### Fields - Optional, depending on State and transaction options
* `num_parts` - The number of participants in the transaction, assumed to be 2 if omitted
* `amt` - The transaction amount as a string parseable as a u64. May be omitted on a return journey.
* `fee` - The transaction fee as a string parseable as a u64. May be omitted on a return journey, except during an invoice transaction.
* `feat` - Kernel Features ID. If omitted, kernel is assumed to be Plain (0). If set to 1 or otherwise, any arguments required for a
particular kernel feature set will be found in the `feat_args` struct.
* `ttl` - Time to Live, or block height beyond which wallets should refuse to further process the transaction. Assumed 0 (no ttl) if omitted
from the slate.

##### Structs - Always present
* `sigs` - An array of signature data containing the signature information of the last participant. See [Signature Data](#signature-data)

##### Structs - Optional, depending on state of transaction
* `proof` - An optional payment proof request. See [Payment Proof Data](#payment-proof-data)
* `coms` - The [Transaction](https://github.com/mimblewimble/grin/blob/34ff103bb02bc093fe73d36641eb193f7ef2404f/core/src/core/transaction.rs#L871); is removed from the slate in favour of including this top-level Slate field that can be used to reconstruction the transaction object as expected by the Grin node. See [Transaction Object Fields](#transaction-object-fields)
* `feat_args` - Optional arguments for Kernel features.

#### Status Codes

Valid values of the `sta` field and their meanings are:

   * `S1` - Standard (payer to payee) transaction flow, new transaction that incorporates the sender's inputs and change output(s), if any. Sender's signature nonce, excess (with kernel offset) is included and ready for sending to recipient.
   * `S2` - Standard transaction flow, recipient has created their outputs(s) and supplied their excess, nonce and partial signature, ready to return to recipient for completion.
   * `S3` - Standard transaction flow, Slate complete, contains all inputs, outputs and final signatures, and is ready for posting
   * `I1` - Invoice (payee to payer) transaction flow, new transaction that incorporates the Invoicer's output(s). Invoicer's signature nonce and excess (with kernel offset) is included and ready for sending to Invoicee.
   * `I2` - Invoice workflow, Invoicee has added their inputs and change output(s).  Invoicee's signature, nonce and excess is included and ready for sending back to the invoicer.
   * `I3` - Invoice workflow, Slate complete, contains all inputs, outputs and final signatures, and is ready for posting

#### Signature Data

An entry in the `sigs` array is as follows:

```
{
   "xs": "03b0d73a044f1f9ae06cf96ef91593f121864b66bf7f7e7ac481b0ce61e39847fe",
   "part": null,
   "nonce": "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f",
}
```

The `sigs` struct contains is comprised of an array of participant signature data, with each entry comprising:
   * `xs` - Hex string encoded short form public key on the secp256k1 curve representing the public blind excess for the participants outputs subtracted from each party's part of the offset.
   * `part` - Hex string encoded Aggregated (Schnorr) secp2561k signature represeting the participant's partial sig. May be omitted if the participant does not yet have enough data to create it
   * `nonce` - Hex string encoded The public key of the nonce chosen by the participant for their partial signature

The other party's `sig` entry is removed from the slate before sending it back to the transaction initiator during the S2 and I2 phases.

#### Payment Proof Data

If included, the proof structure is:

```
  "proof": {
    "saddr": "7e008eb593ba17d116e282d6267a3c6aad87b910933ad34dfa4d7d2c92b6ba31",
//  "rsig": null,
    "raddr": "3a425bd5da5f0f78593251ede7fad0ecf7a95679d84b2cb405255d97ce068234"
  }
```

The `proof` struct is an optional payment proof request that must be filled out by the recipient if requested (only valid for basic transaction flow). Its fields are as follows:

   * `saddr` - Hex string encoded short-form public key on the ed25519 curve, representing the sender's wallet address (see the [payment proofs rfc](https://github.com/mimblewimble/grin-rfcs/blob/master/text/0006-payment-proofs.md) for details.
   * `raddr` - Hex string encoded short-form public key on the ed25519 curve represnting the recipient's wallet address
   * `rsig` - Hex string encoded EdDSA ed25519 signature representing the recipient's payment-proof signature. Can be omitted if this has not yet been filled out

#### Transaction Object Fields

The V4 Version of the Slate contains its own separate representation of Grin's internal Transaction object. (Grin's internal transaction struct definition can be found here: [Transaction](https://github.com/mimblewimble/grin/blob/34ff103bb02bc093fe73d36641eb193f7ef2404f/core/src/core/transaction.rs#L871)). Internally, the wallet will transform its representation into the format expected by the node while posting the transaction.

The `tx` struct in a V4 Slate is removed, and is replaced instead by the following Top-Level fields. Wallets recreate the transaction object as expected by the Grin node from these fields before posting.

* `coms` is an array containing the outputs and inputs that have been added to the slate. These will appear during the I1 or S2 phases of a transaction. Each entry includes:
   * `f`: The output features, assumed to be 'Plain' if omitted. 0 denotes Plain, 1 denotes Coinbase
   * `c`: The output/input commitment, hex string Encoded
   * `p`: The output's range proof, hex string Encoded. If this is included, the entry is assumed to be an output. If not, it is an input.

When rebuilding the transaction kernel for the Node (done during the S3 or I3 phases,) the kernel is assumed to be 'Plain' unless the top-level `feat` field is non-zero. In this case, the kernel features are filled accordingly with any needed values from the `feat_args` struct.

In a typical S3 phase, these fields may look something like:

```
  "coms": [
    {
      "c": "091582c92b99943b57955e52b5ccf1223780c2a2e55995c00c86fca2bcb46b6b9f",
      "p": "49972a8d5b7c088e7813c3988ebe0982f8f0b12b849b1788df7da07b549408b0d6c99f80c0e2335370c104225ef5d282d79966e9044c959bedc3be03af6246fa07fc13eb3c60c90213c9f3a7a5ecf9a34c8fbaddc1a72e49e12dba9495e5aaa53bb6ac6ed63d8774707c57ab604d6bdc46de18da57a731fe336c3ccef92b4dae967417ffdae2c7d75864d46d30e287dd9cc15882e15f296b9bab0040e4432f4024be33924f112dd26c90cc800ac09a327b0ac3a661f63da9945fb1bcc82a7777d61d97cbe657675e22d035d2cf9ea03a89cfa410960ebc18a0a18b1909f4c5bef20b0fd13ffcf5a818ad8768d354b1c0f2e9b16dd7a9cf0641546f57d1945a98b8684d067dd085b90b40457e4c14665fb1b94feecf30a90f508ded16ba1bba8080a6866dffd0b1f01738fff8c62ce5e38e677835752a1b4072124dd9ff14ba8ff92126baebbb5f6e14fbb052f5d5b09aec11bfd880d7d4640a295aa83f184034d26f00cbdbabf9b89fddd7a7c9cc8c5d4b53fc39971e4495a8d984ac9607be89780fde528ee3f2d6b912908b4caf04f5c93f64431517af6b32d0b9c18255959f6903c6696ec71f615a0c877630a2d871f3f8a107fc80f306a94b6ad5790070f7d2535163bad7feae9263a9d3558ea1acecc4e61ff4e05b0162f6aba1a3b299ff1c3bb85e4109e550ad870c328bedc45fed8b504f679bc3c1a25b2b65ede44602f21fac123ba7c5f132e7c786bf9420a27bae4d2559cf7779e77f96b747b6d3ad5c13b5e8c9b49a7083001b2f98bcf242d4644537bb5a3b5b41764812a93395b7ab372c18be575e02c3763b4170234e5fddeb43420aadb71cb80f75cc681c1e7ffee3e6a8868c6076fd1da539ab9a12fef1c8cbe271b6de60100c9f82d826dc97b47b57ee9804e60112f556c1dce4f12ecc91ef34d69090b8c9d2ae9cbae38994a955cb"
    },
    {
      "c": "087df32304c5d4ae8b2af0bc31e700019d722910ef87dd4eec3197b80b207e3045"
    },
    {
      "c": "08e1da9e6dc4d6e808a718b2f110a991dd775d65ce5ae408a4e1f002a4961aa9e7"
    }
  ],
```

#### Feature arguments

Depending on the chosen Kernel Feature set, `feat_args` may be populated with
arguments specific to the kernel. The exact arguments that will be present here
depend on the value of `feat`. Currently, the only supported kernel is HeightLocked
(value 1) which has the arguments:

```
"feat_args": {
   "lock_hgt": "2343234" // For HeightLocked kernels (1)
}
```

### Changes from existing V3 Slate

#### Top-Level Slate Struct

* The `version_info` struct is removed, and is replaced with `ver`, which has the format "[version]:[block header version]"
* `sta` is added, with possible values S1|S2|S3|I1|I2|I3|NA
* `num_participants` is renamed to `num_parts`
* `num_parts` may be omitted from the slate. If omitted its value is assumed to be 2.
* `amount` is renamed to `amt`
* `amt` may be removed from the slate on the S2 phase of a transaction.
* `fee` may be removed from the slate on the S2 phase of a transaction. It may also be omitted when initiating an I1 transaction, and added during the I2 phase.
* `lock_height` is removed
* `feat` is added to the slate denoting the Kernel feature set. May be omitted from the slate if kernel is plain
* `ttl_cutoff_height` is renamed to `ttl`
* `ttl` may be omitted from the slate. If omitted its value is assumed to be 0 (no TTL).
*  The `participant_data` struct is renamed to `sigs`
* `tx` is removed 
*  The `coms` (commitments) array is added, from which the final transaction object can be reconstructed
*  The `payment_proof` struct is renamed to `proof`
*  The `feat_args` struct is added, which may be populated for non-Plain kernels
* `proof` may be omitted from the slate if it is None (null),
* `offset` is added, which keeps track of the running offset total as it's modified by the participants

#### Participant Data (`sigs`)

* `public_blind_excess` is renamed to `xs`
* `public_nonce` is renamed to `nonce`
* `part_sig` is renamed to `part`
* `part` may be omitted if it has not yet been filled out
* `message` is removed
* `message_sig` is removed
* `id` is removed. Parties can identify themselves via the keys stored in their transaction context

#### Payment Proof Data (`proof`)

*  The `sender_address` field is renamed to `saddr`
*  The `receiver_address` field is renamed to `raddr`
*  The `receiver_signature` field is renamed to `rsig`
* `rsig` may be omitted if it has not yet been filled out

### Pretty-Printing

The examples above are pretty-printed for reference, but all Slates should remove all whitespace before sending to other parties. The whitespace and formatting can be re-added anywhere the Slate needs to be presented for debugging.

### Slate Definition - Binary

While the JSON slate remains the first-order slate definition, and should be accepted by all wallets and APIs, wallets should also have the ability to transform slates between the JSON format and a reduced binary format suitable for armoring or direct transfer. The definition of the V4 binary slate format follows.

All integer values are Big-Endian.

| Slate V4 Field             | type           | len      | notes                                                 |
| ------------------------:  | ------         | -------- | ----------------------------------------------------- |
| `ver.slate_version`        | u16            | 2        |                                                       |
| `ver.block_header_version` | u16            | 2        |                                                       |
| `id`                       | Uuid           | 16       | binary Uuid representation                            |
| `sta`                      | u8             | 1        | See [Status Byte](#status-byte)                       |
| `offset`                   | BlindingFactor | 32       |                                                       |
| Optional field status      | u8             | 1        | See [Optional Field Status](#optional-field-status)   |
| `num_parts`                | u8             | (1)      | If present                                            |
| `amt`                      | u64            | (8)      | If present                                            |
| `fee`                      | u64            | (8)      | If present                                            |
| `feat`                     | u8             | (1)      | If present                                            |
| `ttl`                      | u64            | (8)      | If present                                            |
| `sigs` entries             | struct         | varies   | See [Sigs Entries](#sigs-entries)                     |
| Optional struct status     | u8             | 1        | See [Optional Struct Status](#optional-struct-status) |
| `coms` entries             | struct         | (varies) | If present. See [Coms Entries](#coms-entries)         |
| `proof`                    | struct         | (varies) | If present. See [Proof](#proof)                       |
| `feat_args` entries        | struct         | (varies) | If present. See [Feature Args](#feature-args)         |

#### Status Byte

Encodes slate status (`sta`) field, mapped as follows:

| State          | value |
| -------------: | ----- |
| `NA` (Unknown) | 0     |
| `S1`           | 1     |
| `S2`           | 2     |
| `S3`           | 3     |
| `I1`           | 4     |
| `I2`           | 5     |
| `I3`           | 6     |

#### Optional Field Status

A bit field that denotes the presence or absence of the optional slate fields. Each bit is
mapped to particular slate field as follows:

| Bit   | 7 | 6 | 5        | 4      | 3      | 2     | 1     | 0           |
| ----: | - | - | -------- | ------ | ------ | ----- | ----- | ----------- |
| field |   |   |          | `ttl`  | `feat` | `fee` | `amt` | `num_parts` |

If the corresponding field for a bit is 1, the field is present and must be read accordingly.

#### Sigs Entries

Sigs Entries contains a length-prefixed array of entries corresponding to the `sigs` struct.

| Field   | type   | len    | notes                       |
| ------: | ------ | ------ | --------------------------- |
| length  | u8     | 1      |                             |
| entries | struct | varies | array of entries, see below |

Each Sigs Entry is structured as follows:

| Field         | type                 | len  | notes                              |
| ------------: | -------------------- | ---- | ---------------------------------- |
| complete flag | u8                   | 1    | If non-zero, entry contains `part` |
| `xs`          | secp256k1 Public Key | 33   |                                    |
| `nonce`       | secp256k1 Public Key | 33   |                                    |
| `part`        | secp256k1 AggSig     | (64) | If present                         |

#### Optional Struct Status

A bit field that denotes the presence or absence of the optional slate structures. Each bit is
mapped to particular slate structure as follows:

| Bit    | 7 | 6 | 5 | 4 | 3 | 2 | 1       | 0     |
| -----: | - | - | - | - | - | - | ------- | ----- |
| struct |   |   |   |   |   |   | `proof` | `coms`|

If the corresponding field for a struct is 1, the struct is present and must be read accordingly.

#### Coms Entries

Coms Entries contains a length-prefixed array of entries corresponding to the `coms` struct.

| Field   | type   | len    | notes                       |
| ------: | ------ | ------ | --------------------------- |
| length  | u16    | 2      |                             |
| entries | struct | varies | array of entries, see below |

Each Coms Entry is structured as follows:

| Field       | type       | len  | notes                                                 |
| ----------: | ---------- | ---- | ----------------------------------------------------- |
| output flag | u8         | 1    | If non-zero, entry is output and contains `p` (proof) |
| `f`         | u8         | 1    | features (1 = Coinbase, 0 = Plain)                    |
| `c`         | Commitment | 33   |                                                       |
| `p`         | Rangeproof | 675  | If present                                            |

#### Proof

Optional Payment proof, with fields as follows

| Proof Field | type               | len  | notes                                |
| ----------: | ------------------ | ---- | ------------------------------------ |
| `saddr`     | ed25519 Public Key | 32   |                                      |
| `raddr`     | ed25519 Public Key | 32   |                                      |
| rsig flag   | u8                 | 1    | If non-zero, `rsig` field is present |
| `rsig`      | ed25519 EDCSA Sig  | (64) | If present                           |

#### Feature Args

Optional feature args, presence or absence of which should be determined by the
value of the `feat` field. Currently only present if `feat` is 2.

|       Field | type  | len | notes                                |
| ----------: | ----- | --  | ------------------------------------ |
| `lock_hgt`  | u64   | 8   | Lock height, present if `feat` is 2  |

# Unresolved questions
[unresolved-questions]: #unresolved-questions

- Is block header version needed?
- Nerd Kernels need to be included

# Future possibilities
[future-possibilities]: #future-possibilities

This RFC is envisaged as a necessary first step for all slate-exchange possibilities that would benefit from compactness, e.g:

* [Slatepack](https://github.com/j01tz/grin-rfcs/blob/slatepack/text/0000-slatepack.md)
* QR Code encoding of slates
* Armored slates
