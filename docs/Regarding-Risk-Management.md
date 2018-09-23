_This document outlines some of the current thinking in parts of the community. This is not the final word on the topic. There has been no overall agreement. This is an editable wiki, anyone is free to contribute to this document. For meta-discussion about the contents, see [this forum post](https://www.grin-forum.org/t/wiki-regarding-risk-management/617)._

# Introduction
This document is part of a series on Governance of the Grin project. It identifies potential risk scenarios and what the proposed course of action would be to mitigate against them, and what the response would be in the event of any of them actually occurring. This document is non-binding. Every situation is unique and will require its own consideration. This is an exercise to gather the community around certain principles and approaches that may indicate core values and what a future mission statement could look like.

The next section describes the scenarios. This is followed by a set of general principles that are desired for any actions. After, mitigations to take before a risk has occured and response actions to take after risks have occurred are outlined. The final section provides a summary with general conclusions.

# Risk events

In no particular order.

* **Igno disappears.** Without prior notice Igno disappears from the project without leaving a trace, any instructions, or information. Relevant real world example is when the [author of Python decided to unilaterally resign](https://mail.python.org/pipermail/python-committers/2018-July/005664.html).
* **Members on technocratic council infiltrated/coerced.** A hostile actor or authority steals the identity or coerces one or several members of the technocratic council to act on their behalf in order to control the project. Or operate undercover to gain trust and authority and then work to subvert it. Because some members are pseudonymous, it can be particularly hard to determine whether this event has occured.
* **Technocratic council breaks down.** A severe disagreement causes a rift in the council and half abandon the project in anger. Say there's also vacant seats and it ends up not being enough members left to build a quorum and elect new members. Relevant real world example is when the [Swedish Academy had to cancel awarding  this year's Nobel Prize in literature](https://www.bbc.com/news/world-europe-43974363) due to internal infighting.    
* **Discrete logarithm problem is no longer hard**, a.k.a. "Quantumaggedon". Quantum computing advances or some other breakthrough lead to a state actor or large technological conglomerate being able to compute general discrete logarithms in polynomial time. Undermining the cryptographic foundation on which Grin is based on.
* **Critical bug/attack that leaks privacy.** It is uncovered that there is an exploit that leads to user privacy being leaked. Things like transaction amounts, IP/locations, timestamps, and other sender/recipient data. It is assumed that the exploit has been used. 
* **Critical bug/attack that leaks inflation.** It is uncovered that there is an exploit that makes it possible to create grins out of thin air. The existing supply does not match what is expected by the emission rate, meaning some actor(s) have taken advantage of this.  
* **Critical bug/attack that compromises wallet funds.** An attacker is able to freeze or spend funds in wallets that are not theirs and starts reaping havoc on the blockchain. Real world example is the [Parity bug](https://blog.comae.io/the-280m-ethereums-bug-f28e5de43513).
* **Exchange is hacked.** The Grin Exchange, one of the few crypto exchanges that accept Grins is hacked, leading to a large double digit percentage of all issued grins to fall in an attacker's hands. Real world example is the [NEM hack on Coincheck](https://www.theverge.com/2018/1/27/16940598/coincheck-hack-500-million-nem-tokens-cryptocurrency).
* **Criminal users lead to PR disaster.** A high profile event / attack occurs that is linked to Grin usage and the spotlight is turned on the project and its stance on privacy. Relevant world example is the [Apple-FBI encryption dispute](https://en.wikipedia.org/wiki/FBI–Apple_encryption_dispute). 
* **Developers are raided / harassed / prosecuted.** Due to PR disaster above, political pressure builds to motivate government authorities to doxx anonymous developers and "make an example" by arresting them and issue criminal arrest warrants on other developers associated with the project. It's important to note here that it is irrelevant whether there is an actual valid legal case against the developers.    
* **Civil suit against developers.** Due to wallet bug above, or the exchange hack, where the exchange had been a donor to the Grin project and the exchange had been promoted as a sponsor and recommended exchange on the project home page, a class action suit is filed against the developers holding them accountable for being part in the loss of funds. Real world example would be the [controversies around the Bitgrail / Nano hack](https://cointelegraph.com/news/strange-twists-and-turns-of-nano-and-bitgrail-since-the-150-mln-hack).   
* **MPAA-style prosecution / take down notices.** Due to PR disaster above, web hosting providers are asked to take down anything that hosts Grin-related material, domain names are seized, Github repo is closed, and so on. Real world example would be the [attempts to shut down the Pirate Bay](https://medium.com/@jbackus/resistant-protocols-how-decentralization-evolves-2f9538832ada). 
* **Grin is declared illegal.** It becomes illegal to develop or use Grin in certain countries. Real world example is the [ongoing efforts to stop 3D-printed guns](https://www.vox.com/2018/7/31/17634558/3d-printed-guns-trump-cody-wilson-defcad).  
* **Losing control of Github repo.** An attacker gains access to the Github repo and either takes it over completely and/or inserts malicious code stealthily. Real world examples would be the [recent homebrew attack](https://medium.com/@vesirin/how-i-gained-commit-access-to-homebrew-in-30-minutes-2ae314df03ab) and [Gentoo hack](https://thehackernews.com/2018/06/gentoo-linux-github.html).  
* **ASIC announcements.** An ASIC manufacturer announces a specialised ASIC for Grin PoW mining with 50-500x efficiencies. It's also assumed that there's stealth ASIC mining happening already on the network. Real world example would be [Monero ASIC announcements](https://twitter.com/BITMAINtech/status/974180147166261248).  
* **Threats of 51% attack.** Mining entity announces they have enough hash power to pull off 51% style attack, or it is calculated that they now have this power but are yet to use it.
* **Actual 51% attack.** One or several 51%-style attacks occur against Grin. Real world example would be the [Verge hacks](https://blog.theabacus.io/the-verge-hack-explained-7942f63a3017).
* **Rapid fund appreciation.** Due to a sudden rapid movement in Grin price the central development fund is now worth seven figures. There's heated debate in the community on how to spend it. Disagreements on the technocratic council.
* **Accidental fork.** Due to a perfect storm of an undiscovered critical flaw and an extraordinary combination of events, the Grin blockchain accidentally forks into multiple chains where miners unknowingly mine on different chains for a long enough period of time for this to become an issue. Multiple transactions and coinbase branches risk becoming invalidated and motivated parties end up arguing about which chain is the one true right chain.     
* **Intentional fork.** An insurgency in the community or external parties decide to fork away, creating a "Grin Classic" / "Grin Fixed Supply" / "Grin Diamond" etc variant. Parts of mining and dev community might join them in the promise of increased riches and more glorious glory.   

**TO DO:**
Add [risk evaluation map](http://www.chem.lu.se/education/shed/SHED/Risk_Evaluation_files/Riskeval_2.png). 
Integrate [Reducing the risk of catastrophic cryptocurrency bugs](https://medium.com/mit-media-lab-digital-currency-initiative/reducing-the-risk-of-catastrophic-cryptocurrency-bugs-dcdd493c7569)
Add
* **No exponential growth in first 2 years (or even 1 year)** Grin community seems to have Blitzkrieg expectations like hockey stick growth in number of users and coin price. It may not happen and as a result community will be demotivated, including developers which may lead to the project stagnation.

# General principles

TBD

## _@lehnberg's interpretation based on approaches below_

* **Design for division of power.** Avoid centralising authority and decision making when this is possible. Decisions are made at the "lowest" level they can practically be made (but never lower), and not at the "highest" level for the sake of a group or individual exercising some authority. The lesser importance a single entity has, the lower the impact a possible failure will have. This is preferred even when it comes at a cost of efficiency, co-ordination, and velocity. Only lead on matters that truly require it.

* **Ensure redundancy.** Avoid creating single points of failure. Always have multiple backup solutions. Regardless of whether it being logins, domains, data, people, or processes. Same principle applies. 

* **Stay focused.** Keep things simple. Do as little as possible (but never less), and let the community organically handle the rest. Do not get involved in matters and areas that are beyond the scope of nurturing sustainable development of the Grin protocol.

* **Be neutral.** Protect the interests of the protocol, and the protocol stays neutral. No side-taking, no grandstanding. Stay out of conflicts by not participating in matters that are out of scope. When there is involvement in conflicts that have a risk at impacting the sustainable development of the Grin protocol, broker and facilitate agreement between parties in the community.

* **Adhere to scientific principles.** Use reason. Avoid emotional or dogmatic decision making. Know what is not known. Experiment. Validate assumptions where possible. Peer review approaches and rationale. 

* **Achieve resiliency through transparency.** Document processes and decisions. Keep the conversation public. Ensure the community can audit. Embrace openness. Avoid secrecy.     

# Mitigation & Response plans

|| Mitigation plan:<br>Reducing risk _before_ the event occurs| Response plan:<br>Actions to take _after_ the event has occurred|
|---|---|---|
|**Igno disappears**|
|**Members on technocratic council infiltrated/coerced**|
|**Technocratic council breaks down**|
|**Discrete logarithm problem is no longer hard**| if due to slowly advancing quantum computers, then grin needs to migrate to a post-quantum commitment/signature scheme, yet to be picked and implemented. hashing (such as in our MMRs) and proof-of-work are immune | if DL is found to be easy classically, then nearly all crypto will fail instantly and we're all screwed...
|**Critical bug/attack that leaks privacy**|
|**Critical bug/attack that leaks inflation**|
|**Critical bug/attack that compromises wallet funds**|
|**Exchange is hacked**|
|**Criminal users lead to PR disaster**|
|**Developers are raided / harassed / prosecuted**|
|**Civil suit against developers**|
|**MPAA-style prosecution / take down notices**|
|**Grin is declared illegal**|
|**Losing control of Github repo**|
|**ASIC announcements**| ASICs are to be expected, and welcomed if publicly available. | Stealth ASICs justify either a graph size upgrade, or if that doesn't work, a Monero style tweak.
|**Threats of 51% attack**|
|**Actual 51% attack**|
|**Rapid fund appreciation**|
|**Accidental fork**|
|**Intentional fork**|

# Concluding remarks

TBD

# Igno's version of the above

|| Mitigation plan:<br>Reducing risk _before_ the event occurs| Response plan:<br>Actions to take _after_ the event has occurred|
|---|---|---|
|**Igno disappears**|Make sure Igno has no sole control over any project-critical resource|Be nice to each other, keep things going without drama, potentially vote for another last-resort-decision person|
|**Members on technocratic council infiltrated/coerced**|Monitor the council for symptoms of cartelization, question positions that seem out of character or inconsistent|Ask people to resign or kick them out, being in the council should have very little benefits anyway|
|**Technocratic council breaks down**|Address conflicts early, try to get the individuals involved to talk (if possible), keep everyone civil, find a middle ground or a way to later reverse a bad decision, recognize that a bad decision is often better than no decision at all|Kick the ones that can't move on out|
|**Discrete logarithm problem is no longer hard**| Implement zero-cost switch commitments (#998), keep an eye on QC R&D and possible exploits | Enact switch commitments |
|**Critical bug/attack that leaks privacy**| 
|**Critical bug/attack that leaks inflation**|
|**Critical bug/attack that compromises wallet funds**| Covenants would be nice | 
|**Exchange is hacked**| Advise exchanges of proper security procedure when possible | Reach out to help them with possible mitigations. No forks or rollbacks.|
|**Criminal users lead to PR disaster**|Anticipate those scenarios, document them, and explain the importance of privacy, even in the presence of criminality|Point out to those documents|
|**Developers are raided / harassed / prosecuted**| Reserve some emergency funds to help developers out | Help developer "go dark", deploy funds if applicable|
|**Civil suit against developers**|Reserve some emergency funds to defend developers|Reach out and fund qualified lawyers for the defense|
|**MPAA-style prosecution / take down notices**|Avoid having critical resources that can be seized|Ignore|
|**Grin is declared illegal**|Monitor local laws in applicable countries|Possibly deploy some funds to help people out if applicable|
|**Losing control of Github repo**|Don't be stupid|Create another repo, move all other resources to it|
|**ASIC announcements**| ASICs are to be expected, and welcomed if publicly available. | Stealth ASICs justify either a graph size upgrade, or if that doesn't work, a Monero style tweak.|
|**Threats of 51% attack**|Ensure a healthy mining ecosystem|Hard fork PoW if necessary, otherwise do nothing|
|**Actual 51% attack**|Ensure a healthy mining ecosystem|Hard fork PoW if helpful, otherwise do nothing|
|**Rapid fund appreciation**|Keep in mind that in our space 10x can get reverted in a day, be pragmatic, don't hoard|Distribute|

# hashmap's 2 cents

|| Mitigation plan:<br>Reducing risk _before_ the event occurs| Response plan:<br>Actions to take _after_ the event has occurred|
|---|---|---|
|**Igno disappears**|Make sure that we have at least 2 admins in each service project uses. Build a shared within the team Igno True Vision | We can learn a lot from Bitcoin project history, they do well without  Satoshi who `was a master programmer whose knowledge of C++ was surpassed only by his knowledge of Japanese culture`
|**Critical bug/attack that leaks privacy**|Run multiple nodes with different version of Grin and some popular third-party services (wallets, exchanges if possible) and monitor it closely. Perhaps even build a small ops team for that. Have a clear bug disclosure policy, which is easy to find, with contact data/pgp etc. Run bounty program. Do rigorous code review|Quickly build a response team|
|**Critical bug/attack that leaks inflation**|same||
|**Critical bug/attack that compromises wallet funds**|same||
|**Exchange is hacked**|Try to collaborate with major players|Consult|
|**Criminal users lead to PR disaster**||Mention that USD, EUR etc are widely used for criminal activities for ages|
|**Developers are raided / harassed / prosecuted**|Figure out how to find out this fact for anonymous devs||
|**Accidental fork**|Same as with bugs, we could monitor for forks||
