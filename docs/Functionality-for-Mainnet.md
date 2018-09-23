# Introduction
This document covers use cases and functionality that are intended to be supported for the initial Mainnet release. This document was prompted by the [relevant discussion in the dev meeting on Aug 21 2018](https://gitter.im/grin_community/dev?at=5b7c3595d8d36815e56d5199). Items are high level and not necessarily exhaustive. 

* **Emphasis and priority:** Security over Quality over Functionality over User Experience.
* **Target audience for Mainnet:** Tech-savvy users, early adopters, experienced miners. 

## Notation

* [ ] Intended to be supported
* [X] Supported already (to some extent)
* ~Explicitly not supported for Mainnet launch (but possibly afterwards)~

# List of functionality for Mainnet

## General
* [ ] Downloadable Linux binary
* [ ] Downloadable macOS binary
* [ ] Improvement to current ip:port user id paradigm (DHT?)
* ~Downloadable Windows binary~
* ~Android client~
* ~iOS client~
* ~Web/thin client~

## Node
- [X] TUI
- [ ] _GUI (maybe?)_
- [X] Fast sync
- [X] Full sync

## Wallet
- [X] CLI
- [X] GUI
- [X] Send (1:1 tx)
- [X] Receive (1:1 tx)
- [ ] Backup
- [ ] Restore
- [X] Tx info
- [X] Cancel tx
- [X] File-based (asynch) transactions
- [ ] _Relative timelocks (maybe?)_
- ~n:m transactions~
- ~multi-sig~
- ~Lightning-style network~

## Grin-miner
* [X] TUI
* [X] Cuckoo CUDA miner
* [X] Cuckoo CPU miner
* [X] Cuckoo30 support
* [ ] [Dual PoW](https://www.grin-forum.org/t/proof-of-work-update/713) support
* [ ] Equigrin miner
* ~GUI~
* ~OpenCL miner~
* ~Downloadable binaries~

