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
- Keep notes.md in your lane dir updated as you go, and write REPORT.md EARLY with
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

LANE: K11 — your chapter. Work dir: /home/kali/ctf/lanes/k11/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### K11.1: Where the policy begins  (100p medium)  id=b801afa2-2f44-487f-a0d1-c2b0af334df6  attempts=0
Recover the policy program embedded in the retained rules compiler and identify the input it actually evaluates.

### K11.2: Learn its instructions  (200p hard)  id=643dfe55-613f-4ec6-8b36-3350d0061946  attempts=0
Reconstruct enough of the compiler's internal instruction behavior to reproduce the supplied policy fragments.

### K11.3: The rule behind the rule  (200p hard)  id=667966b5-2cbb-4fe8-aeaa-b878e93f33ea  attempts=0
Recover the complete acceptance conditions enforced by the embedded policy program. Account for the constraints the ordinary documentation omits.

### K11.4: An input the compiler believes  (400p expert)  id=a36f95c8-d7b3-4be4-b574-7d0d7ea83f44  attempts=0
Construct a package-policy input that satisfies the recovered program while authorizing Cinder's requested compatibility case.

-- 4 unsolved matching '^K11\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/k11/DONE'.
