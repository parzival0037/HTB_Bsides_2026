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

LANE: W18 — your chapter. Work dir: /home/kali/ctf/lanes/w18/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W18.1: The tag export  (50p easy)  id=aea45859-36ba-45cc-b6c3-ade383d3205c  attempts=0
Identify the installed Cairn Reach native I/O register and prove that its revision and digest agree with the running controller and historian catalog.

### W18.2: The scale kept elsewhere  (50p easy)  id=022e2fcf-c429-4b61-a6a4-cc70978a6cf9  attempts=0
Reconcile one outlet flow point across its Modbus register, OpenPLC address, raw type and scale, PLC value, OPC UA identity, and historian series.

### W18.3: Three clocks and a gap  (100p medium)  id=1c6b237f-7d57-485d-9514-47bac1c76524  attempts=0
Use retained native history to identify a genuine collection gap and explain it using source time, collection time, ingestion time, transport quality, process quality, and engineering unit.

### W18.4: Which outlet answers  (100p medium)  id=e4bfd5ab-a9a7-4439-b2c5-f5e3e69badce  attempts=0
Map both Cairn Reach outlet gates from native register channels to PLC values, OPC UA identities, historian series, and a time-aligned physical observation.

-- 4 unsolved matching '^W18\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess a flag.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/w18/DONE'.
