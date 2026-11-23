# Solved challenges — 92 / 240

Snapshot of the event API at end of run. `Solved by` separates the cards I closed by hand myself
from cards closed by my headless pi lanes (each lane is one agent working one chapter) and cards
closed by the other agent on the team
(those were submitted outside this session, so only the accept is known).

| # | Card | Title | Pts | Diff | Flag | Solved by | Evidence / technique |
|---|---|---|---|---|---|---|---|
| 1 | T01.1 | The copy nobody deleted | 50 | easy | — | team agent | — |
| 2 | T01.2 | Off the menu | 50 | easy | — | team agent | — |
| 3 | T01.3 | A token with a job | 50 | easy | — | team agent | — |
| 4 | T01.4 | The helper has another job | 50 | easy | `FLAG{3bf1d8651d39b64c}` | me (manual) | path traversal `8083 /api/diagnostics/render?view=public/../internal/DL-204.json` |
| 5 | T02.1 | An account by any other response | 50 | easy | `FLAG{7502f8e82360c288}` | pi lane T02 | `POST /api/recovery/lookup` `{"account":"rhea.moss"}` |
| 6 | T02.2 | Hidden on the page | 50 | easy | `FLAG{9e9612ddd489395c}` | pi lane T02 | `GET /api/directory/staff/STF-204/assignment` |
| 7 | T02.3 | Recovery is another way in | 50 | easy | `FLAG{0efa33511b93dccd}` | pi lane T02 | `POST /api/recovery/redeem` rhea.moss/CASE-7Q4M/Blue cabinet 17 |
| 8 | T02.4 | Someone else's assignment | 100 | medium | `FLAG{50676f831e62140a}` | pi lane T02 | IDOR `GET /api/assignments/ASG-317/brief` |
| 9 | T03.1 | Deleted from the checkout | 50 | easy | — | pi lane T03 | — |
| 10 | T03.2 | Verbose enough to publish | 50 | easy | — | pi lane T03 | — |
| 11 | T03.3 | What installation really runs | 50 | easy | — | pi lane T03 | — |
| 12 | T03.4 | A release they will consume | 100 | medium | — | pi lane T03 | — |
| 13 | T04.1 | Which value is real | 50 | easy | `FLAG{35b940a34aeaa0f0}` | pi lane T04 | VC-017 observed 1200.0 L, sealed record key sha256("1200.0:VC-017") |
| 14 | T04.2 | The light behind the number | 50 | easy | `FLAG{5cdc1c2fcc92fb42}` | pi lane T04 | SC-018 status 5 = ready+service_hold |
| 15 | T04.3 | A request is not a movement | 100 | medium | `FLAG{03993cc3de147e23}` | pi lane T04 | cleared hold, moved 200 L, terminal observation batch_reference |
| 16 | T04.4 | Yesterday's green light | 100 | medium | `FLAG{51b9f00459e54f0b}` | pi lane T04 | OR-042 green belonged to AT-041; RQ-042 rejected |
| 17 | K01.1 | The developer left a way back | 50 | easy | — | team agent | — |
| 18 | K01.2 | The tab that survived | 50 | easy | — | team agent | — |
| 19 | K01.3 | Outside the working folder | 50 | easy | — | team agent | — |
| 20 | K01.4 | Put it on the workbench | 50 | easy | — | team agent | — |
| 21 | K02.1 | The missing fixture | 50 | easy | — | pi lane K02 | — |
| 22 | K02.2 | An input outside its lane | 50 | easy | — | pi lane K02 | — |
| 23 | K02.3 | Green, with our changes | 100 | medium | — | pi lane K09 | — |
| 24 | K03.1 | Our predecessor's desk | 100 | medium | — | team agent | — |
| 25 | K03.2 | The script inside the script | 200 | hard | — | team agent | — |
| 26 | K03.3 | Finish the callback | 200 | hard | — | team agent | — |
| 27 | K04.1 | A bundle with consequences | 200 | hard | — | team agent | — |
| 28 | K04.2 | Read past the index | 400 | expert | — | team agent | — |
| 29 | K04.3 | Control the allocation | 800 | expert | — | team agent | — |
| 30 | K04.4 | The exception queue | 800 | expert | — | team agent | — |
| 31 | K05.1 | Speak the package's language | 50 | easy | — | team agent | — |
| 32 | K05.2 | The version they kept | 50 | easy | — | team agent | — |
| 35 | K06.1 | House credentials | 100 | medium | — | team agent | — |
| 36 | K06.2 | A private package in the wrong view | 100 | medium | — | team agent | — |
| 37 | K06.3 | The rehearsal consumer | 100 | medium | — | team agent | — |
| 40 | K07.3 | The protected inspection | 400 | expert | — | team agent | — |
| 41 | K08.1 | The old entitlement | 100 | medium | — | team agent | — |
| 44 | K09.1 | A runner tells on itself | 50 | easy | — | team agent | — |
| 45 | K09.2 | The artifact without a link | 50 | easy | — | team agent | — |
| 46 | K09.3 | A job input with reach | 100 | medium | — | pi lane K09 | — |
| 47 | K09.4 | Run in the runner | 100 | medium | — | pi lane K09 | — |
| 48 | K10.1 | Whose preview is this | 100 | medium | — | me (manual) | — |
| 49 | K10.2 | Two inputs, one identity | 100 | medium | — | team agent | — |
| 50 | K10.3 | The other document's contents | 200 | hard | — | team agent | — |
| 51 | K11.1 | Where the policy begins | 100 | medium | — | team agent | — |
| 52 | K11.2 | Learn its instructions | 200 | hard | `FLAG{5f3e067c00b70ca5}` | team agent | FKPC program recovered from `bin/fieldkest-policyc` (68 B, sha256 `0b9a7f…`); opcodes `00 PUSH_FIELD` … `07 RETURN` from the link map; flag value recovered 2026-11-23 from the fragment-check response |
| 53 | K11.3 | The rule behind the rule | 200 | hard | `FLAG{c71020d43793593b}` | team agent | — |
| 55 | K12.1 | The reviewer arrives second | 200 | hard | — | team agent | — |
| 56 | K12.2 | A value across the action boundary | 400 | expert | — | team agent | — |
| 59 | K13.1 | The listing nobody closed | 50 | easy | — | pi lane K13 | — |
| 60 | K13.2 | Before the correction | 50 | easy | — | pi lane K13 | — |
| 61 | K13.3 | The export next door | 50 | easy | — | pi lane K13 | — |
| 62 | K13.4 | What the workload can do | 100 | medium | — | pi lane K13 | — |
| 63 | K14.1 | The trust document | 50 | easy | — | pi lane K13 | — |
| 64 | K14.2 | Intended for someone else | 100 | medium | — | team agent | — |
| 66 | K15.1 | An export in progress | 50 | easy | — | pi lane K15 | — |
| 67 | K15.2 | A job outside your account | 100 | medium | — | pi lane K15 | — |
| 70 | K16.1 | Tomorrow's job | 50 | easy | — | team agent | — |
| 71 | K16.2 | The next startup | 100 | medium | — | team agent | — |
| 77 | K31.1 | Whose maintenance job | 100 | medium | — | team agent | — |
| 80 | K17.1 | A support session left behind | 50 | easy | `FLAG{408710d448134ab5}` | pi lane K25 | retained conversation, retention reference |
| 81 | K17.2 | A different way to recover | 100 | medium | — | team agent | — |
| 82 | K17.3 | Which customers belong here | 50 | easy | — | team agent | — |
| 84 | K18.1 | The note behind the preview | 100 | medium | — | team agent | — |
| 88 | K19.1 | Who vouches for whom | 100 | medium | — | me (manual) | — |
| 89 | K19.2 | Borrowed colleague | 200 | hard | — | me (manual) | — |
| 90 | K19.3 | The archive delegates | 400 | expert | — | me (manual) | — |
| 94 | K21.1 | The policy beside the prompt | 50 | easy | — | pi lane K21 | — |
| 95 | K21.2 | A conversation kept too long | 50 | easy | — | pi lane K21 | — |
| 96 | K21.3 | The answer it should withhold | 100 | medium | — | pi lane K21 | — |
| 100 | K23.1 | A context view left open | 50 | easy | — | pi lane K23 | — |
| 101 | K23.2 | The conversation reference | 50 | easy | — | pi lane K23 | — |
| 102 | K23.3 | A missing tenant boundary | 100 | medium | — | pi lane K23 | — |
| 103 | K24.1 | Complete the job | 50 | easy | — | pi lane K23 | — |
| 111 | K27.1 | A job for that customer | 100 | medium | — | team agent | — |
| 112 | K27.2 | Our diagnostic, their interface | 100 | medium | — | team agent | — |
| 113 | K27.3 | The other side of support | 100 | medium | — | team agent | — |
| 114 | K28.1 | A connector with two faces | 100 | medium | — | team agent | — |
| 117 | K29.1 | The build record's principal | 100 | medium | — | team agent | — |
| 118 | K29.2 | The signer in the history | 200 | hard | — | team agent | — |
| 120 | K29.4 | After the old key expires | 400 | expert | — | me (manual) | — |
| 121 | W01.1 | The customer's copy | 50 | easy | — | pi lane W01D | — |
| 122 | W01.2 | The planner's unfinished handover | 50 | easy | — | team agent | — |
| 123 | W01.3 | How the company buys time | 50 | easy | — | team agent | — |
| 125 | W02.1 | The asset and the contractor | 50 | easy | — | team agent | — |
| 126 | W02.2 | Three names for one job | 100 | medium | — | team agent | — |
| 128 | W03.1 | An annex left with the order | 50 | easy | — | pi lane W03B | — |
| 130 | W03.3 | The integration's read contract | 100 | medium | — | team agent | — |
| 164 | W13.1 | Window on Thursday | 50 | easy | — | team agent | — |
| 168 | W14.1 | The field bag | 50 | easy | — | team agent | — |
| 187 | W19.1 | The diagnostic nobody retired | 100 | medium | — | team agent | — |
| 226 | W31.1 | The vault's misleading length | 100 | medium | — | team agent | — |