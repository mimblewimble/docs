See also https://github.com/mimblewimble/grin/blob/master/doc/build.md

# Requirements
To build the grin application from source, you need:

 - Linux or Mac OS
   - Using Windows? Then run on Linux in a VM or [help add windows compatibility](https://github.com/mimblewimble/docs/wiki/Hacking-and-contributing)
 - `cmake --version` # 3.2 or newer (only needed for building [mining plugins](https://github.com/mimblewimble/cuckoo-miner))
   - Debian stable? You might have to compile cmake from source.
 - `rustc --version` # 1.24 or newer. Please use latest `stable` version.
   - NOTE: Install via [Rustup](https://www.rustup.rs/) as `curl https://sh.rustup.rs -sSf | sh; source $HOME/.cargo/env` and **avoid your package manager's rust** for now, trust us.
 - 2 GB RAM to compile
   - Either [compile locally](https://github.com/mimblewimble/docs/wiki/More-on-building) and deploy on a memory-limited computer.
   - or the simpler, maybe slower option, to build on a 1GB VPS, do:
````
free -h # verify you DON'T already have enough swap
# No GB of swap? Then continue
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo mkswap /swapfile
sudo swapon /swapfile
free -h # verify; you should now have 2GB swap; and you can go ahead: cargo build
````
 - [git](https://git-scm.com/) with or without graphical app on top
 - Packages rocksdb, clang (required by rocksdb), libncurses (packages `libncurses5`, `libncursesw5`, `libncurses-dev`and `libncursesw5-dev`), zlib (package `zlib1g-dev`) and some more.

# Build steps

## For Testnet2

Run this in a command line

```sh
git clone https://github.com/mimblewimble/grin.git
cd grin
```

## Build steps
 1. Run `cargo build --release` (recommended) or `cargo build` (for debug mode)
 2. Seeing red messages and errors? See [troubleshooting](https://github.com/mimblewimble/docs/wiki/Troubleshooting)
 3. Build may seem to get stuck, but it probably just takes time. In the end you get a `target/debug/grin` binary that you use when you run grin.

Building locally to deploy on another platform (VPS, embedded, ...)? See below.

# Using grin

See [how to use grin](https://github.com/mimblewimble/docs/wiki/How-to-use-grin)

# Special cases and mining plugins

## Cross-compiling

It should be fairly easy and cheap to build and run a validating node everywhere (wherever Rust can run). That being said, it is possible to cross-compile `grin` on a x86 Linux platform and produce ARM binaries, for example, in order to run on a Raspberry Pi. You will need to use the `milestone/testnet1` branch and uncomment the `no-plugin-build` feature as documented [below](#cuckoo-miner-considerations) to avoid compiling and running the mining plugins.

If you have any issues with native cross-compilation in your host system, you can try using Docker and [rust-on-raspberry-docker](https://github.com/kargakis/rust-on-raspberry-docker).

## Building miner plugins

Building the `grin_pow` uses external Cuckoo mining plugins.
If you get C errors while building you can disable in `pow/Cargo.toml':

```toml
# the below line turns off mining plugin builds
features=["no-plugin-build"]
```

This may help when building on 32 bit systems or non x86 architectures.