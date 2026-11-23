# HANDOVER — BSides CTF 2026 ("Operation NORTHSTORM"), team MoTM

Started 2026-11-20 ~13:35Z; updated ~19:45Z (state **50/240**, 3450 pts). Read this top to bottom before touching anything.

## 1. Mission

Authorized CTF we are registered in. Event: `BSides CTF 2026`, team **MoTM**,
user `shanvaishu95`. 240 challenges, flag format `FLAG{<16 hex>}`, attempts are
limited and hints cost points. Scope: the training desks and whatever the
assignment names. Never the event site itself, never the open internet.

Story: we are "Cinder Typhoon"; KeplerOps Software makes FieldLink; **ARWC**
(Alterra Regional Water Co.) runs reservoir gates — that is the objective.

## 2. Access

### Event API (read challenges, submit flags)

Session cookie jar: `/home/kali/ctf/cookies.txt` (Django `sessionid` + `csrftoken`).
All calls need `X-Request-ID` and, for POST, `X-CSRFToken`. Helpers already do this.

- Login: `POST https://bsides.keplerops.com/ctf/login/` (csrf + username/password)
- Challenges: `GET /api/v1/ctf/me/challenges/`
- Detail: `GET /api/v1/ctf/me/challenges/{id}/` (description, unlocked hints, files)
- Submit: `POST /api/v1/ctf/challenges/{id}/submit/` `{"flag":"..."}`
- Event/score: `GET /api/v1/ctf/me/event/` · Range: `GET /api/v1/ctf/range/status/`
- Submission history (no flag text): `GET /api/v1/ctf/submissions/`

If the cookie expires, re-login (credentials were provided in-session by the operator;
ask them rather than guessing).

### Range box (the Kali host all attacks run from)

The box is **not** directly reachable. It is driven through the platform's browser
terminal WebSocket — the same SSH session the "Terminal" tab in the UI opens:

```
wss://bsides.keplerops.com/ws/terminal/provision.node.training-host%230/
JSON frames: {"type":"input","data":"..."} / {"type":"resize",...} ; output: {"type":"output","data":"..."}
```

`/home/kali/ctf/box.py` wraps this. Use it for everything:

```bash
./box.py 'id; ls ~'                 # one command (~8s round trip, fresh shell each time)
./box.py -t 90 'nmap -sT 10.77.40.20'
./box.py -f script.sh               # upload+run a batched script — preferred
```

Box facts: user `cinder`, **passwordless sudo**, internet, nmap/gobuster/curl/python3/jq/git.
Missing: `ss`, `netstat`, `setsid`, `ffuf`, `sqlmap`, `gcc`. `/tmp` is **noexec** (run
scripts with `bash /tmp/x.sh`, not `/tmp/x.sh`). No tmux **on rowan-dev**; tmux exists on
the range box.

### KeplerOps foothold (Assignment 1)

```bash
./box.py 'ssh -o BatchMode=yes rowan-dev "cmd"'      # user rowan, port 2222, key ~/.ssh/keplerops-foothold
```
RDP alternative: `xfreerdp /v:rowan-dev /u:rowan /p:fieldlink-dev-2841`.

### Pivot into 10.77.x (REQUIRED for every K and W challenge)

The range box cannot route to 10.77.x. rowan-dev's sshd is
`AllowTcpForwarding local` + `PermitOpen 127.0.0.1:13389`, so `ssh -D` is dead.
Working setup (two supervised tmux sessions on the range box):

- `relay`: `ssh rowan-dev 'python3 /tmp/s5.py 13389'` — SOCKS5 relay (script at
  `/home/kali/ctf/lanes/k01/socks5.py`, uploaded to rowan-dev as `/tmp/s5.py`)
- `pivot`: `ssh -N -L 0.0.0.0:1080:127.0.0.1:13389 rowan-dev`

Then, from the range box:

```bash
curl -sS --socks5-hostname 127.0.0.1:1080 -k https://source.keplerops.test/
# python: proxies={'https':'socks5h://127.0.0.1:1080'}, verify=False
```

