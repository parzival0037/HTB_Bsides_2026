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


## 3a. Credentials and access (dead range — keep for reference only)

The range was destroyed after the event. Every value below is published so the write-ups
are reproducible, not because it authenticates anything.

### Access chain

| Item | Value |
|---|---|
| Event UI / API | `https://bsides.keplerops.com/ctf/` · `/api/v1/…` |
| Browser terminal | `wss://bsides.keplerops.com/ws/terminal/provision.node.training-host%230/` |
| Operator box | `kali 10.77.40.10`, user `cinder`, passwordless sudo |
| Workstation SSH | `ssh rowan-dev` → `rowan@10.50.13.180:2222`, key `~/.ssh/keplerops-foothold` |
| Workstation RDP | `/v:rowan-dev /u:rowan /p:fieldlink-dev-2841` |
| Pivot | SOCKS5 relay on `rowan-dev:127.0.0.1:13389`, `ssh -N -L 1080:127.0.0.1:13389 rowan-dev` (sshd: `AllowTcpForwarding local`, `PermitOpen 127.0.0.1:13389`) |
| Range CA | `/home/kali/ctf/ca.crt` (`CN=KeplerOps Range CA`); workstation copy `~/.local/share/keplerops/ca.crt` |

### Accounts

> **Why the platform password is not in this repo.** It authenticates a real account on a
> third-party site, and this repository is public. Publishing it would be credential
> exposure for no learning value. The same applies to `cookies.txt`, which was excluded
> from `ops/ctf/` for exactly this reason: it contained a live `sessionid`.
>
> If you are re-running this and hold the credentials, put them in
> `~/.config/htb-ctf/credentials` (mode 600) and read them in your own scripts. Everything
> else in this document is a range credential for a destroyed lab, which is why it is
> reproduced openly.

| Account | Secret | Valid for |
|---|---|---|
| **CTF platform** `shanvaishu95` | password **not committed** — held by the operator; used only for `POST /ctf/login/` | the event UI/API: challenges, hints, submissions |
| `rowan.ito` | `fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo` | Gitea, Jenkins read, `review`, `delivery:8443` basic auth, npm, AnythingLLM (id 2), Keycloak `admin-cli`, `kinit` (KDC password) |
| `maya.ranscombe` | `sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk` | osTicket `/scp/`, Kanboard (user 3), AnythingLLM (id 3), owns `EXP-2841` |
| `talia.mornac` | `K17r3v13wTalia2841` | osTicket reviewer queue |
| `talia.mornac-review` | recovery token `k17-talia-mornac-review-token-2841` (`/scp/pwreset.php?token=`) | view-only reviewer on `DIAG-CRR-MIXED-19` |
| `rhea.moss` | recovery: `CASE-7Q4M` + `Blue cabinet 17` | training accounts desk: `/api/handover`, `/api/assignments` |
| `evan.calderoux@keplerops.test` | cert + key minted via enrollment | `GET /api/archive/handovers/evan.calderoux@keplerops.test`, delegation probe |

### Machine credentials

| Token | Scope |
|---|---|
| `fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b` | `support.keplerops.test:8443` bearer: handovers, create customer diagnostics, read/deliver jobs |
| `fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9` | `POST /api/enrollment/StaffArchiveUser/requests` only |
| `fk_workload_fixture_7nNUHpIQRCb5s2SLo7lb0sJH9LXByeMK` | token-exchange fixture only, not a bearer |
| Kubernetes SA `fieldlink:rowan-workspace` | `get` on ConfigMaps `bld-1842`, `trust-flx-04`; no secrets/pods |
| `svc-fieldlink-export` (role `role/support-export-editor`) | `/api/exports/EXP-2841`, `/schedules/SCHED-2841`, export ConfigMaps |
| `svc-fieldlink-ci` (per-run, ~3 min) | `GET /api/build-records/worker-status` |
| npm `_auth` (base64 of `rowan.ito:fk_developer_…`) | `npm pack` of `@keplerops/*` (`support-rehearsal` is 403) |
| AWS profile on rowan-dev | `s3://fieldlink-exports/backups/company-history.dump` readable |

### Database and directory

| Item | Value |
|---|---|
| Postgres | `data.keplerops.test:5432`, db `fieldlink_data`, role `rowan_data` / `lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY` — only `export.partition_bindings` |
| Blocked | `support.customer_records`, `support.customer_migration_history` (owned by `fieldlink_admin` / `fieldlink_data_owner` — never obtained) |
| Kerberos | realm `KEPLEROPS.TEST`, KDC `10.77.50.40`; only SPN present `HTTP/staff.keplerops.test` |
| Tenants / assets | `TEN-ARWC-047` → `CRR-OG2`, connector `FLK-7.4.2`; `TEN-RILL-022` → `RILL-PUMP-442`, `FLK-7.4.1-RILL` |

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


## 3b. Links

### Inside this repo
| Link | What |
|---|---|
| [`README.md`](README.md) | curriculum index |
| [`docs/00-start-here.md`](docs/00-start-here.md) | Part I — the loop, the tools, one desk by hand |
| [`docs/10-textbook/README.md`](docs/10-textbook/README.md) | the 11 chapters and reading order |
| [`docs/20-labs.md`](docs/20-labs.md) | build-and-break labs |
| [`docs/02-network-topology.md`](docs/02-network-topology.md) | hosts, ports, the pivot |
| [`docs/04-accounts-and-hosts.md`](docs/04-accounts-and-hosts.md) | identities in table form |
| [`docs/06-caveats.md`](docs/06-caveats.md) | honest retrospective |
| [`writeups/README.md`](writeups/README.md) | all 91 case files, indexed |
| [`ops/ctf/README.md`](ops/ctf/README.md) | the working directory, explained |
| [`toolkit/README.md`](toolkit/README.md) | the drivers |
| [`ops/NETMAP.md`](ops/NETMAP.md) · [`ops/ARWC-FINDINGS.md`](ops/ARWC-FINDINGS.md) · [`ops/FLAGS.md`](ops/FLAGS.md) | map, ARWC wall, flag registry |
| [`ops/kanban.html`](ops/kanban.html) | the live board as it stood |

### Range services (dead)
| Service | Endpoint |
|---|---|
| Event UI / API | `https://bsides.keplerops.com/ctf/` · `https://bsides.keplerops.com/api/v1/` |
| Terminal socket | `wss://bsides.keplerops.com/ws/terminal/{instance}/` |
| Training desks | `workbench.training:8080` · `accounts.training:8080` · `developer.training:8080` · `state.training:8080` |
| KeplerOps fabric | `10.77.50.11:443` — `objects` `staff` `support` `assistant` `llm` `workboard` `identity` `id` `ca` `cert` `tickets` `workload(s)` |
| Source / CI | `source.keplerops.test` · `source-tools…:8443` · `ci.keplerops.test` · `packages.keplerops.test` |
| Delivery / review | `delivery.keplerops.test:8443` · `review.keplerops.test` · `preview` `indexer` |
| Cloud / data | `cloud-api.keplerops.test:6443` · `data.keplerops.test:5432` |
| Support | `support.keplerops.test` (osTicket `/scp/`) · `support.keplerops.test:8443` (client) |
| ARWC | `connector.arwc.test` (10.77.60.20) — 403 without a channel identity |

### Client references (the most useful discovery of the run)
`https://<service>/.well-known/fieldkest-client` on `source-tools…:8443`,
`delivery…:8443`, `support…`, and `review…`. Each returns the full route list with request
bodies; `ops/ARWC-FINDINGS.md` has the transcribed versions.

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
