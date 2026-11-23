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

LANE: K02 — your chapter. Work dir: /home/kali/ctf/lanes/k02/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### K02.1: The missing fixture  (50p easy)  id=ae4161b7-9e2c-4982-b5e1-40768dff089f  attempts=0
The report test has been failing since its reference fixture disappeared. Recover the fixture from the development artifacts so the intended report is visible again.

### K02.2: An input outside its lane  (50p easy)  id=88ffd9d1-91b5-47e9-96f1-09995f5478fa  attempts=0
The report build failed, but it retained a review note separate from the console log. Recover that note and establish the input contract for submitting a corrected report provider.

### K02.3: Green, with our changes  (100p medium)  id=4cc30e18-52a8-4c06-9827-e4256d24719a  attempts=0
Change the report produced by the test job while keeping the interface its caller expects. The support engineer should receive Cinder's version with a successful job result.

-- 3 unsolved matching '^K02\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/k02/DONE'.
