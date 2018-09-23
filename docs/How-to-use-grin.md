Running grin can be as simple as
```
target/release/grin
```

or to run the debug-enabled version

```
cargo run
```

But to easily run grin with any of its commands and switches, we recommend you set up your PATH to include the target/release folder where your grin binary is placed when you [build grin](https://github.com/mimblewimble/docs/wiki/Building) with `cargo build --release`.


## Configuration

Configure grin using `grin-server.toml` and/or `grin-wallet.toml` on the command line.

At startup, grin looks for a configuration file called `grin-server.toml` and/or `grin-wallet.toml` in the following places in the following order, using the first one it finds:

1. The current working directory
2. {USER_HOME}/.grin

Command line switches can be used to override settings in these configuration files.

If no configuration file is found, a default configuration file will be auto-generated when running `grin` at the first time.

At present, the relevant modes of operation are 'server' and 'wallet'. When running in server or wallet mode, any command line switches provided will override the values found in the configuration file.

## Participate on Testnet3

Start by exploring the command line with:

```
grin help
grin wallet help
```

As a user, you can try to:

- receive and send transactions (ask on Gitter to get some grins)
- view your wallets "outputs"
- sync the chain
  - fast sync
  - archive sync
- mine, using any of these PoW implementations:
  - cpu_mean_compat mining plugin (typical performance: 0.1 graphs/s) - requires about 2.2GB RAM for the solver, aim for 4GB system memory.
  - cpu_mean mining plugin (typical performance: 0.2 graphs/s) - requires AVX2 instruction set (Intel Haswell or newer, AMD Excavator or newer) and about 3.5GB of RAM for the solver, aim for 5GB system memory.
  - GPU miner, 10x to 20x faster than the fastest CPU miner, depending on GPU hardware. Best on a graphics card with 8GB or more of VRAM. CUDA, NVidia, only at this point.

Ask about errors you see, and try re-telling the answers in your own words.
That brings attention to them, so we can make them more understandable for
users, and improve the page about
[troubleshooting](https://github.com/mimblewimble/docs/wiki/Troubleshooting).

### Sending and Receiving Grins Online

By default, the Grin wallet will only listen locally, to receive grins from another user, you will need the edit `grin-wallet.toml` and change the wallet listening address as below:

```
[wallet]
# Host IP for wallet listener, change to "0.0.0.0" to receive grins
api_listen_interface = "0.0.0.0"
```

Also verify that port 13415 is open. You may need to set up port forwarding on your network router. Finally, when transacting, both the sender and recipient should be running the latest version of the wallet code to ensure compatibility.

### Sending and Receiving Grins Offline

This requires 3 operations and 2 message exchanges:

1. The sender initiates the transfer, generating a partial transaction file that can be sent in any suitable way: email, dropbox share, a chat app, etc.
2. The receiver gets the sender's message, and adds their information to it to help complete the transaction. This generates another file that the receiver sends back to the sender.
3. The sender finalizes the transaction using the file sent back by the receiver. This also sends the transaction to a Grin node automatically to broadcast it.

For each of those steps, we have a simple command:

```
# 1. Generates <file> to send 10 grins
grin wallet send -d <file> 10
# Send <file> to the receiver

# 2. Receiver adds their information, generates <file>.response to provide to the sender
grin wallet receive -i <file>

# 3. Sender finalizes the transaction, which gets broadcasted
grin wallet finalize -i <file>.response
```

Note that all generated files only contain public keys. A leak can result in loss of the funds involved in the transaction, but will not expose any private keys.

## Mining
1. Make sure you're synched up to the tip of the chain by running `grin server run` or just `grin` and wait a few minutes (for current height on 100k in Testnet3 and with default fast sync mode) or so until you reach the tip of chain and see the debug message "Disabling sync"
2. [Build grin-miner](https://github.com/mimblewimble/grin-miner/blob/master/doc/build.md). If you do this on the same machine that the grin node runs on, they are configured to communicate with each other by default.
3. Look in the `target/debug/plugins` (or `target/release/plugins`), you will find the mining plugins that have been built. The current fastest CPU plugin is called mean_cpu, and runs best on modern (2015+) Intel CPUs. It requires the AVX2 instruction set and "lots of" RAM - try with 5GB free. Update grin-miner.toml to use your preferred mining plugin, by commenting out the mean_compat_cpu plugin and un-commenting the other faster plugin.

There are detailed instructions on how to build the GPU plugin and how to configure various plugins [in this forum post](https://www.grin-forum.org/t/how-to-mine-cuckoo-30-in-grin-help-us-test-and-collect-stats/152)

Be warned - you'll be mining test coins (no value) and there are bugs all over the place. Help us squish them!

## Known problems
When you run into problems, please see [troubleshooting](https://github.com/mimblewimble/docs/wiki/Troubleshooting)
and ask on [gitter chat](https://gitter.im/grin_community/Lobby).

Especially if you're not sure you've found a new bug,
[please ask on the chat](https://gitter.im/grin_community/Lobby).

And before you file a new bug, please take a quick look through
[known bugs](https://github.com/mimblewimble/grin/issues?utf8=%E2%9C%93&q=label%3Abug+)
and other existing issues.

## Example with 3 local nodes

The following outlines a more advanced example simulating a multi-server network with transactions being posted.

For the sake of example, we're going to run three nodes with varying setups. Create two more directories beside your node1 directory, called node2 and node3. If you want to clear data from your previous run (or anytime you want to reset the blockchain and all peer data) just delete the wallet.dat file in the node1 directory and run rm -rf .grin to remove grin's database.

### Node 1: Genesis and Miner

As before, node 1 will create the blockchain and begin mining. As we'll be running many servers from the same machine, we'll configure specific ports for other servers to explicitly connect to.

First, we run a wallet server in listen mode to receive rewards on port 15000 (we'll log in debug mode for more information about what's happening)

    node1$ grin wallet -p "password" -a "http://127.0.0.1:10001" listen -l 15000

Then we start node 1 mining with its P2P server bound to port 10000 and its api server at 10001. We also provide our wallet address where we'll receive mining rewards. In another terminal:

    node1$ grin server -m -p 10000 -a 10001 -w "http://127.0.0.1:15000" run

### Node 2: Regular Node (not mining)

We'll set up Node 2 as a simple validating node (i.e. it won't mine,) but we'll pass in the address of node 1 as a seed. Node 2 will join the network founded by node 1 and then sync its blockchain and peer data.

In a new terminal, tell node 2 to run a server using node 1's P2P address as a seed.  Node 2's P2P server will run on port 20000 and its API server will run on port 20001.

    node2$ grin server -s "127.0.0.1:10000" -p 20000 -a 20001 run

Node 2 will then sync and process and validate new blocks that node 1 may find.

### Node 3: Regular node running wallet listener

Similar to Node 2, we'll set up node 3 as a non-mining node seeded with node 2 (node 1 could also be used). However, we'll also run another wallet in listener mode on this node:

    node3$ grin server -s "127.0.0.1:20000" -p 30000 -a 30001 run

Node 3 is now running it's P2P service on port 30000 and its API server on 30001. You should be able to see it syncing its blockchain and peer data with nodes 1 and 2. Now start up a wallet listener.

    node3$ grin wallet -p "password" -a "http://127.0.0.1:30001" listen -l 35000

In contrast to other blockchains, a feature of a MimbleWimble is that a transaction cannot just be directly posted to the blockchain. It first needs to be sent from the sender to the receiver,
who will add a blinding factor before posting it to the blockchain. The above command tells the wallet server to listen for transactions on port 35000, and, after applying it's own blinding factor to the transaction, forward them on to the listening API server on node 1. (NB: we should theoretically be able to post transactions to node 3 or 2, but for some reason transactions posted to peers don't seem to propagate properly at present)

### Node 1 - Send money to node 3

With all of your servers happily running and your terminals scrolling away, let's spend some of the coins mined in node 1 by sending them to node 3's listening wallet.

In yet another terminal in node 1's directory, create a new partial transaction spending 20000 coins and send them on to node 3's wallet listener. We'll also specify that we'll
use node 2's API listener to validate our transaction inputs before sending:

    node1$ grin wallet -p "password" -a "http://127.0.0.1:20001" send -d "http://127.0.0.1:35000" 20000

The `grin-server.toml` and `grin-wallet.toml` configuration files have further information about the various options available.