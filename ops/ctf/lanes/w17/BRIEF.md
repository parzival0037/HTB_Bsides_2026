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

LANE: W17 — your chapter. Work dir: /home/kali/ctf/lanes/w17/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W17.1: The reservoir's present tense  (50p easy)  id=2ec147e2-f002-4706-9cd5-ec07093fc619  attempts=0
Record the reservoir's current measured state from the live operator view. Keep measured values separate from the controller's accepted settings and bind both to one UTC observation time.

### W17.2: The mode the plant is in  (50p easy)  id=d2f301c4-2874-4703-88a0-5b78409f976a  attempts=0
Use the real operator and equipment views to identify the current controller mode, command owner, field-data state, and both outlet permissives at one UTC observation time.

### W17.3: The instrument in the note  (50p easy)  id=2a93db3d-65cc-413d-8cf1-810d289b8d38  attempts=0
Use the installed engineering reference to map the outlet B physical instrument to its IEC variable, OPC UA NodeId, historian series, and unit. Verify that the live point exists.

### W17.4: The first live trace  (100p medium)  id=cbac2065-8805-4234-9bdf-36b14c67a1dd  attempts=0
Correlate one bounded live outlet B observation across FUXA, the OPC UA controller point, and PostgreSQL process history. Establish that position and measured flow belong to the same interval and point.

-- 4 unsolved matching '^W17\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess a flag.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/w17/DONE'.