CA: `/home/kali/ctf/ca.crt` (CN=KeplerOps Range CA). Prefer `--cacert`, `-k` also works.
If the pivot is down: re-run `bash /tmp/relay.sh` and `bash /tmp/fwd.sh` in tmux, or
recreate per `lanes/NETMAP.md`. **Full host/service/credential map: `lanes/NETMAP.md`.**

## 3. Tooling in this folder

| File | Purpose |
|---|---|
| `box.py` | run commands on the range box over the WS SSH terminal (auto-retry on DNS blips) |
| `submit.py` | `./submit.py 'T02.2' 'FLAG{...}'` — submit by name prefix or id, with CSRF |
| `brief.py` | `./brief.py 'K1[0-5]'` — unsolved challenges with descriptions + unlocked hints |
| `challenges.json` | last known state (refresh via `set_active.py`/`kanban.py` fetch) |
| `details.json` | cached descriptions/hints (stale — refetch when needed) |
| `submissions.json` | submission history |
| `kanban.py` | regenerates `kanban.html` from live API + `lanes/state.json` |
| `set_active.py` | `./set_active.py K13 W01` — declares which lanes are actually running |
| `refresh.sh` | optional 45 s loop that rebuilds the kanban |
| `FLAGS.md` | flag registry: value → challenge → how it was obtained |
| `lanes/NETMAP.md` | KeplerOps/ARWC host map, credentials, service contracts |
| `lanes/common.md` | boilerplate prepended to every lane brief |
| `lanes/spawn.sh` | `./lanes/spawn.sh K07` — launch one lane |
| `lanes/fleet.sh` | `./lanes/fleet.sh lanes/queue.txt 3 4` — rate-limit-aware queue runner |

Kanban: `python3 kanban.py` then open `/home/kali/ctf/kanban.html`
(or serve: `python3 -m http.server 8899 --bind 0.0.0.0 --directory /home/kali/ctf`,
board at `http://<this-host>:8899/kanban.html`).

## 4. State: 50 / 240 solved · 3450 pts

Complete: **T01 (4), T02 (4), T03 (4), T04 (4), K01 (4), K02 (3), K13 (4), K21 (3), K27 (3)**.
Partial: **K05 (2/4)**, **K08 (1/3)**, **K09 (3/4)**, **K14 (2/3)**, **K15 (2/4)**,
**K16 (2/4)**, **K17 (3/4)**, **K24 (1/3)**, **K29 (1/4)**.
Nothing in the W (ARWC) chapters yet — that is the big untapped block (35 chapters).

Training desks were the tutorial: workbench (git history + path traversal in a
diagnostics renderer), accounts (account enum → hidden directory API → recovery
takeover → IDOR brief), developer (deleted fixture in git, install-hook inspection,
deliver a formatter), state (SCADA: measurement vs setpoint, status-word bit decode,
bounded transfer, report-vs-observation audit).

K13 is now 4/4. The cloud chain K13→K14→K15→K16 is the current seam: workload
token → trust record (K14.1) → export role record (K14.2) → export/schedule records
(K15.1/15.2, K16.1) → schedule startup run (K16.2). Remaining: K14.3, K15.3/15.4,
K16.3/16.4.

## 5. Lanes (subagents)

Each lane = one headless `pi` process in `lanes/<code>/` with `BRIEF.md`, `run.log`,
`notes.md`, `REPORT.md`, `sessions/`. Lanes write `REPORT.md` early and `touch DONE`
when finished — **read `REPORT.md`, not `run.log`, to harvest work.**

Lanes exist for: k01 k02 k05 k09 k11 k13 k14 k15 k16 k17 k18 k21 k22 k23 k24 k25 k29
w01 w02 w03 w05 w08 w09 w10 w12 w13 w14 w15 w16 w17 w18 w19 w21 w25 w29 w35.

