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

LANE: K18 — your chapter. Work dir: /home/kali/ctf/lanes/k18/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### K18.1: The note behind the preview  (100p medium)  id=0924f3c9-291f-448c-8171-510c883c40c2  attempts=0
Recover the restricted support-note draft and establish which identity workflow consumes its preview.

### K18.2: A note with someone else's authority  (200p hard)  id=c4732211-022b-44aa-9c03-fc8a7800da59  attempts=0
Make the privileged note reviewer open the identity-provider administration view and recover its restricted support-application registration record.

### K18.3: The provider trusts our change  (200p hard)  id=d68096eb-1741-45c7-a1b6-aa69312a6d07  attempts=0
Change the federation policy for the support application's identity-provider registration so your controlled provider is accepted, while preserving the existing staff login relationship.

### K18.4: The query behind the identity  (400p expert)  id=23eda69c-95e1-4579-98c9-d97760c123a9  attempts=0
Use the changed trust relationship to recover the backend customer record withheld from ordinary support identities.

-- 4 unsolved matching '^K18\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/k18/REPORT.md, then 'touch /home/kali/ctf/lanes/k18/DONE'.
