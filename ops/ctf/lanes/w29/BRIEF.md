You are solving part of an authorized CTF (BSides CTF 2026, team MoTM). Read
/home/kali/ctf/PLAYBOOK.md first — it defines range-box access (box.py), the network
map, submission (submit.py), and the rules. Follow it exactly.

Key operational facts:
- All target traffic must originate FROM the range box: /home/kali/ctf/box.py 'cmd'
  or /home/kali/ctf/box.py -f <local script>. Each call is a fresh SSH session (~8s),
  so batch aggressively into one script and prefer -f.
- The box has passwordless sudo and internet; install tools there, not here.
- Work only inside your lane dir. Never edit box.py, submit.py, brief.py,
  challenges.json, details.json.
- Submit flags with /home/kali/ctf/submit.py '<challenge name prefix>' 'FLAG{...}'.
  Attempts are limited: never guess. Submit only when the flag clearly answers that
  challenge's description.
- /home/kali/ctf/brief.py prints unsolved challenge descriptions and hints.
- Check HINTS.md in your lane dir FIRST: hints for your cards are already unlocked
  and paid for. Then keep notes.md in your lane dir updated as you go, and write REPORT.md EARLY with
  whatever you have, then keep rewriting it as you progress. The machine is low on RAM
  and a lane can be killed at any moment; an up-to-date REPORT.md is what survives.
- When done or blocked, write a final REPORT.md in your lane dir containing: flags
  submitted and which challenge each solved, the service/endpoint map discovered,
  credentials found, the technique that worked, dead ends, and what later stages
  depend on. Be concrete and complete; the parent only reads your report.

## KeplerOps pivot (needed for most K and W chapters)

READ /home/kali/ctf/lanes/NETMAP.md FIRST. Short version: from the range box, every
*.keplerops.test / *.arwc.test service is reachable through a SOCKS5 pivot that is
already running on the box:

    curl -sS --socks5-hostname 127.0.0.1:1080 -k https://source.keplerops.test/
    # python: proxies={'https':'socks5h://127.0.0.1:1080'}, verify=False

CA: /home/kali/ctf/ca.crt. `ssh -D` does NOT work (sshd allows only PermitOpen
127.0.0.1:13389). If the pivot is down, see NETMAP.md for how to restart it.

## HINTS: do not spend points

**DO NOT UNLOCK HINTS.** Every hint permanently reduces the score for that challenge
and the operator has told us to stop buying them. Do not run `hints.py`. Solve from
evidence: page source, API responses, git history, binaries, logs, the documents in
`lanes/NETMAP.md`. If you are genuinely stuck with no path forward, write what you
have tried into REPORT.md, mark the lane DONE, and stop — the main agent decides
whether a hint is worth the points.

LANE: W29 — your chapter. Work dir: /home/kali/ctf/lanes/w29/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W29.1: The price of this planning window  (50p easy)  id=56c2c81a-d05a-4ac8-a559-d46567d77f4b  attempts=0
Use the Cairn Reach allocation export and corporate planning records to identify the replacement-supply tariff, its effective interval, and the allocation commitment for the same asset and planning window.

### W29.2: What reserve remains uncommitted  (100p medium)  id=65a91e11-7a76-41c5-a9a9-171b194e7d53  attempts=0
Select a fresh good-quality `UsableVolumeML` observation from native Cairn Reach history and reconcile it with the 12.00 ML allocation commitment to calculate the current uncommitted margin.

### W29.3: Paper truth  (100p medium)  id=5c9bf0c3-7155-429e-8356-6749e2dc6459  attempts=0
Compare corporate report `RPT-CRR-DP3-R7` with the later good-quality native usable-volume observation, calculate their signed difference, and explain what their different as-of times allow you to conclude.

-- 3 unsolved matching '^W29\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess a flag.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/w29/DONE'.