**Two workers share this board.** pi lanes run headless (`lanes/spawn.sh`, `fleet.sh`),
and the opencode/OC lane claims chapters directly in `lanes/state.json`. Current
active set (19:45Z): pi = W01, W17, K23, W02, W03, W05, W09, W10, W13, W14, W18,
W25, W35, K22, K25; OC = K14, K16. pi restarted a large W-block fleet after 19:30Z,
so re-check `ps`/`state.json` before taking an easy W card. The old queue runners are
still not guaranteed to be consuming `lanes/queue.txt`.
When you start a lane, add its cards to `in_progress` in `lanes/state.json` (lane tag
`pi` or `OC`) **before** touching the target, then `python3 kanban.py`. Do not call
`set_active.py` mid-session: it rebuilds `in_progress` from chapter codes and would
erase the other worker's claims.

## 6. Operational gotchas (learned the hard way)

1. **Rate limits.** The model provider returns `429 / Request aborted` when too many
   children run at once. 10+ lanes killed the whole fleet. Keep **2–3 concurrent lanes**,
   never more, and expect backoff. This is the real bottleneck, not RAM.
2. A child that is still waiting on its first token logs nothing — an empty `run.log`
   does not mean death. Check for a process with `cwd` under the lane dir, or a bash
   child whose cmdline mentions it.
3. `box.py` sessions are fresh shells: no cd/env persistence. Batch work into one
   script, or keep long jobs in tmux on the box.
4. `/tmp` on the range box is noexec → `bash script.sh`.
5. `ssh -D` to rowan-dev fails (`administratively prohibited`) — use the relay + `-L`.
6. The workstation has a transient-TLS habit (`self-signed certificate` errors in
   children) — retry; it is a blip, not a broken setup.
7. `submit.py` burns an attempt on a wrong flag. Establish values from evidence first.

## 7. Suggested next moves

1. **Close the cloud chain.** K14.3, K16.3, K16.4 are the live edge (details in §8).
   K15.3/K15.4 follow from the export destination + partition records.
2. Land the half-finished lanes: **K05.3/K05.4, K09.4, K17.4** — read their
   `REPORT.md`/`notes.md` first; all are one or two cards from done.
3. Open the **W block** (ARWC). Everything hangs off `connector.arwc.test` (10.77.60.20)
   plus the KeplerOps apps; W01/W02 are 50p recon cards and unlock the rest. pi is on
   W01/W17/K21/K23; take W02/W09/W13/W18 next so claims do not collide.
4. Run K chapters 2–3 at a time, easy-first; `lanes/queue.txt` is only a hint now that
   the fleet runners have exited.
5. Keep `FLAGS.md` current: every accepted flag → value, challenge, technique.
   `submissions.json` gives points/attempts but **not** flag text, and can lag.
6. Rebuild the board with `python3 kanban.py` after any claim/submit. Avoid
   `set_active.py` while another worker is active (it rewrites all claims).

## 8. Session log — 2026-11-20 19:00–19:30Z (opencode / OC)

Flags accepted this session: **K13.4** `FLAG{10a79b42b8e652b2}` (workload configmap
`bld-1842`), **K14.1** `FLAG{418e19c3ed0c13ef}` (`trust-flx-04`), **K14.2**
`FLAG{f1aee508e418ac7c}` (`role-export-access`), **K16.1** `FLAG{25a027fe80e77ca0}`
(`/api/schedules/SCHED-2841`), **K16.2** `FLAG{ba92d77607f974b5}` (schedule run after
`MARKER=cinder`). K13 is complete; overall 31 → 50 solved during the afternoon run
(the other cards came from pi lanes K02/K08/K15/K21/K24/K27/K29).

Reusable cloud-api chain (all via SOCKS pivot; `rowan.ito:fk_developer_...` from
NETMAP is the workspace credential):

```bash
# 1. workload identity
GET  /api/workspaces/current/token-exchange         # Basic rowan creds -> fixture info
POST /api/workspaces/current/token-exchange {}      # -> workload JWT (svc-fieldlink-workload)
# 2. export role
POST /api/token-exchange/fieldkest-export-access {} # Bearer workload JWT -> export JWT
#    (svc-fieldlink-export, role/support-export-editor, scope fieldkest-exports)
# 3. records (export JWT)
GET  /api/exports/EXP-2841[/definition]
GET  /api/schedules/SCHED-2841
POST /api/schedules/SCHED-2841/runs {}
PATCH /api/schedules/SCHED-2841 {"assignment":"field-operator-b"}
# 4. limited k8s (export JWT can get/patch only these)
GET  .../configmaps/role-export-access        # role record + flag
GET  .../configmaps/exp-2841-definition      # export definition (+patch)
GET/PATCH .../cronjobs/sched-2841
GET  .../jobs/exp-2841 ; POST .../jobs
```

