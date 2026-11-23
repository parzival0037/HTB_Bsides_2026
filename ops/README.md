# Operational artefacts

The working directory of the run, kept verbatim for study. Nothing here is needed to read
the write-ups.

| File | What it is |
|---|---|
| `kanban.html` | the live board: in-progress / next / exploited, with claims and flags |
| `CLAIMS.md` | which card each agent had claimed, so two agents never fought over one |
| `FLAGS.md` | flag registry: value → card → how it was obtained |
| `NETMAP.md` | the service map and credentials recovered on the workstation |
| `ARWC-FINDINGS.md` | everything proven and disproven about the ARWC ingress |
| `PLAYBOOK.md` | the brief every agent was given: access, pivot, rules, submission |
| `state.json` / `queue.txt` | lane bookkeeping and the chapter queue order |
| `solved-cards.json` | per-card description, hints, evidence snippets (the fact source for the write-ups) |
| `challenges.json` | event API snapshot: all 240 cards with solved state, points, difficulty |

**These credentials are dead.** The range was destroyed after the event; they are published
only so the write-ups are reproducible.
