# The working directory, verbatim

This is the folder the run actually happened in (`/home/kali/ctf` on the operator box),
copied as-is so you can see how the work was really done — including the false starts.

## What is in here

| Path | What it is |
|---|---|
| `box.py`, `submit.py`, `brief.py`, `kanban.py`, `claims.py`, `watch_solves.py` | the drivers (same as [`../../toolkit/`](../../toolkit/README.md)) |
| `PLAYBOOK.md`, `common.md` | the brief handed to every agent lane |
| `NETMAP.md`, `ARWC-FINDINGS.md` | the service map and the ARWC wall, written during the run |
| `FLAGS.md`, `HINTS.md`, `CLAIMS.md` | flag registry, unlocked hints, claim board |
| `kanban.html`, `claims.json`, `state.json` | the live board and its state |
| `challenges.json`, `details.json`, `wu_data.json` | API snapshots: all 240 cards, and the per-card evidence used to write the write-ups |
| `submissions.json` | every submission, correct and incorrect |
| `lanes/<code>/` | per-chapter working files: `BRIEF.md`, `REPORT.md`, `notes.md`, the shell scripts that were run (`r*.sh`, `k*.sh`) and their captured output (`*.out`) |
| `lanes/micro/<code>/` | the single-card micro-lanes used near the end |
| `docs_agents/`, `wu_agents/`, `tb_agents/` | the briefs given to the doc/textbook agents that produced `docs/` and `writeups/` |
| `*.sh` at top level | one-off probes against the range (support client, delivery service, enrollment, diagnostics) |

## What was deliberately left out

| Excluded | Why |
|---|---|
| `cookies.txt` | live session cookie for the event API |
| `*/sessions/*.jsonl` | full agent transcripts: huge, and they contain materialised credentials (client keys) that are not needed to understand the work |
| `*.key` | private keys |
| `lanes/smoke*`, `lanes/dbg` | throwaway launch tests |

## Reading order

1. `PLAYBOOK.md` — the rules and the access path.
2. `NETMAP.md` — the hosts, ports and credentials.
3. A lane's `REPORT.md`, then the `r*.sh` scripts beside it: the report says what worked, the
   scripts show the exact requests.
4. `ARWC-FINDINGS.md` — what was proven *impossible*, which is often the more useful half.

Every credential in here is dead: the range was destroyed after the event.
