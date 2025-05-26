# Setting up an always listening wallet

For some use cases, like mining Grin, it's important to have a wallet that is always listening for incoming transactions. For this use case and others like it, configuring `grin-wallet` as a service might be prefered.
Be warned though that the use of a password stored in a text file is required to automatically start the service, which does provide significant security concerns. Only use these instructions when you know what you are doing, e.g. for development and small amounts of funds!

## Set up grin-wallet as a service

Create a service file for `grin-wallet`:

```bash
sudo nano /etc/systemd/system/grin-wallet.service
```

Paste the following content into the file. The following configuration assumes a 'grin' user will be running the process with the wallet configuration living in `/var/lib/grin`. Wallet configuration by default is saved to the user's home directory in `.grin`. If you installed the snap package, your wallet command will be `grin.wallet` instead.

```
[Unit]
Description=grin wallet
After=network.target

[Service]
WorkingDirectory=/var/lib/grin
User=grin
Group=grin
PrivateDevices=yes
Type=simple
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=60
ExecStart=/usr/local/bin/grin-wallet listen
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
Alias=grin.service
```

Tell systemd to reload (you need to do that every time you edit this file):

```bash
systemctl daemon-reload
```

Now try to start the wallet service:

```bash
sudo systemctl start grin-wallet
```

And check to see if it's running:

```bash
ps aux | grep grin-wallet
```

That should give you two lines of output like this:

```bash
grin      269149  0.0  0.0 971240 10804 ?        Sl   Aug25   0:00 /usr/local/bin/grin-wallet listen
ubuntu    336964  0.0  0.0   7004  2168 pts/0    S+   22:02   0:00 grep --color=auto grin-wallet
```

## Handling a wallet password

If your wallet is configured with a password, the `ExecStart` line in `grin-wallet.service` should probably look something like this...

```bash
ExecStart=/bin/sh -c 'cat wallet-password.txt | /usr/local/bin/grin-wallet listen'
```

Drop you wallet's password in `wallet-password.txt`. Make sure this file lives in the configured `WorkingDirectory` and that correct read permissions are set. The contents of this file will be fed into the `grin-wallet` command.

## Verifying your wallet is online and reachable

Run the following command to get your wallet's address:

```bash
grin-wallet info
```

Grab the address that is displayed and check it with the [WALLETCHECK_API_URL](https://grinnode.live/faq#faq-technical-public-api)

[More information on grinnode.live](https://grinnode.live/faq#faq-technical-public-api)
