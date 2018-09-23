_Author's note: This is a follow up to [the separate document on Risk Management](https://github.com/mimblewimble/docs/wiki/Risky-Man's-RM-for-Grin)._

----


## Assumption Analysis

## Brain Storming

I propose that we use a standard 1-9 system for for risk identification and calculation (1 being low, and 9 being high). With where everyone on the Grin council gets to vote on the following three things:
1. How much they know about the scope of the risk?
2. If unaddressed how likely is the risk to occur? (Risk Chance)
3. If unaddressed how big is the impact of the risk?(Risk Impact)

For example, in a traditional organization, imagine that the risk of the firm's database suffers a catastrophic failure is being analysed. The CIO might answer 9, 2, 8 to the questions above, while the CFO might answer 2, 5, 3. The answers to questions 2 & 3 are therefore multiplied by the answer to question 1, to achieve a weighting based on each respondent's knowledge of the scope. In the above example, you would end up with the following results:

<table>
    <thead>
        <tr>
            <th></th>
            <th colspan=5>Risk of Database Failure</th>
        </tr>
        <tr>
            <th></th>
            <th>Knowledge</th>
            <th>Chance</th>
            <th>Weighted chance</th>
            <th>Threat</th>
            <th>Weighted Threat</th>
        </tr>
    </thead>
    <tbody>
        <tr>
          <td>CIO</td>
          <td>9</td>
          <td>2</td>
          <td>18</td>
          <td>8</td>
          <td>72</td>
        </tr>
        <tr>
          <td>CFO</td>
          <td>2</td>
          <td>5</td>
          <td>10</td>
          <td>3</td>
          <td>6</td>
        </tr>
        <tr>
          <td>Total</td>
          <td>11</td>
          <td>7</td>
          <td>28</td>
          <td>11</td>
          <td>78</td>
        </tr>
        <tr>
            <td rowspan=2><b>Weighted totals</b></td>
            <td><b>Max risk<b/></td>
            <td colspan=2><b>Weighted chance</b></td>
            <td colspan=2><b>Weighted Threat</b></td>
        </tr>
        <tr>
            <td>99</td>
            <td colspan=2>28%</td>
            <td colspan=2>78%</td>
        </tr>
    </tbody>
</table>

A system for assigning these knowledge weights would need to be determined. Typically they can be self assessed and should be defended if questioned. Whether this would work in an open source project where participant are not under the same pressures to behave professionally and answer truthfully, remains to be determined.

In addition to doing this in-house risk identification, I propose that a webpage is created where anyone in the community can submit a risk and vote on the Chance and Impact of it. In order to keep votes constant they should last a finite amount of time (such as 1 year). The portal could be used to identify new and unseen risks, and outsource a considerable amount of the brainstorming. If the core team's opinion on risk differs significantly from the community's then the core team should provide a written explanation of their reasoning. 

## Checklists

TBD.