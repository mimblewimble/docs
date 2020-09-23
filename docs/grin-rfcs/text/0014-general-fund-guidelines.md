
- Title: `general-fund-guidelines`
- Authors: [Yeastplume](mailto:yeastplume@protonmail.org)
- Start date: Feb 07, 2020
- RFC PR: Edit if merged: [mimblewimble/grin-rfcs#41](https://github.com/mimblewimble/grin-rfcs/pull/41)
- Tracking issue: `N/A`

---

# Summary
[summary]: #summary

This RFC establishes a set of guidelines for spending the Grin Development Fund, the procedure via which funding requests can be made, and a set of procedures for managing and reporting on the fund.

# Motivation
[motivation]: #motivation

Previously there were no clear guidelines on how the Grin Development Fund could be spent and what types of activities could and could not be financed from the fund. This RFC presents a set of non-exhaustive guidelines intended to ensure that:

* Donators have a clear understanding of how their donations are likely to be spent.
* Those with funding ideas have a clear reference point to understand what types of proposals are likely to be considered for funding.
* Those with funding ideas have a specific process through which they can apply for funding.
* The team making spending decisions has clear, community-established guidelines against which to consider new funding requests.
* The decision-making process through which funding requests are granted is as fair, consistent and transparent as it can reasonably be.
* The wider community understands how the fund is managed and that transparency is evident.

Note that this document does not establish hard-and-fast rules for how the fund's contents can be spent. It is meant to be an indicative focal point for the community, and is intended to evolve with the needs of the project.

# Community-level explanation
[community-level-explanation]: #community-level-explanation

## Appropriate and inappropriate uses of the Grin Development Fund

Although spending decisions will always be made on a case-by-case basis, it is understood that the Grin Development Fund is to be used mainly to finance the development needs of the Grin project and the advancement of Grin/Mimblewimble as a whole. 

There is scope for interpretation as to what this actually means, but the following presents (non-exhaustive) guidelines as to the types of activities that would be considered appropriate to finance from the fund.

* Activities related to the continuing development needs of the Grin code-base and related projects under the GitHub [mimblewimble](github.com/mimblewimble) organization. This can include:
   * Fixed-term development or project-management contracts
   * Infrastructure and other incidental costs
   * Security audit costs
   * Costs incurred for any legal matters that may arise for either the project or individual contributors arising directly from their work in good faith on the Grin project
* Running budgets for Grin teams (with funds spent at their own discretion)
* Technological research in areas that may be relevant to Grin in the future
* Cryptographic research related to Grin or Mimblewimble in general
* Fully open-sourced community-based projects that enhance the Grin ecosystem
* Supporting non-profit, community-driven and inclusive promotional efforts for the Grin Project (e.g. Grincon) 
* Charitable donations toward important causes relevant to the Grin or cryptocurrency communities as a whole

While the guidelines above give plenty of flexibility in how funds can be employed toward the advancement of the Grin project, certain types of funding requests will not be considered:

* Marketing or promotional 'offers' where a party is taking a profit or gains some financial benefit to promote Grin (regardless of how the 'opportunity' is presented)
* Cryptocurrency speculation or any kind of investment

## Request for Funding Process

All requests for funding should be made in the [Governance Section](https://forum.grin.mw/c/governance) of the Grin forum. Topics should be clearly titled "Request for Funding: " followed by a short description of the request.

There is no set template for what the contents of the funding request should include, however a better reception can be attained by including:

* The exact amount requested, what the funding covers and for what time period (if applicable)
* A clear description of what will be provided to the Grin project in return, including:
    * Details of any work or research that will be performed during the period
    * The expected deliverable, if applicable (for a research project, for instance)
* Background information on the person making the request

Amounts should be stated using fiat currency equivalents with the exact Cryptocurrency amount determined by the rate at the time of transfer. To assist others with conceptualizing the amounts, fiat currencies used should be reasonably global, e.g. USD, EUR, CNY, GBP.

All community discussion on the funding request should be made within the forum thread itself, and the final decision on the request will be made by members of the core team at a [public governance meeting](https://github.com/mimblewimble/grin-pm/issues?q=is%3Aissue+label%3Agovernance+label%3Ameetings+), to take place at least one week after the request is made. The community is encouraged to display their support (or lack thereof) of a funding request at these Governance meetings, however the decision rests with the core team.

It should also be noted that decisions should never be considered final. Those making funding requests are encouraged to revise or refine proposals based on whatever feedback is given during the request process and submit them for consideration again.

## Decision Process

While everyone and anyone is encouraged to create a funding request, those making requests should understand that not all funding decisions will be approved simply on the basis of them conforming to the guidelines above. Many other factors will be considered for each request, including (but not limited to):

* How well known in the community is the person making the funding request?
* Have too many similar requests been funded recently?
* How tangible is the value proposition to Grin?
* How much risk is involved relative to the size of the ask and the potential return.
* Does a prioritization call need to be made due to a limited balance in the General Fund?

Everyone is welcome to weigh in on the merits of a funding request in the forum thread and during the public governance meeting where the funding request is finalized. The core team will strive to ensure there's a community consensus for each request, however the final decision rests with the core team. Other Grin teams who have been allocated budgets can spend funds at their own discretion, but are strongly encouraged to consider the guidelines in this RFC during their decision making process.

## Tips on effective proposals

* You proposal is likely to be better received if you're already known to the Grin community or the wider cryptocurrency community. Even more so if you've already contributed to Grin in some meaningful way.
* It might be better to keep your initial funding request small and focused, particularly if your idea is something new and radical, or if you're unknown to the Grin community.
* Be specific, professional and thorough with your proposal.
* Be respectful and professional in your response to any feedback and criticism on the proposal thread 

## Payout Process

* At the time of payout, the approved funding amount is converted to the equivalent in cryptocurrency and paid out to an address provided by the funding requestor only.
* The payout address should be provided to the core team by the requestor via a secure, verifiable channel (with cryptographic proof of identity if deemed necessary).
* Any conversion rate between the currency of the funding request and the currency that is paid out from the general fund is determined by the prevailing exchange rate at the time of the funding transaction, without exception.
* To minimize the effects of currency fluctuations on accounting transparency, all payments should be performed at pre-arranged "signing parties" in which mu-sig holders sample the current exchange rate. The transaction should be created, signed and broadcast as quickly as possible, with the transaction and rate reported back to the core team for tracking.
* Mu-sig holders will verify the address provided by the funding requestor several times during transaction creation and broadcasting. However, the core team is not responsible for errors or incorrect addresses provided by the requestor.

## Reporting

The result of all funding decisions will be published in the meeting notes found in the [Grin Project Management](https://github.com/mimblewimble/grin-pm) repository.

The core team is obliged to publish a detailed spending log of all transactions made in and out of the fund, as well as quarterly transparency reports summarizing all income and spending. This and other financial reporting can be found in the [/grin-pm](https://github.com/mimblewimble/grin-pm) repository.

# Unresolved questions

* This RFC is put together on the understanding that the fundamental question of 'who appoints the core team' is still outstanding. This point should be discussed separately and this RFC assumes there is an acceptable answer in place.

# Future possibilities

Ideas to further improve the funding process include creating a community funding website, where proposals can be made and vetted by the community, and support for particular ideas can be shown. Contributions towards funding could be made by community individuals and be matched with contributions from the general fund.

# References
* https://grin.mw/fund
* https://github.com/mimblewimble/grin-pm/ 