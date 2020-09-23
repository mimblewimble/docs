
- Title: security-team
- Authors: [joltz](mailto:joltz@protonmail.com)
- Start date: Jan 22 2020
- RFC PR: [mimblewimble/grin-rfcs#39](https://github.com/mimblewimble/grin-rfcs/pull/39)
- Tracking issue: [mimblewimble/grin-pm/#258](https://github.com/mimblewimble/grin-pm/issues/258)

---

# Summary
[summary]: #summary

The security team for Grin carries out the security priorities of the Grin community and core team, which are to be defined prior to formation of the team. The security team streamlines the security decision making process for the core team while maintaining a careful balance of security and transparency for the community.

# Motivation
[motivation]: #motivation

* Improve transparency, efficiency, decisiveness and scalability around security-related decision making
* Dedicated support for security-related initiatives such as bilateral disclosure agreements, bug bounty programs and audit work
* Increase confidence in the ecosystem for future contributions

A clear and structured decision making process is needed to fully support the current security process as well as community initiatives such as bilateral disclosure agreements, bug bounty programs and future audit work. This process was previously maintained by the core team who had many areas of focus, leading to a lack of clarity, timeliness and ability to decisively execute on community security initiatives.

The security team frees up core resources to focus on other important areas while expanding dedicated resources to security work, allowing the Grin ecosystem to continue to scale. A clear decision making structure around the security process instills confidence in the greater ecosystem and encourages projects, developers and users to continue to increase contributions of time and resources into Grin.

# Community-level explanation
[community-level-explanation]: #community-level-explanation

Grin's security team is responsible for making predefined security related decisions for the Grin project. This includes, but is not limited to, decisions about the specification and implementation of Grin's security processes. As much as possible Grin's security team carries out the security priorities of the community and core team in a transparent manner.

There may be some unique security-related cases that require the security team to make some decisions in private to protect the security of Grin users. In these cases, once it is safe to do so, the security team is responsible for sharing as many details as possible with the community for transparency and accountability purposes.

The primary day-to-day impact this will have on the community is making available structured support around security-related initiatives such as bilateral disclosure agreements, bug bounty programs and audit work. The community and other teams will have regular opportunity to interact with, provide input to and receive input from the security team.

## Example

Here we will walk through an example case that highlights how Grin's security team would operate, contrasting with the current process.

_In the example case, a vulnerability is disclosed to the disclosure contacts listed in Grin's security policy. It is shown that the community gains greater transparency into the decision making process and related outcomes with the proposed security team. Additionally the disclosure map is more tightly contained in the proposed process, resulting in less risk of vulnerability exploitation to the community._

### Previous Process

* Grin's security contacts make initial assessment of the validity of the vulnerability disclosure
* If disclosure determined to be valid, all details of the disclosure are shared with the entire core team
* With a conversation between the entire core team, a plan of action is determined and executed, following Grin's responsible disclosure policy
* Once the vulnerability is mitigated the core team may optionally share some of the details with the community

### Security Team Process
* Grin's security contacts, all members of the security team, make initial assessment of the validity of the vulnerability disclosure
* If disclosure determined to be valid, a conversation and plan of action is determined and executed by the security team, following Grin's responsible disclosure policy
* Once the vulnerability is mitigated the security team must disclose all information that is not still security-critical with the community

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

Grin's security team will be implemented as stated below.

## Membership

* Bootstrapped by existing security contacts (@lehnberg, @hashmap, @joltz)
* Minimum three, maximum five members
* Membership is recommended by the security team and approved by the core team
* All members must have relevant domain expertise in security, cryptography, the Grin codebase or Grin community
* All members must have high competency in maintaining personal operational security (keeping private keys secure, maintaining secure communications channels etc.)
* Membership is revoked by failure to update the canary, unanimous decision by team or decision from the core team
  * Note if the core team engages in removing members from the security team without reasonable justification, the security team loses purpose, becomes ineffective and is relegated to useless security theater

## Decision Making

* Distinction between _security-team decisions_ and _security-related decisions_:
  * The security team is responsible for making predefined security-team decisions, not all possible ambiguous security-related decisions
* Decisions are made primarily with consideration to the security priorities outlined prior to the team's formation
* Unanimous approval of security team members is needed to make all impactful decisions
* Some decisions made must also be approved by the core team to be carried out:
  * Adding/removing parties from disclosure agreements
  * Adding members to the security team
  * Updating the security policy
  * In the event that the core team does not follow a security team recommendation, a reasonable explanation must be provided as to why the security recommendation was not followed
* Some decisions must be made without fully informing the core team of all details:
  * When fixing a vulnerability requires a [deviation from the standard](https://github.com/mimblewimble/grin/blob/master/SECURITY.md#deviations-from-the-standard)
    * In these cases not all information will be shared with core team, such as specific details to carry out an exploit, full impact and other relevant information that will create unnecessary risk if disclosed
  * The core team must be notified of all cases of these decisions within a reasonable time frame that does not pose a security risk (e.g. after a fix is implemented) and provided with a reasonable explanation by the security team

### Vetoes

* Any member of the security team may veto an impactful security team decision

The ability to veto an impactful security team decision is important to preserve the ability for members of the security team to make honest recommendations. Important and controversial decisions will be made and members of the security team need the ability to not sign their names to a decision they are not comfortable with that could have serious ramifications. These cases will be handled according to the Deadlocks section below.

The security team should always strive to reach its own decisions. Constant vetoes and inability to reach unanimous decisions will dampen the advantages of the existence of the team and may render it obsolete. It is important to strike the right balance of different perspectives, expertise and reasonability in members to take advantage of the benefits that come with a diverse and functional security-related decision making process.

### Deadlocks

* Impactful security team decisions that can't be made unanimously by the security team will be made by the core team according to their decision making process
  * If the core team is deadlocked, the decision made will be whichever decision, if any, will provide the end user with the greatest measure of security

Deadlocks should be avoided at all costs. The inability of the security team to reach a unanimous decision based on the security priorities of Grin's community and core team should be a red flag to the community and core team for the health of the team. All members should be able to clearly discuss the factual merits of the options and reach a decision that is in the clear best possible interest for the security of Grin's ecosystem and users.

## Example

_By following the previous example in more detail, critical differences can be further explored between the current process and the proposed security team process in the handling of a unique case._

_In cases where fixing a vulnerability is so critical that it requires a [deviation from the standard](https://github.com/mimblewimble/grin/blob/master/SECURITY.md#deviations-from-the-standard), the proposed process reduces the likelihood of the vulnerability being exploited with a focused decision making process and by restricting the details to essential persons only._

### Previous Process

* Grin's security contacts make initial assessment of the validity of the vulnerability disclosure
* It is determined that the disclosed vulnerability is a critical inflation bug
* _All details of the disclosure, including the steps to carry out the exploit, are shared with the entire core team_
* With a conversation between the entire core team, a plan of action is determined and executed, following Grin's responsible disclosure policy
  * _This conversation may take days or weeks as there is no particular decision making process for security-related issues_
* _Once the vulnerability is mitigated the core team may optionally share some of the details with the community_

### Security Team Process

* Grin's security contacts, all members of the security team, make initial assessment of the validity of the vulnerability disclosure
* It is determined that the disclosed vulnerability is a critical inflation bug
* _A conversation and plan of action is quickly and unanimously determined and executed on by the security team, following Grin's responsible disclosure policy_
* _Once the vulnerability is mitigated, the security team must disclose all information that is not still security-critical with the community_

# Drawbacks
[drawbacks]: #drawbacks

* The core team is already busy and the formation and management of a security team may distract from other pressing and immediate issues
* Even though it decentralizes the core team, it potentially creates another point of centralization
* Adds resource overhead to the project that _must_ be upheld (it is not acceptable to fail to follow through in security processes once established!)
* Possibly distracts from other important work- we don't want to spread attention too wide too early
* Adds bulk to Grin's governance structure
* The community may trust core more than a team to make critical security decisions

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

* One alternative, currently in use, is adding the input of a security expert to the existing core decision making process
  * This is better than nothing but we lose a few benefits without a dedicated security team:
    * Strengthened security process: reduced likelihood of exploit leaks
    * Improved transparency: there is currently little transparency around core's security decision making process
    * Improved reaction times: informed, thoughtful, decisive actions with input from relevant experts only
    * Possibility for security initiatives: clear decision making process for bilateral disclosure agreements, bug bounty programs, audit work
    * Stronger commitments to the community, ecosystem and other projects: viable with a dedicated, clear decision making process
    * Long-term scalability: extend capacity for security work to grow beyond the core team's attention capacity
* Another alternative is to rely on an open community to handle all incidents as they come in
  * This is less desirable than both the previous process and security team process:
    * Vulnerabilities would essentially be public before they can by mitigated
    * There is no decision making team so mitigation actions may be slow and contentious
    * There is no accountability to ensure that the responsible disclosure process is followed
    * This model is much more transparent than other alternatives but comes with the unacceptable associated costs above

# Prior art
[prior-art]: #prior-art

grin-governance[0] and security-process[1] RFCs lay groundwork for the security-team RFC.

# Unresolved questions
[unresolved-questions]: #unresolved-questions

- What are the security priorities of the Grin community and core team? (e.g. is privacy a higher priority than undetectable inflation?)
- Is this the most minimal model that can have long-term success for Grin's security-related decision making process?
- Is the single-veto model sufficient for a consistent, timely decision making process?

# Future possibilities
[future-possibilities]: #future-possibilities

* Budget allocation and management
  * Manage an allocated budget for possible initiatives
    * Bug bounty programs
    * Audits
    * Full time contributors
    * Development of security tooling

* Security team working groups
  * Red team
  * Blue team
  * Audit team
  * Bug bounty team
  * Community outreach team

* Expanding security-team decisions
  * Currently security-team decisions are restricted to predefined decisions around the security processes
  * In the future security-team decisions can be expanded to include more security-related decisions

# References
[references]: #references

[0] https://github.com/mimblewimble/grin-rfcs/blob/master/text/0002-grin-governance.md#teams

[1] https://github.com/mimblewimble/grin-rfcs/blob/master/text/0003-security-process.md
