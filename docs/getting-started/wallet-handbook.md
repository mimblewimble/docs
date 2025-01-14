# CLI Wallet User Handbook

Now that you've set up your node and learned how to form a simple transaction, let's get to know the wallet more deeply. The following document is an extremely comprehensive user guide to the reference grin wallet implementation, `grin-wallet`.

!!! tip "GUI Wallet"
    Instructions on how to transact with a graphical user interface can be found in [wallets](wallets.md).

## File Structure

By default, grin will create all wallet files in the hidden directory `.grin` under your home directory (i.e. `~/.grin`). You can also create and use a wallet with data files in a custom directory, as will be explained later.

A grin wallet maintains its state in an Lightning Memory-Mapped Database (LMDB), with the master seed stored in a separate file. When creating a new wallet, the file structure should be as follows:

```text
[wallet directory]
├── grin-wallet.log
├── grin-wallet.toml
├── tor
└── wallet_data
    ├── db
    │   └── lmdb
    │
    └── wallet.seed
```

* `grin-wallet.toml` contains configuration information for the wallet. You can modify values within to change ports, the address of your grin node, or logging values.

* `wallet.seed` is your master seed file; the private keys of all your outputs are derived from it, and its contents are encrypted with your wallet password. The seed file can be recovered using the seed phrase.

* `tor` folder contains Tor configuration files used by the wallet listener. There should be no need to manipulate anything in this directory manually.

??? note "Tor Configuration &#8628;"

    `grin-wallet.toml` contains a [tor] section used to configure values when sending or listening via TOR:

    * `use_tor_listener` specifies whether the Tor listener should also be invoked when starting the wallet listener via `listen` (default = true).

    * `socks_proxy_addr` contains the listening address of TOR's socks proxy port. This should generally be left alone.

---

## help

`grin-wallet help` will display all the commands and every global flag.
</br> To get additional info about a specific command type `grin-wallet help [command]`, e.g:

```text
grin-wallet help send
```

!!! note ""
    You can also pass `--help` or `-h`.

## init

Before doing anything else, the wallet files need to be generated via the `init` command:

```text
grin-wallet init
```

You'll be prompted to enter a password for the new wallet. It will be used to encrypt your `master.seed` file and you'll be asked to type it for most wallet commands.

By default, your wallet files will be placed into `~/.grin`. Alternatively, if you'd like to run a wallet in a directory of your choice, you can create one in the current directory by using flag `-h`, e.g:

```text
grin-wallet init -h
```

This will create all the needed data files, including `grin-wallet.toml` and `wallet.seed`, in the current directory. When running any `grin-wallet` command, grin will check the working directory if these files exist. If not, it will use the default location `~/.grin`.

Upon a successful `init`, the wallet prints a 24-word recovery phrase, which you should write down and store in a non-digital format. This phrase can be used to re-create your master seed file if it gets lost or corrupted, or if you forget the wallet password.

!!! note ""
    If you'd prefer to use a 12-word recovery phrase, you can use the `-s` `--short_wordlist` flag.

### init --recover

If you need to recreate your wallet from an existing seed, you can `init` a wallet with a recovery phrase using the `-r` `--recover` flag. For example, the following command initializes a wallet in the current directory.

```text
grin-wallet init -hr
```

```text
File /home/tomriddle/wallet/grin-wallet.toml configured and created
Please enter your recovery phrase:
```

On the first run, the wallet will scan the entire chain and restore any outputs that belong to you.

## account

The `account` command is used to manage wallet accounts. Let's print a list of your existing accounts:

```text
grin-wallet account
```

Accounts could be thought of as somewhat similar to different bank accounts under the same name. Each account acts as a separate wallet, but they are all derived from the same master seed. The `default` account is created when you initialize the wallet.

To create a new account, pass the argument `-c` `--create`.

```text
grin-wallet account -c jedusor
```

This will create a new account called 'jedusor'.

All `grin-wallet` commands can then be passed the argument `-a` to specify an account for the command (otherwise `default` account is used), e.g:

```text
grin-wallet -a jedusor info
```

## info

The `info` command summarizes wallet account balance.

```text
grin-wallet info
```

```text
____ Wallet Summary Info - Account 'default' as of height 813137 ____

Confirmed Total                  | 5779.473029600
Awaiting Confirmation (< 10)     | 0.000000000
Awaiting Finalization            | 139.851133700
Locked by previous transaction   | 389.859133700
-------------------------------- | -------------
Currently Spendable              | 5779.473029600
```

