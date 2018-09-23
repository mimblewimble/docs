**Notes:**

_About the author_ - My background in Risk Management comes from working in the finance industry, where I was the senior manager of the RM department, for a small/medium non-US based firm. My experience is all in high level Financial RM and I have no experience dealing with IT Risk Management. The objective of my department was always to maximize shareholder value. Following I will try to focus on laying out the process behind Risk Management and tailoring these, as best I can, to Grin's particular situation.   

_ISO31000_ - From time to time I may refer to this document out of convenience and not because it is definitive. While the ISO31000 has some good definitions, it is designed for corporations, and is poor on specifics and riddled with omissions, thus I will deviate significantly from its guidelines here.   

----

### Contents

- [Intro to Risk Management (RM)](#intro-to-risk-management--rm-)
  * [What is Risk?](#what-is-risk-)
  * [What is Risk Management?](#what-is-risk-management-)
- [RM Phases](#rm-phases)
  * [1. Planning](#1-planning)
  * [2. Identification](#2-identification)
  * [3. Analysis](#3-analysis)
  * [4. Review](#4-review)

----

# Intro to Risk Management (RM)

## What is Risk?
### ISO 31000 definition
_"The effect of uncertainty on objectives."_ it goes on to state that _"an effect may be positive, negative or a deviation from the expected, and that risk is often described by an event, a change in circumstances or a consequence. "_

### Note:
1. Risks are any event the have an uncertain (not guaranteed) effect on objectives. 
2. Risks can be both good or bad.
3. This means that to build a RM system, for a project/organization **the first step is to define the objectives of the project/organization**.

_Author's note: The objective I have the most experience with is return on investment_ 

## What is Risk Management?
The ongoing process of designing and managing systems to deal with risks. As risks change constantly I recommend that the full RM process be completed at least once per period (month/quarter depending on the organization).
 
### What are the RM phases?
The process of RM can broadly be broken down into four phases:
1. Planning
2. Identification
3. Analysis 
4. Review
...each of which can be further broken down into steps, defined in Step 1 (Planning).

### A good RM system should be:
* Systemic
* Integrated into decision making
* Responsive
* Adaptive
* Measurable  

# RM Phases
Following is a detailed description of each phase of the RM process.

## 1. Planning 

During this phase each step within the Identifying, Analyzing, and Reviewing phases should be defined. If the RM system failed during the previous period then these steps must be reassessed.  

### Must-haves in this phase
* **Define Objectives.** Done in order to determine what constitutes a risk. If there are no objectives, then nothing is at risk. 
* **Determine Risk Tolerance.** It's impossible to plan for every event, and even harder to eliminate risk, thus it is key to determine the probability, or value `(probability * impact)` of the events that the project is willing to accept (i.e. not take action to address). 
* **Define the Phases.** Clearly define the next three phases of the RM system so that they are systemic, clear, and transparent. 
* **Define Yardstick.** Determine how the success or failure of the RM system will be measured. 

### Defining Grin's Objectives
This should be done by the community, and this author can not provide an answer here. I will lay out the rest of the RM system as best I can but everything must be readdressed once the objectives have been clearly defined. If the objectives change over time this must be addressed throughout the RM system. 

### Determining Grins Risk Tolerance
Typically within my work this number is determined based on the internal rate of return (IRR) of the firm derived from other projects; meaning that the `sumproduct(ARP,ARC) < RAR-IRR`

Where `ARP` = Probability of an Accepted Risk occurring. `ARC` = the Cost associated with an Accepted Risk. `RAR` = the Risk Adjusted Return of the project. `IRR` = the Internal Rate of Return or the risk adjusted return on another project (typically the firms primary or fallback investment or the cost of capital itself).   

Since Grin is making something out of nothing and there is no way to easily identify an IRR to compare to and the RAR is simply the value of Grin thus I recommend that **the value of all acceptable risks should never be more than 100% the value of Grin**. 

Obviously this assumes that we assign an objective value to each risk, it is possible to build a system for measuring these but this must be based on Grins objectives.   

### Defining Phases
This is what I am doing now, we need to clearly define each phase and each step within each phase. Once we determine Grins objectives we should re-address this. 

### Determining Yardstick
The yardstick is what you use to determine if the RM system is adding value/working. Typically this is done by comparing the asset or portfolio to other similar assets or portfolios without the same RM system. I suppose Grin could be compared to other cryptocurrencies, but I don't think that price would make a good yardstick here. This should be discussed further. 

## 2. Identification
_Author's note: There is a lot of variation in methodology here, but I will pull upon best practices in enterprise and financial RM to make my recommendations here._

There are two Steps to this Phase which must be done for each risk:
1. Identify
2. Define

### Identifying Risks
First of all it's important to note that there are two types of risks:
* **Threats** - risks that have a potentially negative effect on objectives
* **Opportunities** - risks that have a potentially positive effect on objectives 

There are many ways to identify both types of risks, however they can all be broken down into 3 general categories (forward looking, backwards looking, and present focused). It is best practice to do at least one task that focuses on each of these categories. I recommend we use the following tasks:

* **Assumptions analysis.** Present focused, where all the assumptions that go into identifying risks are written out and defined.
* **Brain Storming.** Forward looking, where a large group of people come up with risks and determine their impact and probability. 
* **Checklist.** Backwards looking, where a checklist is created based on past experiences as well as the experiences of others.

### Defining Risks
Risks need to be defined by their:
1. Sources
    - Where do they come from (internal, external, positional, etc)
    - How likely are they to occur
2. Outputs
    - Are they positive (opportunities) or negative (threats)
    - What is the impact they will have if not addressed?

### How Grin should identify risks 
[See Risk Identification Page](https://github.com/mimblewimble/docs/wiki/Risk-Identification)


## 3. Analysis 

### For each Threat:
1. **Prioritize.** Modify the risk's value by its urgency and complexity and then address the most important risks first.
2. **Minimize.** See if there is a no cost way to minimize the negative impact.
3. **Monitor.** Determine how to monitor the risk.
4. **Control.** Decide whether and how to address the threat.

### For each Opportunity: 
1. **Prioritize.** Modify the risk's value by its urgency and complexity and then address the most important risks first.
2. **Maximize.** See if there is a no cost way to increase the probability of a beneficial effect.
3. **Control.** Decide whether and how to address the Opportunity.
 
### Control
If you must control the risk, then a cost benefit analysis should be done, for each of the following:

#### Threats:
1. Avoid - Eliminate the chance of occurrence 
2. Mitigate - Reduce impact or probability of occurrence
3. Transfer - Pass the risk on to a third party
4. Accept - Create a contingency plan

#### Opportunities:
1. Enhance - Turn the Opportunity into a certainty 
2. Exploit - Increase gain from the Opportunity
3. Share - Pass the benefits on to a third party better positioned to realize them 
4. Accept - Create a contingency plan

#### These processes should be designed to do the following: 
1. Minimize negative impact 
2. Maximize ability to realize opportunities
3. Minimize unexpected outcomes

## 4. Review
TBD