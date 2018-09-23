# Overview
This is a quick tutorial on how to have an automated nightly build of grin and run the server. It pulls the latest changes from github, compiles and restarts, as well as runs grin as a service. You can follow the same principles for wallet too. This was done on an Ubuntu 16.04 host.
# Steps
## Build and run grin manually once
Follow the instructions in [this tutorial](https://github.com/mimblewimble/grin/blob/master/doc/build.md) and ensure that you have the server running properly. You should end up with three directories:
```
grin
node1
wallet
```
For this tutorial, these directories are within the `~/mimblewimble` directory.
## Set up grin as a service
Edit the file that manages a 'Grin Testnet 1 node' service:
```
sudo nano /etc/systemd/system/grin-testnet.service
```
Paste this into the file:
```
[Unit]
Description=Grin Testnet 1 node
After=network.target

[Service]
WorkingDirectory=/home/ubuntu/mimblewimble/node1
User=ubuntu
PrivateDevices=yes
Type=simple
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=60
ExecStart=/home/ubuntu/mimblewimble/grin/target/debug/grin server -m run
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
Alias=grin-testnet.service
```
Every time you edit this file, you need to tell systemd to reload:
```
systemctl daemon-reload
```
Now try to start the server:
```
sudo systemctl start grin-testnet
```
And check to see if it's running:
```
ps aux |grep grin
```
That should give you two lines of output like this:
```
ubuntu   19175  0.4  0.6 188040 54208 ?        Ssl  17:45   0:07 /home/ubuntu/mimblewimble/grin/target/debug/grin server -m run
ubuntu   27481  0.0  0.0  12944  1028 pts/0    S+   18:11   0:00 grep --color=auto grin
```
As a last step, enable this service to run at the next startup:
```
sudo systemctl enable grin-testnet.service
```
## Create the build script
Copy this text into a `nightly-build.sh` in the same directory as the above:
```
#!/bin/sh

sudo systemctl stop grin-testnet
cd /home/ubuntu/mimblewimble/grin
/usr/bin/git pull
/home/ubuntu/.cargo/bin/cargo build
sudo systemctl restart grin-testnet
sudo systemctl start grin-testnet
```
If you want to be pedantic and build from scratch every time, you can also insert `cargo clean` before `cargo build`.
## Set up the cron job
You can set up cron jobs for you the current user by executing:
```
crontab -e
```
This will open a `nano` instance and let you edit the cron file of the current user. Paste this onto the bottom of the file:
```
0 2 * * * /home/ubuntu/mimblewimble/nightly-build.sh 1> /home/ubuntu/mimblewimble/nightly-build.log 2> /home/ubuntu/mimblewimble/nightly-build.log
```
The above puts either success or fail debug output into a file in your main directory. Alternatively, if mail is enabled on your host, you can also have the results emailed to you:
```
0 2 * * * /home/ubuntu/mimblewimble/nightly-build.sh 2>&1 | mail -s "grin build FAIL" you@yourdomain.com
```
This runs the script from the previous step at 2 am UTC. You might want to adjust this time so that we don't have everyone rebuilding at the same time.
## Check that it worked
After the next 2 am UTC or whatever time you chose, you can check on whether it worked for you. If you run `ps aux |grep grin`, one line should be something like:
```
ubuntu   13065  0.5  1.0 206492 85232 ?        Ssl  02:00   5:30 /home/ubuntu/mimblewimble/grin/target/debug/grin server -m run
```
That means the server is running. Now also check that the latest version was built by running:
```
ls -l ~/mimblewimble/grin/target/debug/grin
```
That should make it all set to compile and restart every night. Enjoy!