* **Confirmed Total** is your balance including both spendable coins and those awaiting confirmation.
* **Awaiting Confirmation** denotes the balance from transactions that have appeared on-chain, but for which your wallet is waiting a set number of blocks before treating them as spendable (default is 10 blocks).
* **Awaiting Finalization** is the balance from transactions that have not yet appeared on-chain. This could be due to the other party not having broadcast the transaction yet. Also, when you are the sender of a transaction, your change output will be denoted in this field as well.
* **Locked by previous transaction** shows the amount of coins locked by a previous transaction you have made and that is currently awaiting finalization. This is usually made up both of the amount being sent and of the change outputs waiting to be returned back to your wallet. </br>
Once the transaction appears on-chain, this balance unlocks and the output that was used will again become available for spending.

## address

To get your wallet address, enter the `address` command.

```text
grin-wallet address
```

```text
grin1chv9p4uxp3qgl6qp4w6x5p2434varqwl6fdevg6342qr
```

This command outputs the same address as using the `listen` command. The address serves a triple purpose:

* If Tor is available, it will serve as your Tor onion address.
* A key to encrypt the slatepack messages exchanged between you and your counterparty (more on that below).
* Payment proof identification.

!!! info "Address"
     This is not the same concept of address that other cryptocurrencies might use; A Mimblewimble chain has no addresses. It is used purely for wallet to wallet communication.

## listen

The `listen` command opens up a Tor listener.

```text
grin-wallet listen
```

This will automatically configure a Tor hidden service and makes the wallet listen to it for incoming transactions. This allows you to transact directly through Tor with other users who are sending grins to your `grin1...`. Your wallet will listen for requests until the process is cancelled (`<Ctrl-C>`).

!!! note ""
    `tor` or `tor.exe` need to be available on the system path.

## send

The `send` command is the first step of building an interactive transaction. The transaction can either be an instant synchronous exchange through Tor, or it can be an asynchronous process, in which each step is done manually by exchanging easily copy-pastable strings called slatepacks.

The choice between the two methods is handled automatically by using `send` in the form of `send -d <address> <amount>`.

```text
grin-wallet send -d grin1dhvv9mvarqwl6fderuxp3qgl6qpphvc9p4u24347ec0mvvg6342q4w6x5r 180
```

This command tries to send `180` grins to the specified address via Tor. If both wallets are accessible, the transaction would complete immediately with no further steps required.

If the above communication fails, for whatever reason, your wallet will output a slatepack message:

```text
BEGINSLATEPACK. HctgNGXrJDGFY3B KrEF1meAezGjxQ6 Z93QF6Ps2m9yKCQ LfhZvpDY9ZXViM7 nDoNeMvwtYV2crr 8gDqvYDmtRfLL3n Uabao7VyWR4AuYg TXQUSWU83kEhKmr bRtdRjvpisx1LYo 9cyZGfsgsd7ZvDJ KKZPHhcPe4Eivtv cMvee3nwFFY3ZnM SoULNaHVJ38h3tZ vMXQMoMLB17L53o Xy6QQjDaG8avUBt LQq2GfGRTiUPQgn vQwFzfZPVzVKNLk
5AFmUQFZtiVdTJV xHvc1BuAqcamerv Y76KVccPY3WGupy 4zWFpkjTH65XNiH XqQnkb3EA1iVrHc tyTJ1PWb6X6oV1k ktYiWBpatyTirRy CywPyjr6c8XLr4Q 9VoCedU5BcdFdMB ACqQTwjgVXqjHoS 58ZPKFitjeH67Ts ah6twcKtMaFmTXD i7JEQ7qV6cewgxH 2jwWFxbb98mye6A Lm9movc6Wer26L2 91WQD3cbVpAZLEs APFPtyxnWjv8n3W
ZXFLR2TPZwGc5Vt zwFUPoyWfKXasQy VVV6tbKWEEhqAZR e34M7uEwfurpUUi 9812VFPY1qw3K9b ynwQXuXMuWQCUnU s1JqWqFgSQKENUP tGCK19dys9twghA FaAc7ZXQHdMbUoL sVxVfdjE94F1Wpj M7QAM5VZuaauHdQ Mt2erFyxJ5vsYSZ hgS553UKoQL5YWX E7oRNdMDkJV6VkL i55kAQc1vWvW9ce 3MoXiBT4TJ1SyNS NVZKxgk8c. ENDSLATEPACK.
```

