# Errors from grin commands

## Wallet: Coins are 'confirmed but still locked'?
Like other cryptocurrencies, newly mined coins are time locked, so mined coins can't be spent immediately.  The lock time, a.k.a. COINBASE_MATURITY, is set to 1000 blocks on testnet1.

## Wallet: What's my IP:port to test receiving coins?
This is your wallet base URL, something like http://1.2.3.4:13415
NOTE: Run `grin wallet -e listen` to make your wallet reachable from outside.

## Server: "Peer request error" or other peer/network issues after restarting grin server
Possible workaround is rm -rf .grin/peers/*  then restart.

## Server: grin server or wallet crashes or hangs
Yes, this still happens quite often. You'll need to babysit grin.
Very welcome any solutions to give grin a "watchdog" solution that can restart
grin in case of trouble.


# Build errors

## Build error: Could not compile `tokio-retry`
You might want to remove any previous rust installations to avoid conflicts.
Use `rustup` to [reinstall rust and cargo as described](build.md).

NOTE: If you install rust or cargo with your package manager (most Linuxes
anno 2017) you'll get too old versions. On Debian, you might have to manually
compile cmake or get it from non-detault repositories.

## Build error: `failed to select a version for 'serde_json'`
Run `cargo update` to fix this

## Build error: can't compile crate `bitflags`
Chech `rustc --version` and note that bitflags requires rust 1.21 or newer. Install via `rustup` and recommended you also remove any rust/cargo installed via your package manager.

## Build error: can't locate stdarg.h
If librocksdb-sys fails to build, try symlinking stddef.h and stdarg.h from the gcc5 include directory. So probably from /usr/lib to /usr/include

## Build error: ` /usr/bin/ld: cannot find -lz`
On Ubuntu install the zlib development headers: `apt install zlib1g-dev`.

## Build error: `/usr/bin/ld: cannot find -lncursesw`
On Ubuntu install the ncurses development headers: `apt install libncursesw5-dev`.

# grin-doctor shell script
````bash
# ./grin-doctor.sh

GRIN_API="localhost:13415"
echo "API is $GRIN_API"

echo "Asking API for chain status..."
curl "http://$GRIN_API/v1/chain"

echo "Asking grin for client status"
grin client status

echo "Asking API for connected peers"
curl "http://$GRIN_API/v1/peers/connected"

echo "Asking wallet for info"
grin wallet info

````