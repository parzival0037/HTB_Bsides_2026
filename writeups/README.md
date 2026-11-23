# Per-challenge write-ups

One document per solved card: what the vulnerability was, the tools used, and the full
path from recon to flag. Each file opens with an **At a glance** table so you can see the
bug class before reading the walkthrough.

## Two kinds of file

Most files are **reconstructions**: they explain the bug class and the technique, and where
the exact transcript was not captured they say so. A few are **verbatim**: written from the
commands actually run, with the output as it appeared, up to the accepted flag — these end
in `_actual`:

- [K19.1](K19.1_actual.md)
- [K19.2](K19.2_actual.md)
- [K19.3](K19.3_actual.md)
- [T01.4](T01.4_actual.md)

Both are worth reading. The reconstruction teaches the pattern; the `_actual` file shows what
it looks like when a real response comes back — including the wrong turns and the one
mis-attributed submission in K19.3.

## 1. Training

| Card | Title | Pts | Diff | Bug class | Solved by |
|---|---|---|---|---|---|
| [T01.1](T01.1.md) | The copy nobody deleted | 50 | easy | — | team agent |
| [T01.2](T01.2.md) | Off the menu | 50 | easy | — | team agent |
| [T01.3](T01.3.md) | A token with a job | 50 | easy | — | team agent |
| [T01.4] ⭐(T01.4.md) | The helper has another job | 50 | easy | — | me (manual) |
| [T02.1](T02.1.md) | An account by any other response | 50 | easy | — | me (manual) |
| [T02.2](T02.2.md) | Hidden on the page | 50 | easy | — | me (manual) |
| [T02.3](T02.3.md) | Recovery is another way in | 50 | easy | — | me (manual) |
| [T02.4](T02.4.md) | Someone else's assignment | 100 | medium | — | me (manual) |
| [T03.1](T03.1.md) | Deleted from the checkout | 50 | easy | — | me (manual) |
| [T03.2](T03.2.md) | Verbose enough to publish | 50 | easy | — | team agent |
| [T03.3](T03.3.md) | What installation really runs | 50 | easy | — | me (manual) |
| [T03.4](T03.4.md) | A release they will consume | 100 | medium | — | me (manual) |
| [T04.1](T04.1.md) | Which value is real | 50 | easy | — | me (manual) |
| [T04.2](T04.2.md) | The light behind the number | 50 | easy | — | me (manual) |
| [T04.3](T04.3.md) | A request is not a movement | 100 | medium | — | me (manual) |
| [T04.4](T04.4.md) | Yesterday's green light | 100 | medium | — | me (manual) |

## 2. KeplerOps

