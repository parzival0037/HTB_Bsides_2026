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

LANE: K16 — your chapter. Work dir: /home/kali/ctf/lanes/k16/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### K16.1: Tomorrow's job  (50p easy)  id=539bbb05-4e00-48ea-9e8f-e80d780a54c6  attempts=0
Recover the scheduled support workflow that will run after the current operator's shift ends.

### K16.2: The next startup  (100p medium)  id=9cc16f46-b54b-4208-9485-c4b85de2670e  attempts=0
Change the scheduled workflow's startup behavior so its next rehearsal run carries Cinder's marker without breaking its support output.

### K16.3: Beyond the current session  (100p medium)  id=2ae986f4-2bcf-420f-ab99-836e5e3eb4f3  attempts=0
Establish the separate execution context needed for the scheduled task to act after your current support session ends.

### K16.4: Still there after the handover  (100p medium)  id=f40b3d99-0c2b-4f5c-bb8f-d34c686f330b  attempts=0
Carry the altered workflow through the supplied shift transition and make it run successfully under the new assignment.

-- 4 unsolved matching '^K16\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess a flag.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/k16/DONE'.
