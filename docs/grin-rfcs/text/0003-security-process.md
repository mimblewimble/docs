
- Title: security-process
- Authors: [John Woeltz](mailto:joltz@protonmail.com)
- Start date : July 18, 2019
- RFC PR: [mimblewimble/grin-rfcs#13](https://github.com/mimblewimble/grin-rfcs/pull/13)
- Tracking issue: [mimblewimble/grin-pm#178](https://github.com/mimblewimble/grin-pm/issues/178)

---

# Summary
[summary]: #summary

This RFC improves the security processes for Grin by adopting a community
standard for a public pre-commitment scheme for vulnerability sharing agreements.
The standard proposed for adoption describes the norms for ethical disclosure
behavior and provides a public pre-commitment scheme for the Grin community to
clarify security process actions and expectations [2].

# Motivation
[motivation]: #motivation

- Improves transparency around Grin security and disclosure processes
- Decreases reaction time for mitigating security incidents across the Grin ecosystem
- Increases preparedness in the event of an extreme vulnerability
- Improves overall ecosystem resiliency
- Provides clarity around ethical behavior and expected deviations
- Makes possible the mapping of the vulnerability disclosure surface

# Community-level explanation
[community-level-explanation]: #community-level-explanation

This RFC proposes adopting a
[vulnerability disclosure standard](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#the-standard)
for Grin that provides
more guidance and clears up some unanswered questions from Grin's
[current security process](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#grins-security-process).
The community should think of this improvement as an extension
to the existing security process with the following changes:

- Better define
[ethical behavior](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#ethical-behavior)
(and deviations) for vulnerability disclosure
- Better define the
[processes and expectations](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#standard-disclosure-timelines)
for receiving and sending disclosures
- Provide a framework for
[bi-lateral disclosure agreements](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#publicly-committing-to-disclosure-relationships)
with other projects/implementations
- A [public commitment](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#publicly-committing-to-disclosure-process)
to the above

This all results in a more robust security process for Grin that is transparent
from the beginning to the community, vulnerability researchers, the core team
and other neighboring projects that share threads in the same security blanket.

An example of another project adopting the same standard can be found
[here](https://github.com/zcash/zcash/blob/master/responsible_disclosure.md)
in Zcash's vulnerability disclosure document.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

- This RFC proposes to adopt a community responsible disclosure standard for Grin: https://github.com/RD-Crypto-Spec/Responsible-Disclosure

- Here we will describe the specific changes that would be made to
[SECURITY.md](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md) if the RFC is adopted.

- Many of the changes proposed are modeled from
[Zcash's security disclosure policy](https://github.com/zcash/zcash/blob/master/responsible_disclosure.md#security-disclosures)
which adopts the same standard proposed here for Grin.

_All links to the standard in the actual implementation of SECURITY.md must be
permanent._

## Changes to [SECURITY.md](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md)

- The original
[Recognition and Bug Bounties](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#recognition-and-bug-bounties)
section will be updated:
    - Include a link to the
    [Acknowledgements](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#acknowledgements)
    section of the standard
    - Include a link to the
[Bounty Payments](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#bounty-payments)
section of the standard
    - Keep existing language such as:
    >As of this writing, Grin is a traditional open source project with limited to
    no direct funding. As such, we have little means with which to compensate
    security researchers for their contributions.

    - Remove unnecessary or old language such as:
    >It is our hope that after mainnet release...

    - Include a note that there is not currently a formal bug bounty program
    but that more donations can help provide the resources to run one in the
    future. Include a donation link here.

- The original
[Code Reviews and Audits](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#code-reviews-and-audits)
section will be moved to a not yet determined page on the
[wiki](https://github.com/mimblewimble/docs/wiki).

- The original
[Chain Splits](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#chain-splits)
section will move to a not yet determined
[Github issue](https://github.com/mimblewimble/grin/issues)
in the main repository.

_**The following sections will be added to
[SECURITY.md](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md) and may replace existing sections as noted below.**_

### Responsible Disclosure Standard

_This section will replace the
[original vulnerability handling section](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#vulnerability-handling)_

>Grin follows a
[community standard for responsible disclosure](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#the-standard)
in cryptocurrency and related software.

>This document is a public commitment to following the standard. Any expected
deviations are explained in the following sections.

>The standard provides detailed information for:
- [Initial Contact](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#initial-contact):
how the initial contact process works
- [Giving Details](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#giving-details):
what details to include with your disclosure after receiving a response to your
initial contact
- [Setting Dates](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#setting-dates):
details for when to release updates and publicize details of the issue

### Receiving Disclosures

_This section will replace the
will replace the
[original responsible disclosure section](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#responsible-disclosure)._

>Grin is committed to working with researchers who submit security vulnerability
notifications to us to resolve those issues on an appropriate timeline and perform
a coordinated release, giving credit to the reporter if they would like.

>Please submit issues to all of the following main points of contact for
security related issues according to the
[initial contact](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#initial-contact)
and [details](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#giving-details)
guidelines. More information is available about the
[expected timelines for the full disclosure cycle](https://github.com/RD-Crypto-Spec/Responsible-Disclosure#standard-disclosure-timelines).

Emails and PGP keys for Grin's security contacts will be listed here as in the
existing
[Responsible Disclosure](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#responsible-disclosure)
and
[Public Key](https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md#public-keys)
sections.




### Sending Disclosures

>In the case where we become aware of security issues affecting other projects
that has never affected Grin, our intention is to inform those projects of
security issues on a best effort basis.

>In the case where we fix a security issue in Grin that also affects the following
neighboring projects, our intention is to engage in responsible disclosures with
them as described in https://github.com/RD-Crypto-Spec/Responsible-Disclosure,
subject to the deviations described in the 'Deviations from the Standard' section.

### Bilateral Responsible Disclosure Agreements

Here we would list any agreements we have with neighboring projects to share
vulnerability information in accordance with the standard itself and the
'Deviations from the Standard' section in the adoption of the standard.
Agreements would be made by the core team or security team based on capacity
to engage and relevance/impact on Grin's ecosystem and to an extent the greater
cryptocurrency ecosystem.

### Deviations from the Standard

>Grin is a technology that provides strong privacy with zero-knowledge
commitments and rangeproofs. Due to the nature of the cryptography used, if a
counterfeiting bug results it could be exploited without a way to identify
which data was corrupted. This renders rollbacks or other fork-based attempted
fixes ineffective.

>The standard describes reporters of vulnerabilities including full details of an
issue, in order to reproduce it. This is necessary for instance in the case of
an external researcher both demonstrating and proving that there really is a
security issue, and that security issue really has the impact that they say it
has - allowing the development team to accurately prioritize and resolve the issue.

>In the case of a counterfeiting or privacy-breaking bug, however, we might
decide not to include those details with our reports to partners ahead of
coordinated release, so long as we are sure that they are vulnerable.

### Canaries

For a privacy preserving project such as Grin, adversaries wishing to break that
privacy may have incentive to disrupt Grin's security processes. This could be
attempted via NSLs, FISA court orders, secret government subpoenas and rubber-hose
tactics. The purpose of a PGP signed canary by each disclosure contact on a
regular basis is to indicate that the disclosure contacts are not compelled
in any way to take any actions (or non-actions) to jeopardize the security of
Grin users. There are several examples of canaries in action, particularly in
privacy preserving projects [5][6][7].

If this section is adopted with the RFC, canaries for each security contact for
Grin vulnerability disclosures will be updated quarterly. Repos containing up to
date signatures will be linked in the SECURITY.md document. In the event a
security contact fails to keep their canary alive, they will be removed from the
list of contacts. The specific language of each canary can be up to each contact
unless a canary standard is adopted.

# Drawbacks
[drawbacks]: #drawbacks

This proposal could add complexity and overhead that a donation-supported decentralized
project may not be able to uphold in good faith. Adopting and pre-committing
to a standard and policy is not effective if it cannot be upheld through actions.
This is amplified with bilateral agreements that extend through chains of vendors
sharing code, many forks and multiple implementations with many operating publicly.

For a project with extremely limited resources (relative to large companies)
and no source of steady funding, it may not be possible to support the time and
resources required to follow through on such a commitment.

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

#### Why is this design the best in the space of possible designs?

This seems to be the most transparent and least centralized option that still
provides the ability to efficiently handle cases of severe vulnerabilities that
may be unique to Grin, while keeping with the minimalist philosophy.

Relying on a single security@ disclosure email address provides a single point
of failure. Additionally, not having clear pre-commitments to sharing agreements
and expected ethical deviations can cause community contention at best and
failure to successfully mitigate a vulnerability before it is exploited at worst.

#### What other designs have been considered and what is the rationale for not choosing them?

A less centralized model would be to attempt to guide this process with on-chain
governance or an on-chain bug bounty program. Both of those not only challenge
Grin's minimalist philosophy but are also extremely complicated to execute on.
These do not seem to be viable options for Grin at this time.

Ideally formal verification could be used to handle many of these security
challenges but there is a huge gap between what formal verification can actually
do and the complex blockchain related things we are doing today that we want
formally verified. This may be more viable in the future, but it would require
significant time and resource investment. It would not be responsible to rely
on formal verification for a project like Grin today.

#### What is the impact of not doing this?

If we do not adopt a standard as proposed here, the community is left with
unresolved problems:

- Who do we tell if we receive a vulnerability?
- What details are we obligated to share?
    - Exploit code?
    - What if it is an inflation bug?
- Do we attempt to collect a bug bounty?

The community is exposed to risk by not having clear answers to these questions
_before_ it is presented with a critical security vulnerability. Even if the
vulnerability has technically been fixed, there may be severe fallout in the
community if it perceives the situation wasn't handled ethically by the parties
involved in the disclosure. There is also risk of not implementing a fix in time
across the community because there were internal disputes about who to tell.

Without a public pre-commitment to expected actions taken during a vulnerability
disclosure, Grin runs the risk of alienating the community in pursuit of
security, or even worse, not implementing a critical fix before any user
experiences privacy or value loss.

# Prior art
[prior-art]: #prior-art

The traditional disclosure model (RF Policy/security@) [0] handles interaction between
researcher and vendor but does not quite fit for our use case of potentially multiple
vendors up/down stream. There have been multi-party models proposed with single
researcher and multiple vendors that have not been successful, nor do they
sufficiently account for the challenges faced in public decentralized projects.

Neither model fits with chains of vendors sharing code, protocols with multiple
implementations and forks, all operating in public. We need a model that is
better suited to handle cases of consensus critical vulnerabilities that require
upgrades across many implementations, forks and projects both in the Grin and
greater cryptocurrency ecosystems.

Bitcoin has received some criticism over handling of disclosures, as it never
had a robust, well-defined pre-committed standard to follow. We want to learn
from those lessons to avoid putting more people in the position to repeat the
same mistakes.

Zcash, a privacy based cryptocurrency, experienced a critical vulnerability
that inspired the creation of the standard this RFC proposes to adopt [1]. Due
to the similar nature of the Zcash and Grin ecosystems, this prior art is highly
relevant to the security process for Grin.

# Unresolved questions
[unresolved-questions]: #unresolved-questions

- How can we further reduce centralization risk for Grin's security process?
    - Disclosures are sent directly only to those listed in SECURITY.md.
    This poses a centralization risk for the community as there is no way to
    trustlessly publicly verify actions taken by individuals involved in a
    disclosure. While this RFC is a step in the right direction, it does not
    completely remove centralization risk for the disclosure process.

- How can we responsibly handle vulnerabilities in academic papers?
    - It is possible that a vulnerability may be found in an underlying primitive
    at the specification level that Grin relies on. In this case not only
    do we have potential vulnerabilities in all implementations, but also in
    the specification itself. Without addressing these properly some may
    continue to use academic papers with vulnerable specifications as a
    reference for new development.

- What role will formal verification play in Grin's future?

- What form, if any, will the Bug Bounty process take?

# Future possibilities
[future-possibilities]: #future-possibilities

- Security team
    - If a security team is adopted in the future it would likely maintain these processes
- On-chain governance/bug bounties
- Bug bounty program
- Formal verification

# References
[references]: #references

[0] https://dl.packetstormsecurity.net/papers/general/rfpolicy-2.0.txt

[1] https://www.youtube.com/watch?v=h7W1u1K2VjQ

[2] https://github.com/RD-Crypto-Spec/Responsible-Disclosure

[3] https://github.com/zcash/zcash/blob/master/responsible_disclosure.md

[4] https://github.com/mimblewimble/grin/blob/09cf6de1d143ffbe007478372dc573213e06804d/SECURITY.md

[5] https://github.com/QubesOS/qubes-secpack/blob/master/canaries/canary-020-2019.txt

[6] https://riseup.net/about-us/canary/canary-statement-signed.txt

[7] https://protonmail.com/blog/transparency-report/
