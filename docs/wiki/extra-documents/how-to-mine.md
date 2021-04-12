# How to mine with grin-miner

## Prerequisites

* Linux or MacOS (Windows is not currently supported by grin-miner, though there are some possible alternatives.
* A relatively recent CPU
* For mainnet mining, a Recent GPU with 6GB minimum for Cuckaroo29. Nvidia 1080/2080/ti series are known to work well. Support for AMD cards via OpenCL exists but is a recent development.

These instructions also assume you've downloaded and installed the Grin software, are running a synced node, and have initialized and are comfortable with running a wallet.

## Grin POW Basics

Grin accepts 2 Proofs-of-Work. Both are variants of a concept called 'Cuckoo Cycle'.

* **CuckARoo** (or ASIC Resistant) is intended to be mined by GPUs. It can be mined using a 6GB+ GPU.
* **CuckAToo** (or ASIC Targeted) is intended to be mined by ASICs in the future. It can also be mined using 11GB+ GPUs.

Cuckoo family solvers use something called Graph Size as a parameter. This determines how much memory is needed to mine. CuckARoo uses graphs with 2^29 edges, while CuckAToo uses graphs with 2^31+ edges, hence the different memory requirements.

Cuckoo uses number of graphs searched per second, or GPS, to determine how fast someone is mining. You will generally see the term GPS as opposed to Hashrate when using Grin. The terms are used somewhat interchangeably, but GPS is more correct.

At launch, Grin will adjust to target 90% of blocks be GPU mined, and 10% ASIC mined. Under current plans, this will gradually change to 0% GPU and 100% ASIC over 2 years.

## Downloading the grin-miner Software

The latest Grin-miner release can be found on the project [Release Page](https://github.com/mimblewimble/grin-miner/releases). Binaries are currently provided for Linux and OSX.

Distribution-specific releases will likely appear over time, and will be listed here.

## Installation

### Linux (all distributions)

Download the zipped binary to your machine, and unzip it using the terminal. This will unzip into a directory called `grin-miner` which contains the `grin-miner` binary, GPU and CPU mining plugins, and the main configuration file, `grin-miner.toml`.

For now, we'd recommend placing this somewhere relative to your home directory, and editing your path environment variable to ensure the `grin-miner` executable is available from wherever you run it. All of this can be done by running the following commands in the directory to which you downloaded grin-miner (substituting the grin-miner version number where necessary).

```bash
tar -C ~/ xzf grin-miner-v1.0.2-480780316-linux-amd64.tgz
echo 'export PATH=~/grin-miner-v1.0.2:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Running Grin in Mining Mode

### Configure Grin's stratum (mining) server

In the file `~/.grin/main/grin-server.toml`, change:

```toml
enable_stratum_server = false
```

to

```toml
enable_stratum_server = true
```

## Run Grin wallet listener and Node

In one terminal window, run the wallet listener (entering your wallet password when prompted)

```bash
grin-wallet listen
```

In another, run your Grin node:

```bash
grin
```

## Configure grin-miner

All configuration options for the mining plugins can be found, fully documented, in `grin-miner.toml`. The following steps should work to get most people up and running:

### Setting up grin-miner for CPU mining

CPU Mining is Enabled by default in the configuration file. You may wish to use the `cuckaroo_cpu_avx2_29` plugin rather than the default if you have a relatively recent CPU.

### Setting up grin-miner for GPU Mining (Nvidia)

**ALWAYS ensure your nvidia drivers are up to date**

In this section, we will edit the grin-miner settings to mine with your Nvidia GPU.

First go to the CUCKAROO (i.e. GPU-Friendly) MINER PLUGIN CONFIGURATION part.

Comment out the CPU plugin configuration as follows (by adding # in front of each line):

```toml
#[[mining.miner_plugin_config]]
#plugin_name = "cuckaroo_cpu_compat_29"
#[mining.miner_plugin_config.parameters]
#nthreads = 1
```

Then, uncomment the following lines (remove the #in front of each line):

```toml
[[mining.miner_plugin_config]]
plugin_name = "cuckaroo_cuda_29"
[mining.miner_plugin_config.parameters]
device = 0
```

If you have multiple GPUs you’ll need to copy those four lines for each device and change the device number.
You may want to use device numbers in the same PCI Bus ID enumeration order as used by non-CUDA programs like nvidia-smi. To do this set the CUDA_​DEVICE_​ORDER environment variable to PCI_BUS_ID in your shell. The default value of this variable is FASTEST_FIRST. More info on this can be found [here](http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#env-vars). Note that this is available only in CUDA 7 and later.

### Setting up grin-miner for GPU Mining (AMD)

In this section, we will edit the grin-miner settings to mine with your AMD GPU.

First go to the CUCKAROO (i.e. GPU-Friendly) MINER PLUGIN CONFIGURATION part and comment the following lines (by adding # in front of each line):

```toml
#[[mining.miner_plugin_config]]
#plugin_name = "cuckaroo_cpu_compat_29"
#[mining.miner_plugin_config.parameters]
#nthreads = 1
```

Then go to the CUCKAROO (i.e. ASIC-Resistent) MINER PLUGIN CONFIGURATION part and uncomment the following lines (remove the #in front of each line):

```toml
[[mining.miner_plugin_config]]
plugin_name = "ocl_cuckaroo"
[mining.miner_plugin_config.parameters]
platform = 0
device = 0
```

If you have multiple GPUs you’ll need to copy these 5 lines for each device and change the device number.

## Running grin-miner

Ensure that your Grin node and wallet are running, then, from your `grin-miner-vx.x.x` installation directory:

```bash
./grin-miner
```

grin-miner's Test User Interface should appear and display stats for all configured cards.

## grin-miner Stats

* **Solutions Found** is the number of valid cuckoo solutions you have found. Note that this is not the same as finding a block. Only solutions that pass a further difficulty check, (as tested by the Grin stratum server) can be used to solve a block.

* **Accepted** is the number of solutions your miners found that were accepted by the stratum server as valid shares (or contributions to the pool,). Again, this does not correspond to number of solved blocks or mining rewards.

* **Rejected** is the number of rejected shares. This should be 0, otherwise there is something wrong with your mining plugin or in server communication.

* **Stale** is the number of solutions that were found to late (someone else on the network solved the block before the solution was submit).

* **Blocks found** is the actual number of blocks that you've solved, that is to say valid cuckoo solutions that passed the difficulty check and were also accepted by the network. If you're mining solo (which you are if you're following this guide,) the rewards in your wallet should be 60 Grins for each block solved.

## Mining CuckAToo

If you have an 11GB+ GPU. It should be possible to configure your plugins to solve CuckAToo (ASIC-Friendly) blocks at graph size 2^31. As an example:

```toml
[[mining.miner_plugin_config]]
plugin_name = "cuckatoo_mean_cuda_rtx_31"
[mining.miner_plugin_config.parameters]
device = 0
expand = 2
cpuload = 1
```

You will need to set `expand = 2` to allow the solutions to be performed with the available GPU memory.

Refer to the documentation in `grin-miner.toml` for further information on how to mine using Cuckatoo31.
This [Forum Topic](https://forum.grin.mw/t/what-to-mine-choosing-between-cuckatoo31-and-cuckaroo29) discusses chosing between the two PoWs.

## `cpuload` parameter

The `cpuload` parameter configurable in each CUDA GPU solver reduces the amount of work your CPU has to do during a solve at the expense of solve times.

* `cpuload = 0` (default) will solve more slowly but free up more of your CPU
* `cpuload = 1` will generally solve faster at the expense of CPU load

It's recommended to manually set `cpuload = 1` for each CUDA solver, unless your encounter specific slowdown issues with your solve times.

## Mining Pools

Once you're comfortable with mining grin, you may want to try a [mining pool](../services/list-of-services.md#mining-pools), of which there are several. Note that the Grin Project doesn't run or endorse any of these pools. Please refer to the individual pool's instructions to set up grin-miner.
