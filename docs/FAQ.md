
# FAQ

## Q: What is grin?  
A: An implementation of [MimbleWimble](https://download.wpsoftware.net/bitcoin/wizardry/mimblewimble.txt)
## Q: Similar to Bitcoin?  
A: Both are outputs-based, PoW. See also [Grin for Bitcoiners](https://github.com/mimblewimble/grin/blob/master/doc/grin4bitcoiners.md)
## Q: Mining? 
A: So far only on Testnet. Support has been built for modern CPUs and Nvidia GPUs.
## Q: Block height? 
A: HTTP GET /v1/chain on a public peer node, for example http://testnet1.yeastplume.com:13413/v1/chain or see the [grin explorers and scanners](Community-projects.md#explorers-and-status-pages)
## Q: Store of value? 
A: Not yet. Wait for Mainnet. Testnet coins might disappear, *unexpectedly*.
## Q: Block size limit? Target mean block time?  
A: Target mean block time is 1 block per 60 seconds. The size is limited by transaction "weight", though there is also a hard cap on the order of tens of MB.
## Q: Does grin scale?  
A: Yes, it might eventually do, thanks to transaction cut-through and possible layer 2 solutions.
## Q: Fees? Monetary policy? 
A: https://github.com/mimblewimble/grin/wiki/fees-mining and the newer https://github.com/mimblewimble/docs/wiki/Monetary-Policy
## Q: Roadmap? 
A: Moving fast, changing things. Maybe look at [issues and milestones](https://github.com/mimblewimble/grin/milestones)
## Q: Proof of payment? 
A: Maybe.
## Q: Microtransactions? 
A: On Testnet2, fees are 0.8% on a transaction of 1.0 coins.
## Q: Could grin ever support or make use of:
  A: (☑ Probably, or ☐ Probably not)
  
  ☑️ Contracts

  ☑️ [Pruning](pruning.md)

  ☐ Identity, like bitauth

  ☑️ Something something SNARK/STARK/NIZKPs

  ☑️ Cross chain atomic swaps

  ☑️ multisig

  ☑️ time locks

  ☑️ lightning network

  ☑️ Payment channels

  ☑️ hidden nodes / onion routing

  ☑️ [Scripting - clean & native w/ tiny limits](https://lists.launchpad.net/mimblewimble/msg00029.html)

  ☑️ Dandelion privacy mixed with tx cut through

## Q: HW requirements for mining? 
A: A modern CPU *might* be viable for a while. A GPU with >3.7 GB of very fast DRAM is the best bet, like the 1080TI. But don't invest Grin-specific equipment yet! There's not even a final beta released, and much can still change.
## Q: Quantum safe? 
A: Nah. QC is one of the few things that scales worse than blockchains though, so don't hold your breath. And given sufficient warning (i.e. by not being among the first to be hit), adequate QC resistance can be introduced through softforks.

# Short term plans
**Transaction types**
- (DONE) A temporary simple transaction exchange. Temporary - will be deprecated.
- (WIP) Full transaction, created as an interactive exchange which involves "two and a half" roundtrips between sender and receiver.