**Open leads (hard-won, do not redo):**
- **K16.3** `sched-2841` pod gets `envFrom secretRef sched-2841-runner-credentials`
  (`STARTUP_TOKEN`, `HANDOVER_TOKEN`) and runs as `svc-schedule-runner`; the run job
  prints `startup-credential: $STARTUP_TOKEN`. Neither export JWT nor rowan-workspace
  can read the secret or pod logs. The job-create right (export JWT, `batch/jobs`) is
  the likely way to establish the separate execution context.
- **K16.4** state already changed: CronJob env has `MARKER=cinder` and
  `ASSIGNMENT=field-operator-b`; schedule record assignment was PATCHed to
  `field-operator-b` (revision 2). `POST /runs` still returns the K16.2 flag; the job's
  `elif` branch prints `handover-credential: $HANDOVER_TOKEN` only when `MARKER` is
  empty. Output retrieval is the same problem as K16.3.
- **K15.3** `PATCH /api/exports/EXP-2841/destination`
  `{"destination":"fieldkest-exports/EXP-2841-rowan"}` → 200 change record
  (`old_destination=...-maya`, `revision:10`, schema `export-destination-change/v1`).
  No flag in the response; check for a change/audit record before retrying.
- **K15.4** migration source found in `s3://fieldlink-exports/backups/company-history.dump`
  (rowan-dev AWS creds can read it): PGDMP with `support.customer_migration_history`
  `ARWC FieldLink legacy / TEN-ARWC-019 / FLK-6.9.8 → TEN-ARWC-047 / FLK-7.4.2`
  (2026-02-17) and `support.customer_records` `CUSTREC-047-R6 / TEN-ARWC-047 /
  FLK-7.4.2 / CRR-OG2 / SUP-2841`. We patched `exp-2841-definition` tenant +
  `partition_bindings` to `TEN-ARWC-047`, then `POST /api/exports/EXP-2841/runs`
  `{tenant:TEN-ARWC-047, connector_revision:FLK-7.4.2, partitions:[PART-ARWC-01],
  revision:6}` → 201 `collection_key:PART-ARWC-01-rev10.json`,
  `destination:fieldkest-exports/EXP-2841-rowan`. Object reads are still 403 (k8s JWT
  rejected by STS; rowan AWS creds cannot read `fieldkest-exports`).
- **K14.3** same collection: the export role is still denied the support export.
  `objects.keplerops.test` STS rejects the k8s JWT (`no identity provider registered
  for issuer`). Try the support service / a support-export role, not S3 STS.
- **K15.1/K15.2 already solved** — do not resubmit `FLAG{6b4342f2b090f8d2}` /
  `FLAG{bd60dc9d170bc2c7}`.

**State changes to be aware of (the desks remember):** export `EXP-2841` destination
now `EXP-2841-rowan`; `exp-2841-definition` tenant/bindings now `TEN-ARWC-047`;
schedule `SCHED-2841` assignment now `field-operator-b`; CronJob `sched-2841` has
`MARKER=cinder` and `ASSIGNMENT=field-operator-b`.

## 9. Quick self-test before you start

```bash
cd /home/kali/ctf
python3 -c "import json;print(sum(c['solved'] for c in json.load(open('challenges.json'))))"  # expect 47+
./box.py 'hostname; id'                       # expect kali / uid=2000(cinder)
./box.py 'curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w "%{http_code}\n" https://source.keplerops.test/'
                                              # expect 200; if 000 the pivot is down
./submit.py --help 2>/dev/null || true        # reminder: submit.py <name> <flag>
```
