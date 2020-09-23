
- Title: online-transacting-via-tor
- Authors: [David Burkett](mailto:davidburkett38@gmail.com)
- Start date: September 1, 2019
- RFC PR: [mimblewimble/grin-rfcs#24](https://github.com/mimblewimble/grin-rfcs/pull/24) 
- Tracking issue: [mimblewimble/grin-wallet#280](https://github.com/mimblewimble/grin-wallet/issues/280)

---

# Summary
Describes a standardized addressing and communication protocol for building Grin transactions.<br/><br/>
Wallets will attempt to connect to the recipient directly to build transactions over a TOR hidden service similar to how http(s) transaction building works today.<br/><br/>
This RFC does not cover the offline transacting problem.

# Motivation
Grin is unique in that it requires the sender and receiver to interact in order to transact. This presents a lot of unique challenges that most coins don’t have to deal with. There are a number of different incompatible standards for sending and receiving, resulting in confusion and headaches for many users. The hope is that the addressing mechanism described here will become the new default method for sending and receiving, deprecating several less secure and less private methods in the process.

# Description
## Community-level explanation
From an end-user perspective, there should no longer be a need to configure routers and firewalls to receive grins. Sending and receiving should feel like any other cryptocurrency, where a simple encoded address is all you need to share before receiving. No firewall or router configuration should be necessary.

## Reference-level explanation
### Addressing
Onion addresses for TOR hidden services are generated from an ed25519 public key (32 bytes), and include a checksum and a version[1]. This provides an equivalent level of security as bitcoin addresses, and can be ephemeral or permanent, depending on the user’s needs. Grin addresses should be generated and base32 encoded in the same way as TOR v3 addresses.<br/><br/>
Although ed25519 is a different curve than used by the grin protocol, we can still use our HD wallets to generate deterministic ed25519 public keys (and therefore Grin addresses). For account `m/0`, addresses will be generated using keychain paths `m/0/1/x`, for account `m/1`, addresses will be generated using `m/1/1/x`, etc. To generate addresses for a keychain path, we derive the private key in the usual way, but then blake2b hash the derived key to get the ed25519 secret key, which can then be used to calculate the public key and address.

### TOR Hidden Services
TOR hidden services can be used to directly serve the existing foreign APIs. When configuring TOR (whether bundled with grin, or installed separately), you would just publish a hidden service and configure TOR to forward all traffic to port 3420. This means we can continue supporting http(s) sending/receiving with no disruption, though it’s advisable to avoid sending directly over http(s) asap.In future versions of Grin, we can stop allowing non-local connections to the foreign wallet APIs.

# Drawbacks
Requires users to setup TOR, or bundle it with Grin, which could be non-trivial, and could conflict with locally installed/running versions.

# Unresolved questions
* How often should addresses change? Should users manually request a new address, or should they auto expire? Should we support multiple?

# Future possibilities
The changes in this RFC lead the way for:
* Payment proofs
* Offline transacting via SBBS/Grinbox-style relay system. See 0000-asynchronous-transacting-via-relays RFC

# References
[1] https://github.com/torproject/torspec/blob/87698dc1c0fa4cf2186f180a636fc7ad1c5fb5fd/rend-spec-v3.txt#L2059-L2081 <br/>
[2] https://github.com/mimblewimble/grin/blob/d918c5fe84e859290c9d09f5cfc167ed41d27bff/keychain/src/extkey_bip32.rs#L122
