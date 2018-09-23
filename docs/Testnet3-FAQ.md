## General

### Are coins pre-mined? 
No coins are pre-mined.

### How much are Testnet3 grins going to be worth?
The T3 grins are for testing purposes only, and have no value.

### Is there a block explorer?  
All three block explorers are updated to work with Testnet3: https://grinscan.net/, https://grinexplorer.net and http://explorer.lesceller.com.

### When will Mainnet be launched?
When it’s ready.

## Set up

### Are there binaries?
Not yet. Eventually, the aim is to provide these for Testnet3.

### I'm having these compile errors...
Ensure you meet the requirements and have installed all the dependencies in the [build documentation](https://github.com/mimblewimble/grin/blob/master/doc/build.md). If you still experience issues, ask in the gitter and we can troubleshoot.

### I'm getting these weird node sync errors...
Ensure you made a clean install for Testnet3 and did not move over config or chain history from your Testnet2 node. If you still experience issues, visit gitter and we might be able to diagnose the issue.

### How can I do some debugging?
A good place to start is to check the `grin.log` for error messages. Running your node and grin-miner with RUST_BACKTRACE enabled might also help with error messages, i.e.:
```
grin$ RUST_BACKTRACE=1 ./target/release/grin
grin-miner$ RUST_BACKTRACE=1 ./target/release/grin-miner
```

## Contributing

### I want to contribute. Where do I begin?
That's great!
* The [wiki documentation](https://github.com/mimblewimble/docs/wiki) can always use improvement. Anyone is free to just jump in and edit that directly.
* We also have more [technical documentation](https://github.com/mimblewimble/grin/tree/master/doc) that is not on the wiki. Here you can’t edit directly, but submit a pull request that is then peer reviewed before merged. A good place to start is to review the technical documentation [table of contents](https://github.com/mimblewimble/grin/blob/master/doc/toc.md) and improve where you can.
* If you want to get your hands dirty, you’re also free to just submit a PR to any area of the project, the list of [open issues](https://github.com/mimblewimble/grin/issues) is probably a good place to start. Also check that there are not any [open pull requests](https://github.com/mimblewimble/grin/pulls) that conflict to avoid duplication of effort. 

### How can I understand what's currently being worked on?
* Look at the [open pull requests](https://github.com/mimblewimble/grin/pulls).
* There is a bi-weekly dev meeting every other Tuesday at 21:00 UTC (on odd-numbered weeks) on the `/dev` channel on Gitter. Feel free to listen in.
* @yeastplume is publishing a [weekly progress update](https://www.grin-forum.org/t/yeastplume-progress-update-thread-may-sept-2018/361/13) of his work in the forum, usually on Fridays.


## Wallet

### What do I need to do in order to be able to receive grins?
1. Set `api_listen_interface = "0.0.0.0"` in your `grin.toml` configuration file.  
1. Ensure port 13415 is open on the device that is to receive grins.

### How can I check if the port is open?
Visit http://canyouseeme.org from your device and follow instructions. 

###  My port is closed, what do I do? 
Check that any firewalls set up on your device are letting through connections and that you have set up port forwarding on your router. Google "port forward" and the model and make of your router for further instructions. Some have also had success setting up mapping using the [portmapper](https://github.com/kaklakariada/portmapper) tool behind a router they don't know the admin password to.

### My port is open, I've edited my grin.toml file. How can I get some grins? Is there a faucet?
If you `curl gringod.info`, it will send some grins to the originating IP:13415. Alternatively you can either mine some grins yourself or join the gitter chat and ask someone to send you some to your IP:13415.

### What is “Immature Coinbase”?  
After you’ve successfully mined your block, another 1000 blocks need to be found in order for your coinbase to mature. Prior to this occurring, the outputs cannot be spent.

### I have only mined, but my wallet balance is 2880.016. Where did the 0.016 grins come from?
These are transaction fees. You get paid for including a transaction into a block that you have successfully mined. If you if you run `grin wallet outputs` you will see for which block that was, and can also check it on one of the block explorers.

### Is there a wallet with a GUI?
There's a WIP [web wallet interface](https://github.com/mimblewimble/grin-web-wallet). A running node is required.

## Mining / Cuckoo Cycle Proof of Work

### I’m running a grin node, it seems like I’m synced, but I’m not mining anything, why is that?
You need to clone, build, and run [grin-miner](https://github.com/mimblewimble/grin-miner) separately from your [grin](https://github.com/mimblewimble/grin) node in order to mine.

### Can I just run grin-miner?
You need to run both the grin node and grin-miner. Alternatively you can point your miner to someone else’s node (if they’ve made the stratum server publicly available), but this also means that they will receive the block rewards.

### My miner is stuck. I'm getting "missing field job_id" or "Starting miner awaiting first graph time…" message.
This is a known issue that has been fixed. Please rebuild both grin node and grin-miner from master and try again.

### Is there a miner that works for Windows?
At the moment, [GrinGoldMiner](https://github.com/mozkomor/GrinGoldMiner) is your best bet.

### Can I mine with multiple GPUs?
Yes, configure your `grin-miner.toml` with multiple devices.

### Can Grin be mined with a pool?
Yes. [Grin-pool](https://github.com/grin-pool/grin-pool) is currently in alpha, instructions for trying it [here](https://github.com/grin-pool/grin-pool#how-to-try-it).

### What's the minimum memory requirement to mine with a GPU?
GrinGoldMiner has been confirmed to work with 8GB currently. The aim is to bring the minimum requirement down to 4GB prior to Mainnet launch.

### What's best to mine Cuckoo Cycle with, CPU or GPU?
GPU will beat CPU in general.

### What's a valid Cuckoo Cycle PoW solution?
A single 42-cycle in a graph of at least 2^30 nodes, i.e. a cycle of length 42.

### What’s the difference between a finding a share and finding a block?
The network can operate at a fairly high difficulty in order for blocks to be found on average every minute. To allow miners to contribute intermediate work, mining pools accept solutions that hashes at much lower difficulty. This is called a share. On average, a certain number of shares will result in finding a block. So if the network difficulty is `D` and the mining pool difficulty is `d` with `D > d`, on average `D/d` shares will be required for the pool to find a block.

### The size of the graph?
Yes, measured as the number of nodes of the graph you find that single 42-cycle in. The lowest number of nodes that is allowed is 2^30, which we call cuckoo30. Graphs with more nodes in them require more memory and effort to solve, which is why we scale the difficulty with the size. For cuckooN the scaling factor is given by (N-1)*2^(N-30). This means cuckoo30 solutions are scaled by 29, cuckoo31 by 60, cuckoo32 by 124 etc.

### What’s the minimum graph size in order for my share to be accepted as a valid block?
The minimum size is currently 2^30, or cuckoo30. Solutions in graphs with larger nodes than the minimum threshold are also accepted. In the future this threshold might be increased via soft forks.

### grin-miner tells me “Solution Accepted”, it’s listed as accepted in the grin node, but why have I still not received any block rewards?
The miner sends any valid cuckoo solution to the grin node. A share will be accepted even if it is of higher difficulty than the network difficulty. A share is not a block.

### I don’t get it, why does grin-miner submit shares to the grin node that are below what's accepted?
Mining pools will use the amount of shares to estimate your graph rate and thus your payout. 

### What does GPS in mining mean, i.e. 1 GPS? 
 That’s 1 Graph Per Second, i.e. trying one random graph in one second to see if it’s a valid solution.

### How is total network GPS derived from network difficulty?

On average you need to search 42 graphs to find a 42-cycle.

Also on average you need to find diff/scale 42-cycles to solve a block, where
```
diff = current network difficulty, and
scale = (N-1) * 2^(N-30) for cuckooN cycles.
(e.g. 29 for cuckoo30, 60 for Cuckoo31,  and 124 for Cuckoo32)
```
Finally, graphs per second is graphs per block divided by the blocktime in seconds.

Total Network GPS is then
```
gps = 42 * (diff/scale) / 60
```
As an example, let's assume:
* Everyone is mining cuckoo30;
* Current network difficulty is 241;

Then, the network GPS is 42 * 241/29 / 60 ~5.82.

### If total network GPS is 5.82 in the above example, and I am currently mining at 0.582 GPS on my own, does that mean I can expect to win 10% of all blocks roughly?

Yes. You're then essentially contributing 10% of all the network mining power.