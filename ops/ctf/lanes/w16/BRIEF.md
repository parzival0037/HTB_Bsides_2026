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

LANE: W16 — your chapter. Work dir: /home/kali/ctf/lanes/w16/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### W16.1: The sequencer's vocabulary  (100p medium)  id=5ded484a-6850-42ee-818b-227f16bd782c  attempts=0
Recover the instrument's restricted sequence descriptor and reproduce the designated ordinary diagnostic observation.

### W16.2: An observation outside the window  (200p hard)  id=78a96a88-b837-4987-aae4-74592e9e5a47  attempts=0
Demonstrate a controlled observation beyond the instrument's intended data window without abandoning its diagnostic interface.

### W16.3: An experiment with a signal  (400p expert)  id=852d1295-64d4-49f0-9c38-28051e958285  attempts=0
Construct a sequencer experiment that distinguishes the specified protected conditions through its measurements. Establish an interpretation that holds across the supplied reference cases.

### W16.4: What the instrument remembers  (800p expert)  id=7009bca3-3c9a-4b2f-a3e5-60e2aacc5a9e  attempts=0
Recover the protected calibration record through the constrained instrument interface and bind it to the retained field revision.

-- 4 unsolved matching '^W16\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write /home/kali/ctf/lanes/w16/REPORT.md, then 'touch /home/kali/ctf/lanes/w16/DONE'.
