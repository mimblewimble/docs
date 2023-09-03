# Grin node on Google Cloud (for free)

Thanks to Google Cloud's [Always Free](https://cloud.google.com/free/docs/frequently-asked-questions#always-free)  program, it's possible to create an instance on Cloud Compute that runs a full Grin node, 24/7, without it costing you anything. This is a cheap (free!) and fool-proof way to get a node up and running since it:

* Is not dependent on the compatibility of your computer or OS;
* Does not require you to open up ports on your network;
* Starts you off from a clean instance; and
* Allows you to follow instructions that are replicable.

The only requirement is that you are willing to sign up for a Google Cloud account and that you have a valid credit or debit card (which will not be charged).

**NOTE: This is for testing purposes only. The node is free to run, but if you make mistakes in the configuration you may incur charges. Make sure you monitor your account and billing status regularly whilst running your instance to avoid any unpleasant surprises.**

## Google Cloud Set up

1. Visit http://cloud.google.com and set up an account as an individual. This will require a debit or credit card, they do a $1 reserve charge on your card to ensure it's valid. As part of signing up you also get $300 in free trial credit to spend within 12 months.
2. In order to qualify for [Always Free](https://cloud.google.com/free/docs/frequently-asked-questions#always-free) you need to have an upgraded account. So ensure you [upgrade](https://cloud.google.com/free/docs/frequently-asked-questions#what-is-upgrade). Note that this means that you will start to be charged automatically if your spend beyond the $300 in free trial credit. As you will not exceed the [Always Free limits](https://cloud.google.com/free/docs/always-free-usage-limits) here, this point is moot, but keep it in mind for any other projects you use this account for.
3. Launch a [Cloud Shell](https://cloud.google.com/shell/) console from your browser, or install the [Google Cloud SDK](https://cloud.google.com/sdk/) to run Cloud Shell from your local terminal.

## Provisioning an instance

From the cloud shell, run the following command to create `grin-node1`, an always free-compatible instance running Linux Debian 10:

```bash
gcloud beta compute instances create grin-node1 --zone=us-east1-b --machine-type=f1-micro --tags=grin-node --image=debian-10-buster-v20191210 --image-project=debian-cloud --boot-disk-size=30GB --boot-disk-type=pd-standard --boot-disk-device-name=grin-disk1
```

## Building

Your newly created `grin-node1` should now be visible in your list of [Cloud Compute Instances](https://console.cloud.google.com/compute/instances). From there, open an SSH session in your browser by clicking the `SSH` button, or SSH to the instance [through your own terminal](https://cloud.google.com/compute/docs/instances/connecting-advanced#thirdpartytools).

As always, first update your system:

```bash
sudo apt-get update
```

Install some tools:

* git
* pkg-config
* nano, a simple text editor
* tmux, which will allow you to run multiple terminal sessions and keep your node running on your instance once you disconnect remotely. See [gentle intro](https://medium.com/actualize-network/a-minimalist-guide-to-tmux-13675fb160fa)  and [cheatsheet](https://gist.github.com/MohamedAlaa/2961058).

```bash
 sudo apt-get install git nano tmux pkg-config
```

You can now enter a tmux session by `tmux` and at any time you can close down your connection by `CTRL+b` and then `d` as in detach, and then return to it later by `tmux a` as in attach.

Next install all dependencies:

```bash
sudo apt-get install clang cmake libncurses5-dev libncursesw5-dev zlib1g-dev libssl-dev tor
```

Install rust:

```bash
curl https://sh.rustup.rs -sSf | sh; source $HOME/.cargo/env
```

Clone grin and build a release version using the commands below.  First check for the latest release version [here](https://github.com/mimblewimble/grin/releases).  If v5.2.1 is not the latest release, replace the version number below ("v5.2.1") with the latest release version before entering the command.

```bash
git clone https://github.com/mimblewimble/grin.git
cd grin
git checkout v5.2.1
cargo build --release
```

Building takes ~90 minutes on the `grin-node1` instance. Slow, but it's free. Good time for a coffee break. Alternatively, you can skip the build process by downloading the latest Grin binary from [here](https://github.com/mimblewimble/grin/releases).

Clone grin-wallet and build a release version

```bash
cd ~
git clone https://github.com/mimblewimble/grin-wallet.git
cd grin-wallet
cargo build --release
```

Building takes ~60 minutes on the `grin-node1` instance. Slow, but it's free. Good time for a coffee break. Alternatively, you can skip the build process by downloading the latest Grin binary from [here](https://github.com/mimblewimble/grin-wallet/releases).

## Syncing a Grin node

When the build has completed, create a new `tmux` session and launch your Grin node in it:

```bash
tmux new -s main
cd target/release
./grin
```

The node should automatically connect to peers and begin syncing. This might also take a while, so you might want to go for another break.

Once completed, the node should be at the same block height as [https://grinscan.net/](https://grinscan.net/). We can now detach from the tmux session running the node by pressing `ctrl+b`, then `d`. This will allow us to continue interfacing with the gcloud instance command line, with the node running in the background. If you want to check in on the node at a later time, you can attach back into it's tmux session with `tmux a -t main`

Optionally, from the cloud shell, open up your node's p2p port so it can receive inbound connections:

```bash
gcloud compute firewall-rules create main-p2p-port --direction=INGRESS --action=ALLOW --rules=tcp:3414 --target-tags=grin-node1
```

## Connecting to Google Grin node from local wallet

This will allow you to use your wallet quickly and easily without the need to wait for your local node to sync!
Follow instructions for setting up a Grin node as above. Once built and synched continue below.

To enable external api calls to your Grin node, edit your `~/.grin/main/grin-server.toml` configuration file on your Google instance:

```bash
nano grin-server.toml
```

- set api_http_addr to `0.0.0.0:3413` and host to `0.0.0.0`:

```bash
api_http_addr = "0.0.0.0:3413"
```

```bash
host = "0.0.0.0"
```

- open up your node's api port so it can receive inbound connections

```bash
gcloud compute firewall-rules create main-api-port --direction=INGRESS --action=ALLOW --rules=tcp:3413 --target-tags=grin-node1
```

- your `~/.grin/main/grin-server.toml` file on your Google instance will have an api_secret_path field (ex: `~/.grin/main/.api_secret` unless changed.) Copy the value in the file and save this for later as you will need to provide this to your local wallet.
- on your local machine, create a new file for storing the api secret from the previous step (ex: `~/.grin/main/.remote_api_secret`, but can be any location). Save file with key value copied in previous step.
- now update your local wallet configuration file: set node_api_secret_path to the path of the file created in the previous step (ex: `~/.grin/main/.remote_api_secret`) and update check_node_api_http_addr with IP address of your Google instance:

```toml
api_secret_path = "~/.grin/main/.remote_api_secret"
```

```toml
check_node_api_http_addr = "http://{YourGoogleCloudIP}:3413"
```

- Restart your node to update configuration changes. Once started, you can run wallet commands which will use your new external node. No need to start your local node and wait for synchronization on each start!

```bash
./grin-wallet info
Password:

____ Wallet Summary Info - Account 'default' as of height 235438 ____

 Confirmed Total                  | 0.000000000
 Awaiting Confirmation (< 10)     | 0.000000000
 Awaiting Finalization            | 0.000000000
 Locked by previous transaction   | 0.000000000
 -------------------------------- | -------------
 Currently Spendable              | 0.000000000

Command 'info' completed successfully
```

## Future work

* Updating your node
* Connecting to [Grin-Pool](https://github.com/grin-pool/grin-pool)