This message contains the data required for the receiver's wallet to process the transaction via the `receive` command. This slatepack is also encrypted for the recipient only, since you provided an address (which is a public key) by using the `-d` flag.

**Non-encrypted slatepack**

If the receiver does not want, or is not able to provide an address, you could use command `send` *without* the `-d` `--dest` flag.

```text
grin-wallet send 180
```

In this case, the wallet will simply output a non-encrypted slatepack message which can be sent to anybody.

### more flags

* `-m` `--manual` if present, don't attempt to interact via Tor, only output slatepack message.
* `-f` `--fluff` if present, ignore the dandelion relay protocol. Dandelion bounces your transactions directly through several nodes in a stem phase, after which the transaction randomly fluffs (broadcast) to the rest of the network.
* `-n` `--no_payment_proof` if present, do not request the data required for a payment proof. This shortens the slatepack message length.
* `-e` `--estimate-selection` if present, performs a "dry-run" of creating the transaction, without actually doing anything and locking the funds. It then lists different output selection strategies (outlined below) and their possible effect on your wallet outputs, if chosen.
* `-s` `--selection` allows you to choose between two output selection strategies, `small` and `all`. The default strategy is `small`, which includes the *minimum* number of inputs to cover the amount, starting with the smallest value output. In contrast, using `all` consolidates *all* of your outputs into a single new output, thus reducing your wallet size, increasing operation speed and reducing the UTXO-set size of the chain. The downside is that the entire contents of your wallet remain locked until the transaction is validated on-chain, and all outputs are linked to one another, a detriment to your privacy.
* `-b` `--ttl_blocks` allows you to specify a number of blocks into the future, after which a wallet should refuse to process the transaction further. This can be useful for putting time limits on transaction finalization, but please note this is not enforced at the grin protocol level; it's up to individual wallets whether they wish to respect this flag.

## receive

The `receive` command processes the slatepack message provided by the sender.

```text
grin-wallet receive
```

After entering the command, you'll be prompted to input the slatepack. </br>
Then your wallet will output another slatepack message to provide the other party, so they can `finalize` the transaction.

!!! info "Files"
    When sending or receiving via slatepacks, the wallet will also create a text file containing the message it generated. Default path is `~/.grin/main/slatepacks`.

    To receive grins using a file, type:

    ```text
    grin-wallet receive -i $PATH/file.tx
    ```


## finalize

The `finalize` command is the final step to any slatepack transaction.

```text
grin-wallet finalize
```

After entering the command, you'll be prompted to input the slatepack message provided to you by the receiver.

The transaction building process will then be finalized and your wallet will post it to the network.

If the flag `-n` `--nopost` is present, the transaction would be finalized but not posted.

## post

Manually post a finalized transaction to the network. Either type `grin-wallet post` and enter the slatepack message into the prompt, or specify the file path using the `-i` flag.

```text
grin-wallet post -i "~/.grin/main/slatepacks/my_tx.S3.slatepack/"
```

## proof

Grin's privacy and scalability mechanics mean users no longer have the ability to simply prove a transaction has happened by pointing to it on the chain. By default, whenever a transaction sent to a destination address using `-d`, a payment proof is created.

Payers can then use these proofs to resolve future payment disputes and prove they sent funds to the correct recipient.

