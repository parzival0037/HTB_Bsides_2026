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

LANE: K29 — your chapter. Work dir: /home/kali/ctf/lanes/k29/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### K29.1: The build record's principal  (100p medium)  id=59339a99-3f9d-4ef3-8ae5-fb01b5e159d3  attempts=0
Recover the limited release principal behind the protected build dossier and establish what it can actually access.

### K29.2: The signer in the history  (200p hard)  id=c25eb504-be97-4a82-a427-ca81c2bed2e8  attempts=0
Recover usable signing authority for the accepted release lineage from the protected source history and release records.

### K29.3: Signed, compatible, consumed  (200p hard)  id=37a40108-3ebb-4818-8d92-906ad0fd84d7  attempts=0
Deliver one signed support release that carries Cinder's change for ARWC while preserving the unrelated reference customer's behavior. Both the current and retained supported connector interfaces must continue to accept the release.

### K29.4: After the old key expires  (400p expert)  id=2fb60db9-11da-4fc2-9441-d7211863fe14  attempts=0
Carry your delivery capability through the disclosed release-credential rollover. Make the replacement release work after the old credential stops being accepted.

-- 4 unsolved matching '^K29\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/k29/REPORT.md, then 'touch /home/kali/ctf/lanes/k29/DONE'.
