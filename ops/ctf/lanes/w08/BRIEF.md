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

LANE: W08 — your chapter. Work dir: /home/kali/ctf/lanes/w08/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W08.1: Something in the work bundle  (100p medium)  id=ecb45a6c-90e5-41e8-9681-f1093602ba48  attempts=0
Recover the contractor's hidden script from the retained work material and identify the collection it was intended to retrieve.

### W08.2: Reassemble the exchange  (100p medium)  id=b3b0beba-396f-424f-987b-e66a0fe63458  attempts=0
Reconstruct the script's retained message exchange and recover the missing instructions that belong to this collection.

### W08.3: The collector inside the handover  (200p hard)  id=c04ff5f8-d5e1-4815-b07c-d56b0d86f1e9  attempts=0
Recover the compiled collector carried by the reconstructed exchange and establish its usable analysis artifact.

### W08.4: Where the contractor put it  (200p hard)  id=3adbe282-b327-4ba7-b05d-76cc9a66a045  attempts=0
Recover the collector's protected configuration and the historical archive reference it was using.

-- 4 unsolved matching '^W08\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/w08/REPORT.md, then 'touch /home/kali/ctf/lanes/w08/DONE'.