The *sender* can export the payment proof by specifying the transaction id (`-i`) (obtained by [txs](#txs)) or the tx-UUID (`-t`), and choosing the path for the proof file, e.g:

```text
grin-wallet export_proof -i 4 "~/Documents/proof.txt"
```

The sender can then provide this proof to any other wallet for verification.

Verification for e.g.

```text
grin-wallet verify_proof $PATH/proof.txt
```

This will ensure that:

* The kernel for the transaction in the proof is validated and can be found on-chain.
* Both the sender and recipient's signatures correctly sign for the amount and the kernel.

On top of that, if the receiver's address in the transaction belongs to the same wallet who's verifying, then the user will be informed as follows:

```text
grin-wallet verify_proof proof.txt
```

```text
Payment proof's signatures are valid.
The proof's recipient address belongs to this wallet.
Command 'verify_proof' completed successfully
```

## invoice

The `invoice` command sends an invoice transaction, in which the initiator requests an amount for payment and sends that request to another party.

Since invoice transactions require manual confirmation from the party paying the funds, they can only be created and sent to payers via slatepack.

```text
grin-wallet invoice -d grin1dhvv9mvarqwl6fderuxp3qgl6qpphvc9p4u24347ec0mvvg6342q4w6x5r 60
```

This command will create an encrypted (since `-d` is provided) invoice, requesting a payment of `60` grins. The resulting slatepack can then be sent to the other party for them to [pay](#pay).

Upon receiving the back the slatepack from the payer, the transaction can then be finalized and posted using the `finalize` command.

## pay

After receiving an invoice request, the payer can use the `pay` command to decode (also decrypt if possible) the slatepack and confirm the amount of coins being requested as payment.

```text
grin-wallet pay

Please paste your encoded slatepack message:
BEGINSLATEPACK. P9rVoTRyKdhVsuC a5SfwQMXbtsDBwD omfeWYWwkbK9AUD k2pZvpgeXmJSUcv y9Mi81ngsCrpW9r QW226CWwbxrSprJ cCJA9cACpguBHDj eExN8vuYc1SHj9B 2Xa1BPGB77kpY9q uG9eXmaeprY6CQt PAibwfMnwxVDJFU EeQfwwSnEUADkg3 wBYXcuSVTnfJ4Jj DnqawMkmAiWvhNm WLrdZ1Vh3P6TXP6 ZgJG9pRNi51mAtU 9soyVAgvFWoEpgn VA6suegVxTsWN1r V3LQHB7bjwX5Rwa yPfqhGTLwR. ENDSLATEPACK.

This command will pay the amount specified in the invoice using your wallet's funds.
After you confirm, the following will occur:

* 10.000000000 of your wallet funds will be added to the transaction to pay this invoice.
* The wallet will IMMEDIATELY attempt to send the resulting transaction to the wallet listening at: 'grin1ln4y82fw4urggk3hq0xkeqfhw3dfe6rhcv6a0v64uz4ny9epcc6qpuwx4k'.
* If other wallet is not listening, the resulting transaction will output as a slatepack which you can manually send back to the invoice creator.

Please review the above information carefully before proceeding

To proceed, type the exact amount of the invoice as displayed above (or Q/q to quit) >
```

To confirm the payment, type the exact amount in decimal, `10.000000000` in this example, into the prompt. Your wallet will then fill out the transaction slate and return a slatepack for you to provide back to the initiator, which they can then `finalize`.

## unpack

Upon receiving a slatepack message or file from a party, whether in an encrypted form or not, the `unpack` command decrypts and decodes it to a bare slate JSON format (the format used by the wallet to read and construct transactions).

```text
grin-wallet unpack
```

This prompts you for a slatepack message. to decode a file, use the `-i` flag and provide the path.

Result:

```text
SLATEPACK CONTENTS
------------------
{
  ...
}
------------------
Slatepack is encrypted for this wallet

DECRYPTED SLATEPACK
-------------------
{
  ...
}

DECRYPTED SLATE
---------------
{
  ...
}
Command 'unpack' completed successfully
```

## outputs

To show a list of all your wallet's outputs, type:

```text
grin-wallet outputs
```

```text
Wallet Outputs - Account 'default' - Block Height: 814491
---------------------------------------------------------------------------------------------------------------------------------------------------------------
 Output Commitment                                                   MMR Index  Block Height  Locked Until  Status   Coinbase?  # Confirms  Value           Tx
===============================================================================================================================================================
 08f4f062b99223d2d8a1ad1ae11085ab2d7b4f1bc603f9c29748f1b918861fdf23  7498573    743936        743936        Unspent  false      70556       5198.081029600  1
---------------------------------------------------------------------------------------------------------------------------------------------------------------
 097fe8bf1ad6a792600d5e010d0b77c40b147ea122c176476259f100a48924d40c  7832632    790025        790025        Unspent  false      24467       581.392000000   2
---------------------------------------------------------------------------------------------------------------------------------------------------------------
 08645896f150bfc70f36a602a7a5f41180ae8d5db42864f19f7257542cf2c7fc98  None       811501        0             Unspent  false      2991        389.859133700   9
---------------------------------------------------------------------------------------------------------------------------------------------------------------
```

By default, only unspent outputs are listed. To show spent outputs, provide the `-s` flag.

```text
grin-wallet -s outputs
```

## txs

Every time an action is performed in your wallet (send, receive, even if uncompleted), an entry is added to an internal transaction log containing vital information about the transaction. Because the grin blockchain contains no identifying information whatsoever, this transaction log is necessary for your wallet to keep track of transactions. To view the contents of your transaction log, use the command:

```text
grin-wallet txs
```

```text
Transaction Log - Account 'default' - Block Height: 814448
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Id  Type         Shared Transaction Id                 Creation Time        TTL Cutoff Height  Confirmed?  Confirmation Time    Num.    Num.     Amount        Amount       Fee    Net           Payment   Kernel                                                              Tx
                                                                                                                                 Inputs  Outputs  Credited      Debited             Difference    Proof                                                                         Data
=====================================================================================================================================================================================================================================================================================
 0   Received Tx  2b2ffc5e-8fa0-4450-b270-078df29b3e23  2020-07-28 13:18:18  None               true        2020-07-28 13:18:18  0       1        389.892       0.0          0.007  389.892       None      ddec166399348a24d2893c025b4b4d4a058f81834a663284ba23fe0bd0ac025b4b  Yes
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1   Sent Tx      fd9b3035-73d0-4ea3-8c3e-5d45c512ad8b  2020-08-03 15:32:19  None               true        2020-08-03 15:42:20  2       1        389.8591337   390.8661337  0.007  -1.007        Yes       0834a66310df8a8b43093c025b4b4d4a058f8188ee24d2809e338e0bd0ae9e2c2c  Yes
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 2   Sent Tx      ea92fcce-8fa0-48d0-b270-078df2e22d24  2020-08-04 18:51:47  None               false       None                 1       1        139.8511337   389.8591337  0.008  -250.008      None      09fd95b4e40ce1c2d67376d46dc37ddec1aa0ae50ca9934ba271fff0b47510c72f  Yes
     - Cancelled
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```

To see the inputs & outputs associated with a particular transaction, as well as the payment proof associated with the transaction, use the `-i` switch and specify the id of the transaction, e.g:

```text
grin-wallet txs -i 0
```

## cancel

Cancels an in-progress created transaction, freeing previously [locked outputs](#info) for use again.

```text
grin-wallet cancel -i 2
```

To specify which transaction to cancel, use the `-i` flag along with the tx id (obtained by [txs](#txs)) or the `-t` flag with the tx-UUID.

## scan

The `scan` command scans the entire UTXO (unspent tx outputs) set from the node, identifies which outputs are yours and updates your wallet state.

```text
grin-wallet scan
```

It should not be necessary to run the scan command manually, as the wallet continually scans the outputs on the chain. However, if for some reason you believe your outputs and transactions are in an inconsistent state, you can initiate a manual scan to attempt to fix or restore them.

**flags**

* `-d` `--delete-unconfirmed` if present, scan and cancel all pending transactions, freeing up any locked outputs.

* `-h` `--start-height` lets you specify a block height from which to start the manual scan.

!!! text ""
    When initializing a wallet from an existing seed via the grin-wallet `init -r command`, this scan is performed automatically on the first run.

## recover

The `recover` command displays the existing wallet's 24 (or 12) word seed phrase.

```text
grin-wallet recover
```

---

## arguments

There are several global wallet arguments which you can provide for every command.


### rewind_hash and scan rewind_hash 

Ensure the transparency (spending, receiving, balance etc) of a wallet that receive grin as donations.  

Allow everyone to scan the rewind_hash of the wallet shared publicly.


   - get the rewind_hash of the wallet

   - scan of the rewind_hash of a third-party wallet
```text
get_rewind_hash: `grin-wallet rewind_hash`
```

```text
scan_rewind_hash: `grin-wallet scan_rewind_hash 2c95b24de492395934a8a345440ed0ebbe67ee0025b348712a927a91c7fe58e9`
```


### account

To set the account for a wallet command, provide the `-a` argument.

```text
grin-wallet -a jedusor info
```

### password

You could specify your password on the directly command line by providing the -p argument. Please note this will place your password in your shell's command history, so use this switch with caution.

```text
grin-wallet -p mypass info
```

### node

The wallet needs to talk to a running grin node in order to remain up-to-date and verify its contents. By default, it tries to contact a node at 127.0.0.1:3413. To change this, either modify the value in the `grin_wallet.toml` file, or alternatively, you can provide the `-r` (se **r** ver) switch to wallet commands.

```text
grin-wallet -r "http://192.168.0.2:3413" info
```
