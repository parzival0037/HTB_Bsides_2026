# HANDOVER — to the next agent

You are picking up a finished CTF run and a repository that is being turned into a
teaching resource. Read this before changing anything.

## 1. What exists

```
README.md                  curriculum index + the honest "how this was produced" note
docs/00-start-here.md      Part I: the loop, four tools, one desk solved by hand
docs/10-textbook/          11 chapters, one bug class each (+ README curriculum map)
docs/20-labs.md            8 build-and-break labs (Flask, openssl, git)
docs/01-ctf-composition.md what the event was made of (categories, scoring, the 3 acts)
docs/02-network-topology.md hosts, ports, segments, the pivot, client references
docs/04-accounts-and-hosts.md identities, service accounts, DB roles, PKI, tenants
docs/05-method-and-tooling.md how the run was driven
docs/06-caveats.md         attribution, hint spend, unattributed flags, dead ends
docs/img/                  rendered diagrams + the scripts that generate them
writeups/                  91 per-card write-ups (one per SOLVED card) + index
toolkit/                   the scripts the run used (see §4)
ops/                       raw operational artefacts (kanban, claims, flags, netmap…)
```

**Board result: 91 / 240** (Training 16/16, KeplerOps 64/104, ARWC 11/120, 10,700 points).

## 2. State of the repository

| Item | Status |
|---|---|
| 91 solved cards | ✅ one write-up each, all with the range-map image |
| 149 unsolved cards | ⛔ deliberately **not** written — do not invent them |
| Textbook chapters | ✅ 11 of 11; each has exercises, but none have been *tested* by a human |
| Labs | ⚠️ written, not executed end-to-end in a clean environment |
| Diagrams | ✅ rendered from `docs/img/render_network.py`, `render_chain.py` |
| Indexes | ⚠️ `writeups/README.md` still derives its "bug class" column from hint text — improve it by parsing each file's **At a glance** table |

The single most useful thing you can do: **verify**. Every command in the labs and in
`00-start-here.md` was written from captured output, not re-run from scratch.

## 3. Rules this repo follows (keep them)

1. **No write-up for an unsolved card.** If a card was not solved, it does not get a file.
2. **No invented flags.** If the value was not captured, write "accepted, value not recorded".
3. **No invented transcripts.** If the technique is reconstructed rather than observed, say
   so in "Notes and dead ends".
4. **Hints are never spent.** `toolkit/hints.py` refuses without `--force`, and the operator
   has explicitly banned hint spending (it permanently reduces score).
5. **No personal data.** No leaderboard names, no real individuals.

## 4. The toolkit (`toolkit/`)

The run was driven over the platform's browser-terminal WebSocket; these scripts are what
that looked like. They are published for study and will not run against a dead range.

| Script | Purpose |
|---|---|
| `box.py` | sends a command to the range box over `wss://…/ws/terminal/{instance}/`, JSON `input` frames into an SSH pty; auto-retries DNS blips; `-f` uploads+runs a batched script |
| `submit.py` | submits a flag by challenge-name prefix, with CSRF |
| `brief.py` | prints unsolved challenges with descriptions and unlocked hints |
| `kanban.py` | regenerates `kanban.html` from the event API + `lanes/state.json` |
| `claims.py` | publishes which cards are being worked, so agents do not collide |
| `set_active.py` | declares which lanes are actually running |
| `watch_solves.py` | polls the submission feed and logs each new solve |
| `fleet.sh` / `spawn.sh` | launch headless agent lanes, one chapter each, with adaptive rate-limit backoff |
| `hints.py` | hint unlocker, hard-disabled |
| `refresh.sh` | 30 s loop: claims + kanban |

Operational artefacts in `ops/`: `kanban.html` (the live board, last state), `CLAIMS.md`,
`FLAGS.md`, `NETMAP.md`, `ARWC-FINDINGS.md`, `PLAYBOOK.md`, `state.json`, `queue.txt`,
`solved-cards.json` (per-card descriptions/hints/evidence), `challenges.json` (API snapshot).

## 5. Gotchas that cost us hours

- **Graphviz 2.42 spline router is broken here** (`cannot realloc pnls`): it silently drops
  arrows. That is why every diagram is matplotlib. Regenerate with
  `python3 docs/img/render_network.py` (segments + access path) and
  `python3 docs/img/render_chain.py` (per-card chain).
- **`rowan-dev`'s sshd**: `AllowTcpForwarding local` + `PermitOpen 127.0.0.1:13389`, so
  `ssh -D` is dead. See `docs/02-network-topology.md` §"Why the pivot has to be built that way".
- **`/tmp` is noexec** on the range box and a full 64 MB tmpfs on `rowan-dev` — write to
  `/home/rowan` instead.
- **The AI provider rate-limits hard.** More than ~3 concurrent lanes produced
  `429/Connection error` and killed whole batches. The fleet script backs off adaptively.
- **Do not `pkill -f <pattern>`** where the pattern matches your own command line — that
  killed the driving shell twice during this run.
- **DNS on the operator workstation flakes**; every helper script retries.

## 6. What is genuinely unfinished

1. **ARWC (11/120).** The relay needs an ARWC-issued channel identity. Staff mTLS, staff
   Kerberos tickets and KeplerOps service tokens are all refused
   (`403 channel_identity_denied`). See `ops/ARWC-FINDINGS.md` for everything proven and
   every dead end — read it before spending time there.
2. **`support.*` database tables** are owned by `fieldlink_admin` / `fieldlink_data_owner`;
   those credentials were never obtained.
3. **K17.4** (delegated support action): the delegation probe returns the K19.3 flag
   regardless of reviewer, so the actual routing endpoint was never found.
4. **Two flags found but never attributed** — recorded in `docs/06-caveats.md`; do not
   guess-submit them.
5. **Textbook exercises** have no answers. Adding a `solutions/` folder would make the book
   far more useful.

## 7. How to verify the repo before publishing

```bash
# every write-up is for a solved card, and every solved card has one
python3 - <<'PY'
import json, pathlib
solved = {c['code'] for c in json.load(open('ops/solved-cards.json'))}
files = {p.stem for p in pathlib.Path('writeups').glob('*.md')} - {'README'}
print("missing:", solved - files, "| extra:", files - solved)
PY

# no write-up contains a fabricated flag format
grep -rLo 'FLAG{[0-9a-f]\{16\}}' writeups/*.md | head

# every write-up has the map image
grep -L 'docs/img/segments.png' writeups/*.md | head
```

## 8. If you continue the CTF

Start from `ops/PLAYBOOK.md` (access, pivot, rules) and `ops/NETMAP.md` (hosts, credentials).
The event API needs a live session cookie; the range is destroyed after the event, so most
of this is archaeology rather than a live target. If you do get a live range again:
**3 lanes maximum**, claims published before starting, and no hint spending.
