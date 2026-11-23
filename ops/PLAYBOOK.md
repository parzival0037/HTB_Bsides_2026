# BSides CTF 2026 — shared playbook

Authorized CTF we are registered in (team MoTM, user shanvaishu95). Attack only the
training desks and the targets those desks/assignments name. Never the event site,
never the open internet.

## Range box access (all work happens on this box)

`/home/kali/ctf/box.py` runs a command on the Kali range box over the platform's
WebSocket SSH terminal and prints the output.

```bash
/home/kali/ctf/box.py 'id; uname -a'          # single command, ~8s round trip
/home/kali/ctf/box.py -t 90 'nmap -sT -p- 10.77.40.20'
/home/kali/ctf/box.py -f /tmp/myscript.sh     # upload a local script and run it (fast: one round trip)
```

Prefer `-f` with a batched script — every call is a fresh SSH session, so state
(cwd, vars, background procs spanning calls) does not persist. `screen`/`tmux` on the
box does persist if you need a long-running listener:

```bash
/home/kali/ctf/box.py -t 30 'tmux kill-server 2>/dev/null; tmux new-session -d -s w "nc -lvnp 4444 > /tmp/cap.txt 2>&1"; sleep 1; tmux ls'
```

`sudo -n` on the box is passwordless, and the box has internet. Install what you need
(`sudo apt-get install -y ...`, `pip install ...`).

## Box network map

```
10.77.40.10 / 10.77.41.2  kali (us)
10.77.40.20  workbench.training    :8080 markdown index, git/handover.git,
                                   :8081 dispatch desk, :8082 courier API,
                                   :8083 diagnostics helper
10.77.40.30  accounts.training     :8080 identity desk
10.77.40.40  developer.training    :8080 developer artifacts
10.77.40.50  state.training        :8080 outlet / SCADA desk
10.50.13.180 rowan-dev             KeplerOps developer workstation
                                   ssh rowan (port 2222, key ~/.ssh/keplerops-foothold)
                                   RDP host too (xfreerdp /v:rowan-dev /u:rowan /p:fieldlink-dev-2841)
```

Later stages: from rowan-dev, discover the KeplerOps network (K-challenges) and then
ARWC, the water utility (W-challenges). Pivot through rowan-dev as the jump host.

## Challenges and submission

```bash
/home/kali/ctf/brief.py            # all unsolved challenges with descriptions + unlocked hints
/home/kali/ctf/brief.py 'T02'      # filter by name regex
/home/kali/ctf/submit.py 'T02.2' 'FLAG{...}'   # submit by name prefix or full id
```

Flag format `FLAG{<16 hex>}`. Attempts are limited and hints cost points — read the
description carefully before submitting; do not guess flags. Submission is
idempotent-safe: a wrong flag burns an attempt.

## Rules

- Work in your own lane directory under `/home/kali/ctf/lanes/<lane>/`. Do not edit
  `/home/kali/ctf/box.py`, `submit.py`, `brief.py`, `challenges.json`, `details.json`.
- Never modify the event site or the kali box in ways that break it for other lanes.
- Desks remember state you change ("anything you change, the desk remembers") — make
  deliberate changes, not exploratory destructive ones.
- Report back: flags found, what solved which challenge, dead ends, and what the next
  stage needs.
