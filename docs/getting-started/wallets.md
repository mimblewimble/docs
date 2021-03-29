# Grin Wallets

[![Grin++](images/grinplusplus.png){ align=left width=60 }](https://grinplusplus.github.io/){:target="_blank"}

## &emsp;Grin++

</br>

GUI wallet and node written in C++ &emsp;~Windows,~ ~Linux,~ ~macOS~

??? abstract "How to: send/receive"
    === "Download"

        Download at [grinplusplus.github.io](https://grinplusplus.github.io/){:target="_blank"}

        [Troubleshooting](https://davidtavarez.github.io/2020/troubleshooting-grinplusplus/)

    === "Receive"

        * Copy your address (`grin1...`) and provide it to the other party.

        ![grin++ receive step1](images/grinplusplus-receive.png){ width=400 loading="lazy" }

        That's it. If both your wallets can communicate via Tor, the transaction is then completed automatically.

        *But if there's no Tor communication, next steps are:*

        * The sender will provide you a Slatepack message. Paste it into the Slatepack box and click Receive.

        ![grin++ receive step2](images/grinplusplus-receive2.png){ width=400 loading="lazy" }

        * Copy the Slatepack message your wallet generates.

        ![grin++ slatepack](images/grinplusplus-slatepack.png){ width=400 loading="lazy" }

        * Provide it to the sender.

        Done! The sender will finalize the transaction and post it to the network.

    === "Send"

        * Click send.

        ![grin++ receive step3](images/grinplusplus-send.png){ width=400 loading="lazy" }

        * Choose the amount of grins.

        ![grin++ receive step4](images/grinplusplus-send2.png){ width=400 loading="lazy" }

        * Enter the receiver's address and send.

        ![grin++ receive step4](images/grinplusplus-send3.png){ width=400 loading="lazy" }

        That's it. If both your wallets can communicate via Tor, the transaction is then completed automatically.

        *But if there's no Tor communication, next steps are:*

        * Copy the Slatepack message your wallet generates and provide it to the receiver (however you want).

        ![grin++ receive step4](images/grinplusplus-slatepack.png){ width=400 loading="lazy" }

        * You should get a Slatepack message back from the receiver. Paste it into the Slatepack box and click Finalize.

        ![grin++ receive step4](images/grinplusplus-send4.png){ width=400 loading="lazy" }

        Done! Your wallet will now finalize the transaction and post it to the network.

---

[![Niffler](images/niffler.png){ align=left width=60 }](https://github.com/grinfans/Niffler){:target="_blank"}

## &emsp;Niffler

</br>
GUI wallet and node using the Rust implementation as back-end &emsp;~Windows,~ ~Linux,~ ~macOS~

??? abstract "How to: send/receive"
    === "Download"

        Download at [github.com/grinfans/niffler/releases](https://github.com/grinfans/niffler/releases){:target="_blank"}

        (by clicking on one of the listed download links)

    === "Receive"

        * Click on Receive, then Slatepack address.

        ![niffler receive step1](images/niffler-receive.png){ width=400 loading="lazy" }

        * Copy your address (`grin1...`) and provide it to the other party.

        That's it. If both your wallets can communicate via Tor, the transaction is then completed automatically.

        * But if there's no Tor communication, next steps are:*

        * The sender will provide you a Slatepack message. Click again on Receive, then on Create response slatepack. Paste it into the Slatepack box and click Create response slatepack.

        ![niffler receive step1](images/niffler-receive2.png){ width=400 loading="lazy" }

        * Copy the new Slatepack message your wallet generates.

        ![niffler receive step1](images/niffler-slatepack.png){ width=400 loading="lazy" }

        * Provide it to the sender.

        Done! The sender will then finalize the transaction and post it to the network.


    === "Send"

        * Click on Send, then Create slatepack.

        ![niffler send step1](images/niffler-send.png){ width=400 loading="lazy" }

        * Enter the address and amount, then Create slatepack.

        ![niffler send step2](images/niffler-send2.png){ width=400 loading="lazy" }

        * Copy the Slatepack message your wallet generates and provide it to the receiver (however you want).

        ![niffler send step3](images/niffler-slatepack.png){ width=400 loading="lazy" }

        * You should get a Slatepack message back from the receiver. </br> Click on Send, then on Finalize.

        ![niffler send step4](images/niffler-send4.png){ width=400 loading="lazy" }

        * Paste the Slatepack message into the box and confirm.

        Done! Your wallet will now finalize the transaction and post it to the network.

---

[![Ironbelly](images/ironbelly.png){ align=left width=55 }](https://ironbelly.app){:target="_blank"}

## &emsp;Ironbelly

</br>
Mobile wallet &emsp;~iOS,~ ~Android~

??? abstract "How to: send/receive"
    === "Download"

        Download at [https://ironbelly.app](https://ironbelly.app/){:target="_blank"}

    === "Receive"

        Soon

    === "Send"

        Soon

---

</br>

# Related Services

[![grinnode.live](images/grinnode-live.png){ align=left width=90 }](https://grinnode.live/){:target="_blank"}

## &emsp;Grinnode.live

</br>
Public GRIN API and sync service

---
