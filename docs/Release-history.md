# Beginnings

The Mimblewimble protocol or idea was dropped in an IRC chat as a text document served from an anonymous server.

# Grin releases

## Devnet (2017)
[Completed](https://github.com/mimblewimble/grin/milestone/1?closed=1)

## Testnet1 (2017)
[Completed](https://github.com/mimblewimble/grin/milestone/2?closed=1)

## Testnet2 (2018)
[Development completed](https://github.com/mimblewimble/grin/milestone/3?closed=1)
Testnet2 is the [current release](https://github.com/mimblewimble/grin/releases).
Big and/or user-visible changes in Testnet3 are:
 - Bulletproofs
 - Block explorers
 - Compact blocks
 - Cumulative difficulty from required difficulty rather than block PoW difficulty, to avoid deep reorgs
 - Dandelion protocol, improving transaction privacy
 - Difficulty adjustment, to ensure Testnet2 launches with a high difficulty to avoid creating a multiple empty blocks instantly at launch
 - Fast/abridged sync with zipped txhashsets
 - Header-first sync
 - Merkle proofs
 - Peer banning
 - Rate limiting improved, hardening against DoS attacks
 - Schnorr aggregated signatures
 - Text-based user interface

Testnet2 testing will soon be closed.

## Testnet3 (2018)
Big and/or user-visible changes in Testnet3 are:
 - mining pools
 - Use PoW hash as block ID
 - UTXO bitmaps, an optimization that saves both space and time
 - wallet: API and browser based wallet
 - (and what more?)
[Waiting to be implemented](https://github.com/mimblewimble/grin/milestone/5):
 - PoW: allow various Cuckoo sizes
 - sync: show progress more clearly
 - Wallet: improved robustness and cleanliness
 - optimizations

## Future directions

See https://www.grin-forum.org/t/much-of-the-technology-behind-grin/127 for a baseline from around Testnet 1.

Grin already has time-locked transactions (even with switch commitments and that stuff ripped out?) so maybe no need to look more at Nargle's private locktimed transactions construction? https://lists.launchpad.net/mimblewimble/msg00426.html

Maybe use Reverse transactions creation.

Light / hot wallet that makes use of http://grinbox.io/ and grin explorers to work on/offline and be maximally aware of current best known chain even right after coming back from being hibernated and offline.

_Will grin get/make use of..._

Instead of using any of these:

 - DLC (Discreet Log Contracts)?
 - MAST (Merkleized Abstract Syntax Trees)?
 - graftroot / taproot?

...we'll use Scripless Scripts on top of Schnorr aggregated signatures which is faster and more or less only real option for a MimbleWimble protocol/chain.

 - Certifiable / provable transactions?
   - Gameplan by @tromp here: https://lists.launchpad.net/mimblewimble/msg00091.html

 - Vaults?
   - Hopefully yes. This would make grin wallets less attractive to steal, since if the theft is detected, the stolen coins can be "destroyed".

 - Switch contracts that are not consuming any space and are not cryptographically vulnerable?
   - Initially no, unless it becomes necessary. Something like [Tim Ruffing's suggestion](https://lists.launchpad.net/mimblewimble/msg00479.html) would be possible to add later. Making it easier for people to add and read back out data in the chain would also mean that people "can store" things in the chain, forever, and nobody can censor anything out. Legally that might be problemtic, with GDPR (the EU privacy law) etc.
