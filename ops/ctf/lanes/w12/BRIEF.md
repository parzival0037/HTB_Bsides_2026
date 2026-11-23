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

LANE: W12 — your chapter. Work dir: /home/kali/ctf/lanes/w12/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W12.1: A collector in quarantine  (100p medium)  id=3244b24a-3c9d-426d-adbc-dfe571b7fa61  attempts=0
Recover the historical collector associated with the archive lead and restore it as a usable analysis artifact.

### W12.2: How the collection was protected  (200p hard)  id=bd74ede1-31cc-45a5-b49a-5a197c8ea5ee  attempts=0
Reconstruct the collector's cryptographic behavior well enough to reproduce its handling of the supplied archive samples.

### W12.3: The cold archive opens  (200p hard)  id=12b0cedb-7ecb-487a-95a4-f30e1de5b363  attempts=0
Recover the protected archive and the maintenance history it contains.

### W12.4: A collection path still alive  (400p expert)  id=83ba5818-e04f-46af-b0b1-0569091ec550  attempts=0
Reconstruct the surviving collection relationship and obtain the current protected data associated with the archived maintenance identity.

-- 4 unsolved matching '^W12\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/w12/REPORT.md, then 'touch /home/kali/ctf/lanes/w12/DONE'.
