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

LANE: W25 — your chapter. Work dir: /home/kali/ctf/lanes/w25/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W25.1: The operating envelope  (50p easy)  id=2bf2ff4e-7984-4732-9ddf-368c66d19ec0  attempts=0
Read the Cairn Reach operating instruction and reconcile its bounded movement with the limits shown by the installed HMI and controller project.

### W25.2: Conditions before movement  (50p easy)  id=5e5540be-6a38-4225-a645-a3147e345cf2  attempts=0
Use FUXA and the live OpenPLC project to explain whether the Cairn Reach outlets can move now and which conditions establish that result.

### W25.3: Accepted is not actuated  (100p medium)  id=b5e7cdb0-a16f-4cae-897a-761786143bcc  attempts=0
Apply the authorized A30/B10 manual request and distinguish the staged request, PLC decision, command owner, permissives, and measured outlet response.

### W25.4: A sequence the process can follow  (100p medium)  id=240d04e4-d3e5-4839-887b-7a6a8a081f40  attempts=0
Prove the bounded movement in native process history, then apply the authorized A20/B20 restoration and verify the live site has returned to baseline.

-- 4 unsolved matching '^W25\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess a flag.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/w25/DONE'.
