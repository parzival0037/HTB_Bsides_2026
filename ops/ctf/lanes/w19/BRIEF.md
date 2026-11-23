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

LANE: W19 — your chapter. Work dir: /home/kali/ctf/lanes/w19/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W19.1: The diagnostic nobody retired  (100p medium)  id=b12ca6b8-2ec7-401c-a298-c930825ee568  attempts=0
Recover the retained engineering diagnostic associated with the outlet records and identify its actual project family.

### W19.2: A second interpretation  (200p hard)  id=a5da997f-da43-4987-ae09-a084110f7570  attempts=0
Reconstruct the diagnostic behavior that its initial analysis view does not explain and reproduce the supplied distinguishing result.

### W19.3: The hidden check  (200p hard)  id=00a5c803-02ca-4c4a-97eb-b19f9f41c7cf  attempts=0
Recover the diagnostic's hidden validation logic well enough to reproduce its decisions on the specified engineering records.

### W19.4: A map from the old diagnostic  (400p expert)  id=1e0b1de6-56c2-4b25-80ba-b33b032729cf  attempts=0
Use the reconstructed diagnostic to recover a valid mapping of the current outlet group from the supplied observations.

-- 4 unsolved matching '^W19\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/w19/REPORT.md, then 'touch /home/kali/ctf/lanes/w19/DONE'.