| Card | Title | Pts | Diff | Bug class | Solved by |
|---|---|---|---|---|---|
| [K01.1](K01.1.md) | The developer left a way back | 50 | easy | — | team agent |
| [K01.2](K01.2.md) | The tab that survived | 50 | easy | — | team agent |
| [K01.3](K01.3.md) | Outside the working folder | 50 | easy | — | team agent |
| [K01.4](K01.4.md) | Put it on the workbench | 50 | easy | — | team agent |
| [K02.1](K02.1.md) | The missing fixture | 50 | easy | — | pi lane K02 |
| [K02.2](K02.2.md) | An input outside its lane | 50 | easy | — | pi lane K02 |
| [K02.3](K02.3.md) | Green, with our changes | 100 | medium | — | pi lane K09 |
| [K03.1](K03.1.md) | Our predecessor's desk | 100 | medium | — | team agent |
| [K03.2](K03.2.md) | The script inside the script | 200 | hard | — | team agent |
| [K03.3](K03.3.md) | Finish the callback | 200 | hard | — | team agent |
| [K04.1](K04.1.md) | A bundle with consequences | 200 | hard | — | team agent |
| [K04.2](K04.2.md) | Read past the index | 400 | expert | — | team agent |
| [K04.3](K04.3.md) | Control the allocation | 800 | expert | — | team agent |
| [K04.4](K04.4.md) | The exception queue | 800 | expert | — | team agent |
| [K05.1](K05.1.md) | Speak the package's language | 50 | easy | — | team agent |
| [K05.2](K05.2.md) | The version they kept | 50 | easy | — | team agent |
| [K06.1](K06.1.md) | House credentials | 100 | medium | — | team agent |
| [K06.2](K06.2.md) | A private package in the wrong view | 100 | medium | — | team agent |
| [K06.3](K06.3.md) | The rehearsal consumer | 100 | medium | — | team agent |
| [K07.3](K07.3.md) | The protected inspection | 400 | expert | — | team agent |
| [K08.1](K08.1.md) | The old entitlement | 100 | medium | — | team agent |
| [K09.1](K09.1.md) | A runner tells on itself | 50 | easy | — | team agent |
| [K09.2](K09.2.md) | The artifact without a link | 50 | easy | — | team agent |
| [K09.3](K09.3.md) | A job input with reach | 100 | medium | — | pi lane K09 |
| [K09.4](K09.4.md) | Run in the runner | 100 | medium | — | pi lane K09 |
| [K10.1](K10.1.md) | Whose preview is this | 100 | medium | — | me (manual) |
| [K10.2](K10.2.md) | Two inputs, one identity | 100 | medium | — | team agent |
| [K10.3](K10.3.md) | The other document's contents | 200 | hard | — | team agent |
| [K11.1](K11.1.md) | Where the policy begins | 100 | medium | — | team agent |
| [K11.3](K11.3.md) | The rule behind the rule | 200 | hard | — | team agent |
| [K12.1](K12.1.md) | The reviewer arrives second | 200 | hard | — | team agent |
| [K12.2](K12.2.md) | A value across the action boundary | 400 | expert | — | team agent |
| [K13.1](K13.1.md) | The listing nobody closed | 50 | easy | — | pi lane K13 |
| [K13.2](K13.2.md) | Before the correction | 50 | easy | — | pi lane K13 |
| [K13.3](K13.3.md) | The export next door | 50 | easy | — | pi lane K13 |
| [K13.4](K13.4.md) | What the workload can do | 100 | medium | — | pi lane K13 |
| [K14.1](K14.1.md) | The trust document | 50 | easy | — | pi lane K13 |
| [K14.2](K14.2.md) | Intended for someone else | 100 | medium | — | team agent |
| [K15.1](K15.1.md) | An export in progress | 50 | easy | — | pi lane K15 |
| [K15.2](K15.2.md) | A job outside your account | 100 | medium | — | pi lane K15 |
| [K16.1](K16.1.md) | Tomorrow's job | 50 | easy | — | team agent |
| [K16.2](K16.2.md) | The next startup | 100 | medium | — | team agent |
| [K17.1](K17.1.md) | A support session left behind | 50 | easy | — | pi lane K25 |
| [K17.2](K17.2.md) | A different way to recover | 100 | medium | — | team agent |
| [K17.3](K17.3.md) | Which customers belong here | 50 | easy | — | team agent |
| [K18.1](K18.1.md) | The note behind the preview | 100 | medium | — | team agent |
| [K19.1] ⭐(K19.1.md) | Who vouches for whom | 100 | medium | — | me (manual) |
| [K19.2] ⭐(K19.2.md) | Borrowed colleague | 200 | hard | — | me (manual) |
| [K19.3] ⭐(K19.3.md) | The archive delegates | 400 | expert | — | me (manual) |
| [K21.1](K21.1.md) | The policy beside the prompt | 50 | easy | — | pi lane K21 |
| [K21.2](K21.2.md) | A conversation kept too long | 50 | easy | — | pi lane K21 |
| [K21.3](K21.3.md) | The answer it should withhold | 100 | medium | — | pi lane K21 |
| [K23.1](K23.1.md) | A context view left open | 50 | easy | — | pi lane K23 |
| [K23.2](K23.2.md) | The conversation reference | 50 | easy | — | pi lane K23 |
| [K23.3](K23.3.md) | A missing tenant boundary | 100 | medium | — | pi lane K23 |
| [K24.1](K24.1.md) | Complete the job | 50 | easy | — | pi lane K23 |
| [K27.1](K27.1.md) | A job for that customer | 100 | medium | — | team agent |
| [K27.2](K27.2.md) | Our diagnostic, their interface | 100 | medium | — | team agent |
| [K27.3](K27.3.md) | The other side of support | 100 | medium | — | team agent |
| [K28.1](K28.1.md) | A connector with two faces | 100 | medium | — | team agent |
| [K29.1](K29.1.md) | The build record's principal | 100 | medium | — | team agent |
| [K29.2](K29.2.md) | The signer in the history | 200 | hard | — | team agent |
| [K29.4](K29.4.md) | After the old key expires | 400 | expert | — | me (manual) |
| [K31.1](K31.1.md) | Whose maintenance job | 100 | medium | — | team agent |

## 3. ARWC

| Card | Title | Pts | Diff | Bug class | Solved by |
|---|---|---|---|---|---|
| [W01.1](W01.1.md) | The customer's copy | 50 | easy | — | pi lane W01D |
| [W01.2](W01.2.md) | The planner's unfinished handover | 50 | easy | — | team agent |
| [W01.3](W01.3.md) | How the company buys time | 50 | easy | — | team agent |
| [W02.1](W02.1.md) | The asset and the contractor | 50 | easy | — | team agent |
| [W02.2](W02.2.md) | Three names for one job | 100 | medium | — | team agent |
| [W03.1](W03.1.md) | An annex left with the order | 50 | easy | — | pi lane W03B |
| [W03.3](W03.3.md) | The integration's read contract | 100 | medium | — | team agent |
| [W13.1](W13.1.md) | Window on Thursday | 50 | easy | — | team agent |
| [W14.1](W14.1.md) | The field bag | 50 | easy | — | team agent |
| [W19.1](W19.1.md) | The diagnostic nobody retired | 100 | medium | — | team agent |
| [W31.1](W31.1.md) | The vault's misleading length | 100 | medium | — | team agent |

