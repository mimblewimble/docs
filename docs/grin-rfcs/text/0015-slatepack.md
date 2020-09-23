- Title: Slatepack
- Authors: [joltz](mailto:joltz@protonmail.com)
- Start date: May 07 2020
- RFC PR: [mimblewimble/grin-rfcs#55](https://github.com/mimblewimble/grin-rfcs/pull/55)
- Tracking issue: [mimblewimble/grin-wallet#406](https://github.com/mimblewimble/grin-wallet/issues/406)
---

# Summary
[summary]: #summary

Slatepack is a universal transaction standard for Grin. It is designed to provide a single coherent transaction building framework to improve both the user and developer experiences in the Grin ecosystem. All wallets and services are expected to fully support the Slatepack standard by the last scheduled hard fork in January 2021 to remain compatible.

This document specifies the required components of the Slatepack standard and introduces them in the context of existing methods for transaction building in Grin. It assumes that Slatepack is the default supported transaction standard for Grin and is intended to operate under all conditions and edge cases. Slatepack is intended to be compatible with the objects and serialization methods defined in the [Slate V4/Compact Slates](https://github.com/mimblewimble/grin-rfcs/blob/master/text/0012-compact-slates.md) RFC. This RFC is meant to replace the [Slate Serialization](https://github.com/mimblewimble/grin-rfcs/pull/48), [Armored Slates](https://github.com/mimblewimble/grin-rfcs/pull/53) and [Encrypted Slates](https://github.com/mimblewimble/grin-rfcs/pull/50) RFCs.

# Motivation
[motivation]: #motivation

Without a comprehensive transaction building flow, users and services are left to make their own complicated decisions about firewalls, file handling and compatibility, risking their security, privacy and sanity.

The objective of this RFC is to converge on a simple, universal, adoptable, secure and privacy preserving workflow standard for Grin transactions: Slatepack.

# Community-level explanation
[community-level-explanation]: #community-level-explanation

Slatepack changes the existing transaction building process in Grin in a few ways:

1. _Users, developers and services are no longer required to choose between many possible transaction methods to use and support: Slatepack is a universal Grin transaction standard_
  - The transport method decision now occurs automatically for the user by following the Slatepack standard
  - There is only one synchronous method and one asynchronous method supported by default to keep things simple for developers and support workers

2. _Tor is the only synchronous transaction transport method that is currently supported in the Slatepack standard_
  - This happens "under the hood" by the wallet and the user only has to keep track of a `SlatepackAddress` for their counterparty
  - If Tor is not successful, the transaction process automatically falls back to using an encrypted copy and pastable `SlatepackMessage` string to complete the transaction asynchronously

3. _The asynchronous method by default is now a copy and pastable `SlatepackMessage` string instead of a file_
  - `SlatepackMessage` is an ascii-armor string that supports encryption of its payload with a `SlatepackAddress`
    - An encrypted `SlatepackMessage` is not meaningfully larger than a plain text `SlatepackMessage` with regard to transportability as proposed here

4. _The difference between synchronous and asynchronous transaction methods is abstracted away from the end user with the Slatepack standard_
  - `grin-wallet send -d SlatepackAddress 1.337` will first try to send the Grin synchronously via Tor to the `SlatepackAddress`
  - If that fails it will fall back to outputting an armored encrypted `SlatepackMessage` string for manual copy and paste transport
  - Example `SlatepackAddress`: `grin1p4fuklglxqsgg602hu4c4jl4aunu5tynyf4lkg96ezh3jefzpy6swshp5x`

5. _Asynchronous transactions are now encrypted by default by knowing the `SlatepackAddress` of your counterparty(s)_
  - If a counterparty is unwilling or unable to provide a `SlatepackAddress`, a plain text `SlatepackMessage` can still be exchanged

6. _Sending a mobile Grin transaction should be as easy as scanning a simple QR encoded from a bech32 `SlatepackAddress`_
  - Or as easy as pasting the `SlatepackAddress` of your counterparty into your wallet for any other device
  - Or if Tor is not accessible, or the receiving party is not online, as easy as copying and pasting a couple of `SlatepackMessage` strings with a counterparty in an alternative communication channel (email, forum, social media, instant messenger, generic web text box, carrier pigeon etc.)

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

The Slatepack standard defines the three primary components: `SlatepackAddress`, `SlatepackMessage` and `SlatepackWorkflow`.

The `SlatepackAddress` is a shareable bech32 encoded ed25519 public key that can be used both to _route synchronous transactions_ and to _encrypt asynchronous transactions_.

The `SlatepackMessage` is an easily copy and pastable ascii-armor string that contains an encrypted slate payload by default and is used in asynchronous transactions.

The `SlatepackWorkflow` specifies how both of these components interact in a universally adoptable transaction standard for Grin.

## `SlatepackAddress`

A `SlatepackAddress` is a bech32 encoded ed25519 public key and when shared with other parties is used to represent the ability to receive Grin transactions.

grin-wallet already handles ed25519 keys for the v3 onion addresses in Tor transactions. These keys can be extended to be a general `SlatepackAddress` to allow a universal key format for both transport and encryption that is error-checked, QR friendly and easily human identifiable.

  - Existing ed25519 public keys from the wallet are bech32 encoded with `grin` as the `human-readable part` to build a `SlatepackAddress`
    - `tgrin` is the HRP for a floonet `SlatepackAddress`

  - A `SlatepackAddress` can be decoded to its ed25519 public key which can then be mapped to an x25519 public key to be used for encryption

_By default, all wallets should generate a new `SlatepackAddress` for each transaction for improved user privacy and security._ Wallets can optionally support the ability for a static, reusable receiving `SlatepackAddress` with a warning about the privacy risks of reusing these addresses.

The exact proposal for the implementation of simulatenous active `SlatepackAddresses` to enforce address uniqueness by default according to this standard is left as an implementation detail to wallets to ensure that wallets can _interactively_ receive Grin across many `SlatepackAddresses` simulataneously and efficiently.

ed25519 keys are bech32 encoded as `SlatepackAddresses` rather than x25519 keys because the mapping from ed25519 to x25519 is more straightforward (x25519 public keys do not carry a `v` coordinate so they can map to two possible ed25519 public keys- this is solvable but using the ed25519 as the first order key avoids a potentially complex solution).

#### Key Generation

Keys used in `SlatepackAddresses` are derived from a path from the master seed in a given wallet account. Currently the wallet uses separate derivation paths: one for the private bytes used for the blinding factor keys and one for the private bytes used to derive the ed25519 keys used to derive Tor onion addresses. ed25519 keys used for a `SlatepackAddress` are derived from this second derivation path of the master seed. 

`SlatepackAddress` keys may be derived in parallel to the blinding factor derivation path such that a unique `SlatepackAddress` is derived each time a new blinding factor is derived for a transaction to satisfy the requirement for a unique `SlatepackAddress` to be used for each transaction by default. 

In a future update it may be desirable to encode the derivation path for the `SlatepackAddress` for a given encrypted `SlatepackMessage` somewhere so that the x25519 decryption keys can be derived without grinding down the path to find the right key to use.

#### Example `SlatepackAddress`

```
grin1p4fuklglxqsgg602hu4c4jl4aunu5tynyf4lkg96ezh3jefzpy6swshp5x
```

## `SlatepackMessage`

A `SlatepackMessage` requires multiple layers of data and encoding.

### Serialization

Grin slates are serialized as first order JSON objects. Binary serialization is done on those JSON objects. Before Slatepack, users could use both binary and JSON serialization for asynchronous transactions.

With the Slatepack standard, all asynchronous transactions serialize the slate JSON objects as binary. JSON serialization for synchronous transactions (Tor) is still used as before. The Slatepack standard serialization choices are only relevant for asynchronous transaction methods.

The details for the binary serialization of the most recent slates at the time of this writing can be found in the [Slate V4 (Compact Slates)](https://github.com/mimblewimble/grin-rfcs/pull/49) RFC. Future variations in slate binary serialization should be referenced in an RFC and may require the update of this document.


### Plain Text Metadata

Plain text metadata is included with Slatepack messages to indicate how to handle the encryption if any for the slate data in addition to tracking versions for compatibility. It can be expanded in future versions with new fields that are safe to include as plain text. These fields are neither encrypted nor authenticated. 

- `"slatepack": [Major, Minor]`
  - Where `[Major, Minor]` are positive fixnum ints representing the Slatepack version used to build the `SlatepackMessage`

- `"mode": int`
  - Where `int` is a positive fixnum int indicating the type of `SlatepackMessage`
  - 0 == plain text
  - 1 == encrypted
  - Extendable to future new modes (e.g. multiparty)
  - Indicates which additional metadata fields should be expected to follow

- `"sender": SlatepackAddress`
  - Only used here where `mode == 0`, otherwise this field is encrypted as described below
  - Where `SlatepackAddress` is a bech32 encoded ed25519 public key generated by the sender's wallet
  - For Slatepacks where the user does not wish to provide any `SlatepackAddress` a `0` value is used
  - This value is used in the `SlatepackWorkflow` to attempt to complete the transaction via Tor and to otherwise encrypt a slate for asynchronous transport


### Encrypted Metadata

Encrypted metadata is included with an encrypted `SlatepackMessage` to improve privacy for the sender of a Slatepack transaction in cases where Tor is not available. It is a basic structure containing the sender `SlatepackAddress` and potential `recipients_list` field for multiparty use to be encrypted by age. If these fields are included as plain text metadata, they would require an additional MAC field for authentication and reveal data that would be desirable to keep private.

Note that `recipients_list` does not gain the same privacy advantages of the `sender` field because the values can be derived from the plain text data included in the age header with a bit of work.

- `"sender": SlatepackAddress`
  - Used to complete the `SlatepackWorkflow`

- `"recipients_list": vec<SlatepackAddress>`
  - Only included in multiparty encrypted mode for use in future versions
  - Array of recipients such that each recipients `SlatepackAddress` in `recipients_list` matches their associated `epk` and `emk` by index in the age encryption header of the encrypted payload
  - E.g. `"recipients_list": [grin1a, grin1b]`, `"age_header_recipients": [(X25519, EPKa, EMKa), (X25519, EPKb, EMKb)]`
	- `grin1a` and `(X25519, EPKa, EMKa)` both belong to the same party as they are both at index 0
	- `grin1b` and `(X25519, EPKb, EMKb)` both belong to the same party as they are both at index 1

### Encryption

Slatepack encryption adheres to the cryptography decisions made by [age](https://age-encryption.org). It supports a conversion from the ed25519 signing key type that grin-wallet already uses for Tor to a x25519 encryption key type that age uses for encryption. This allows us to avoid having to make new cryptography decisions to support encrypted slates with keys already used in grin-wallet.

While Slatepack adheres to the cryptography decisions and payload structure choices made by age in its encrypted payloads, this data alone is not sufficient to handle all possible `SlatepackWorkflow` steps (because the age recipient header data contains x25519 keys, we want ed25519 keys for the workflow as key mapping in the other direction is not desirable). 

It should also be noted that a `SlatepackAddress` could be used to do generic age encryption by decoding the bech32 to the ed25519 public key and mapping that to its corresponding x25519 public key used in age. An `age Address` could also be used as a `SlatepackAddress` with some extra effort: bech32 decode to the x25519 public key and then [follow Signal's lead](https://signal.org/docs/specifications/xeddsa/) to attempt to solve the problem of an x25519 key mapping to two ed25519 keys to give a single ed25519 public key to be used to build a `SlatepackAddress` by bech32 encoding with `slatepack` as the HRP.

#### Payload (age Encryption)

A binary serialized slate and associated `Encrypted Metadata` fields are concatenated and encrypted according to the age encryption specification. The steps taken here follow age as closely as possible to avoid losing any security properties. A fairly well-reviewed [age library in rust](https://github.com/str4d/rage/tree/master/age) is available to use for implementation.

Any deviations in Slatepack encryption from the exact cryptography steps and decisions made in age are unintentional and should be corrected unless they are explicitly stated as a deviation from the cryptography decisions made by age.

An encrypted Slatepack payload is built with the same steps as an encrypted age payload, where the X25519 keys are derived from a participants `SlatepackAddress`.

E.g. `age_encrypt(sender + slate_binary)` where `mode == 1` and `sender` is a valid `SlatepackAddress`

### Armor

The payload that will be armored is an optionally encrypted, binary serialized `Slatepack` JSON object and any associated encrypted metadata. Armor is `Framing` wrapped around a `SimpleBase58Check` encoded `Payload`.

#### Framing

Armor uses specific `Headers`, `Footers` and `Periods` as `Framing` to contain its `Payload`.

- `Header`
  - Supported Headers:
    - `BEGINSLATEPACK`
  - Regex: `^[>\n\r\t ]*BEGINSLATEPACK[>\n\r\t ]*$`


- `Footer`
  - Supported Footers
    - `ENDSLATEPACK`
  - Regex: `^[>\n\r\t ]*ENDSLATEPACK[>\n\r\t ]*$`

- `Periods`

  - All data of an armored slate up to the first `.` is the framing header
  - All data after the first `.` and before the second `.` is the `SimpleBase58Check` encoded payload which contains the slate data
  - All data after the second `.` and before the third `.` is the framing footer
  - Any data after the third `.` is ignored


#### `SimpleBase58Check` Encoding

`SlatepackMessage` armor payloads are encoded similar to legacy bitcoin addresses, with the primary differences being that the `SimpleBase58Check` used here does not include version bytes and includes the error checking code at the beginning of the payload instead of at the end.

1. `SHA256(SHA256(SLATEPACK_MESSAGE_BINARY))`

2. First four bytes from previous step are `ERROR_CHECK_CODE`

3. Concatenate `ERROR_CHECK_CODE + SLATEPACK_MESSAGE_BINARY`

4. Base58 encode the output from the previous step to complete the armor `Payload`

It should be noted that the `ERROR_CHECK_CODE` does not have a robust error checking ability because a double sha256 hash is not a proper error check code and the encoding scheme itself was meant to be used for bitcoin addresses which are much smaller than slate payloads.

A more robust error correction option was not chosen here because the consequences of the failure to detect an error are not as severe as they would be for a bitcoin address as further validation would need to occur for Grin. The purpose is to catch some characters being accidentally added or lost during armor transport rather than preventing a spend to an address we don't know the key to spend from.

#### Formatting

- `WORD_LENGTH`: `15`
  - Number of `SimpleBase58Check` encoded characters per word; chosen for human readability across device screen sizes

- `LINE_BREAK`: `200` words
  - Number of words of `WORD_LENGTH` to include before inserting a newline; chosen for user friendliness in terminals and messaging applications

- `MAX_STRING_SIZE`: `1MB`
  - Maximum size for an armored `SlatepackMessage` string without requiring a file container
  - If a `SlatepackMessage` exceeds this value it must be handled as a `.slatepack` file instead of a string
  - This parameter chosen to cover as many cases as possible and still be supported by most clipboards

`WORD_LENGTH` and `LINE_BREAK` parameters are adjustable as a formatting convenience. `MAX_STRING_SIZE` is fixed and cannot be exceeded without wrapping the armored `SlatepackMessage` in a `.slatepack` file.

#### Edge Case: Large Slates (>1MB)

Some slate payloads may be so large that they cannot be reliably handled across all clipboards. To handle these edge cases, a `SlatepackMessage` will be expected to be passed in a `.slatepack` file format in cases where Tor is unsuccessful and the armored `SlatepackMessage` string output would exceed 1MB. A file format was chosen as opposed to a multi-part message approach because messages are already written to file by default by grin-wallet and they are potentially simpler to handle from an implementation perspective.

While wallets must support handling these edge cases to avoid all possible cases where a wallet cannot spend or receive a valid transaction, it would be reasonable for services and exchanges to support the Slatepack standard without the requirement of handling the rare file edge case. 

### Example Slatepack JSON Object

#### Mode 0: Plain Text

In this plain text example, neither the sender nor the receiver wish to share a `SlatepackAddress`

```
{
  "slatepack": [1, 0],
  "mode": 0,
  "sender": "0",
  "payload": <binary serialized slate>
}
```

#### Mode 1: Encrypted

```
{
  "slatepack": [1, 0],
  "mode": 1,
  "payload": <age encrypted binary: sender slatepack address + binary serialized slate>,
}
```

### Example `SlatepackMessage`

```
BEGINSLATEPACK. 4H1qx1wHe668tFW yC2gfL8PPd8kSgv
pcXQhyRkHbyKHZg GN75o7uWoT3dkib R2tj1fFGN2FoRLY
GWmtgsneoXf7N4D uVWuyZSamPhfF1u AHRaYWvhF7jQvKx
wNJAc7qmVm9JVcm NJLEw4k5BU7jY6S eb. ENDSLATEPACK.
```

## `SlatepackWorkflow`

Adoption of the Slatepack standard allows for a unified workflow that can still function without knowledge of a `SlatepackAddress` from a counterparty.

### With a `SlatepackAddress`

1. `grin-wallet send -d grin1p4fuklglxqsgg602hu4c4jl4aunu5tynyf4lkg96ezh3jefzpy6swshp5x 1.337`

2. Sender wallet derives an onion v3 address from `grin1p4fuklglxqsgg602hu4c4jl4aunu5tynyf4lkg96ezh3jefzpy6swshp5x` and attempts to complete the transaction synchronously via Tor

3. (Fallback) If the synchronous transaction fails, a `SlatepackMessage` string is encrypted to the `SlatepackAddress` and output for manual asynchronous transport by the user

### Without a `SlatepackAddress`

1. `grin-wallet send 1.337`

2. A `SlatepackMessage` string is output for manual asynchronous transport by the user

### With QR Codes

A QR-based `SlatepackWorkflow` will always begin with a standard QR size because they are encoded directly from a bech32 `SlatepackAddress`.

This encoding simultaneously provides a derivable onion address to attempt a synchronous transaction (`bech32 -> ed25519 -> onionv3`) _and_ a derivable encryption key (`bech32 -> ed25519 -> x25519`) to return an encrypted Slatepack string to complete the transaction asynchronously as a fallback.

As a consequence, a `SlatepackAddress` must be revealed by the party producing a QR code in the `SlatepackWorkflow`.

1. Receiver shares `SlatepackAddress` via QR

2. Sender scans QR code and the transaction is completed synchronously via Tor by deriving the recipient's onion v3 address from their `SlatepackAddress`

3. (Fallback) If the synchronous transaction fails, a `SlatepackMessage` string is output for manual asynchronous transport by the user

### With Three or More Parties

Some possible future Slatepack transactions may require more than two parties to successfully build. These cases should not require any breaking changes to the core Slatepack standard workflow.

The exact flow order (round-robin etc) will be defined by the accompanying RFCs that define the possible future multiple party slates themselves. In some cases, new slate versions may require (non-breaking) updates to this RFC. From there, the same standard Slatepack standard workflow of attempting to exchange the data via Tor first with an ascii armor fallback is still valid.

For example, a future Slatepack version will add support for an array containing a `SlatepackAddress` for each party in the order desired to finish building the transaction. The wallet of each subsequent party will attempt to establish a connection with the next via Tor. In the event of a Tor failure it would be the responsibility of the most recent party to manually transport it to the next.

In cases with many parties, the fallback method of the Slatepack standard could quickly become cumbersome if, for example, every third participant fails to achieve a Tor connection.

## Implementation Timeline

1. Initial Slatepack implementation introduced with the _July 2020 hard fork_
  - May or may not support encryption by default yet

2. The proposed Slatepack standard is fully implemented and adopted as a universal transaction standard in _last hard fork (Jan 2021)_
  - Slatepack is the default transaction standard in all wallets and services

# Drawbacks
[drawbacks]: #drawbacks

- This puts a lot of eggs in one basket (if Slatepack fails there will likely be confusion returning to old methods)

- This may be a bit rushed to have where we want it before HF schedule

- Deprecating HTTP(S) is already a major change- by requiring the adoption of this completely new standard in addition we risk putting a lot of effort on the shoulders of existing services in the Grin ecosystem

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

- By adding new options without simplifying the workflow for users we risk confusion and friction

- We could just add an option for copy and pastable slates instead of introducing an entirely new universal transaction flow standard

# Prior art
[prior-art]: #prior-art

Note that while previous asynchronous Mimblewimble transaction solutions require a relatively short TTL for a counterparty to successfully connect to their respective network before transactions fail (currently 72 hours for Tari DHT Network, 24 hours for Beam SBBS), Grin Slatepack transactions can remain valid indefinitely without spamming the network when using the ascii armor fallback.

## Tari

Tari uses the [Tari DHT Network](https://www.tari.com/lessons/02_how_tari_works.html) to support asynchronous Mimblewimble transactions. This approach is comprehensive and comprises of the entire peer to peer messaging network, including both nodes and wallets. This is distinct from Slatepack which is strictly an approach to transaction building between wallet software, not general protocol messaging.

Similar to Slatepack, Tari users derive a public key from their master seed (which is represented to users as emojis instead of bech32) and is used to look up peers in peer databases (as opposed to directly routing to a traditional Tor hidden service as in Slatepack). By default, Tari, like Slatepack, uses Tor for communication.

While Slatepack and Tari both have addresses that decode to public keys used to find and communicate with counterparty wallets via Tor, they both handle the Tor failure case differently. Tari seems to rely on its custom DHT network to gracefully handle this at the cost of the complexity of a custom DHT layer. Slatepack falls back to an unopinionated, encrypted ascii armor string for the user to transport "outside of the Grin network" to complete the transaction.

The advantage for Slatepack is significantly reduced complexity by using Tor directly with an unopinionated fallback mode. The disadvantage for Slatepack is that transactions don't "magically" just work if Tor communication is failing- they still require some effort from the user to transport the ascii armor themselves.

_Note that these details were taken from early documentation and not code- transactions in Tari may behave differently in practice._

## Beam

Beam uses the [SBBS](https://github.com/BeamMW/beam/wiki/Secure-bulletin-board-system-(SBBS)) gossip protocol to support asynchronous mimblewimble transactions. SBBS adds a nontrivial amount of complexity and attack surface to the core Beam software. In exchange, Beam receives a somewhat user-friendly mechanism for users to build transactions asynchronously. The asynchronous fallback method for Slatepack transactions is a simple ascii armor string that does not contain an opinion about a particular protocol with which to exchange the data.

The advantage with the Slatepack method is that much less code is required to support these transactions which can improve the overall stability and security of the codebase running the Grin network. The disadvantage of this for Slatepack is that asynchronous transactions don't "magically" work- they still need to be between users via an outside channel (instant message, text box, email etc). Slatepack makes the tradeoff of slightly more work for the end user in exchange for a simpler and potentially more secure network for Grin.

# Unresolved questions
[unresolved-questions]: #unresolved-questions

- How to handle key derivation harmoniously?

- What are unmentioned security considerations for using the same base key to both map to an onion address and map to an encryption key used in transactions?
  - Related, what are unmentioned security considerations to `SlatepackAddress` reuse?

- Should we still use double-sha256 in `SimpleBase58Check` or take the opportunity to use a BCH or CRC code which may be more appropriate for error detection on slatepack messages?
  - Is additional engineering desired here if there will always be further validation of the slate payload before a spend can occur?

- If addresses are not reused by default and since wallets need to be able to conduct multiple transactions in parallel, they need the ability to listen on all "active" addresses at the same time

# Future possibilities
[future-possibilities]: #future-possibilities

- Extended to support future modes (payment channel, payjoin, multiple counterparties etc)

- An entirely different standard could be adopted in the future if non-interactive transactions become the default, eliminating the need for Slatepack
  - It might be possible for a new standard to remain compatible with the existing `SlatepackAddress` to allow a more generic `GrinAddress`

# References
[references]: #references

https://en.bitcoin.it/wiki/BIP_0173

https://docs.google.com/document/d/11yHom20CrsuX8KQJXBBw04s80Unjv8zCg_A7sPAX_9Y/preview#

https://github.com/str4d/rage/blob/master/age

https://blog.mozilla.org/warner/2011/11/29/ed25519-keys/

https://libsodium.gitbook.io/doc/advanced/ed25519-curve25519

https://blog.filippo.io/using-ed25519-keys-for-encryption/

https://github.com/mimblewimble/grin-rfcs/pull/53

https://saltpack.org

https://github.com/mimblewimble/grin-rfcs/pull/50

https://gitweb.torproject.org/torspec.git/tree/rend-spec-v3.txt

https://signal.org/docs/specifications/xeddsa/

https://www.tari.com/lessons/02_how_tari_works.html

https://github.com/BeamMW/beam/wiki/Secure-bulletin-board-system-(SBBS)
