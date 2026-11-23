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

LANE: W15 — your chapter. Work dir: /home/kali/ctf/lanes/w15/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W15.1: Which drawing did the cache keep  (100p medium)  id=5e1989bb-be2c-430b-8237-98c826273e5e  attempts=0
Recover the restricted cache association for the maintenance drawing and identify the version the review workflow will serve.

### W15.2: A drawing of our choosing  (200p hard)  id=b1f7ee31-1845-4c60-a883-2d4dd3214dff  attempts=0
Make the maintenance viewer serve your controlled response for the designated cached drawing while preserving its expected identity.

### W15.3: The reviewer trusts the drawing  (200p hard)  id=673ae272-ecb2-4079-8d97-016d56512982  attempts=0
Use the controlled drawing delivery to obtain the reviewer's private maintenance-review submission capability.

### W15.4: Approval beyond the token  (400p expert)  id=6f2647bb-92ac-4c1b-9f9c-681dbe63eba4  attempts=0
Recover the protected maintenance approval through the downstream authority check that still restricts the review capability.

-- 4 unsolved matching '^W15\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/w15/REPORT.md, then 'touch /home/kali/ctf/lanes/w15/DONE'.
