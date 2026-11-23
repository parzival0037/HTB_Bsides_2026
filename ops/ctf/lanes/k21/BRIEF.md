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

LANE: K21 — your chapter. Work dir: /home/kali/ctf/lanes/k21/

Your assigned challenges (unsolved only, in order — they usually chain):
```
### K21.1: The policy beside the prompt  (50p easy)  id=16c7e7d1-c6e2-4835-96e4-aae95a03194c  attempts=0
Recover the support assistant's exposed configuration and identify the restricted support context attached to it.

### K21.2: A conversation kept too long  (50p easy)  id=7bce2c9e-263f-4b8d-aa89-99c791fb1083  attempts=0
Recover the separately retained support conversation and the unpublished case detail it contains.

### K21.3: The answer it should withhold  (100p medium)  id=ffdd3a61-0480-472c-af82-efd474109a29  attempts=0
Recover the support engineer's private escalation note about ARWC from the assistant's case context, although the assistant's ordinary support role should withhold it.

-- 3 unsolved matching '^K21\\.'
```

Submit with /home/kali/ctf/submit.py '<name>' '<flag>'. Never guess.
Finish or get blocked -> write REPORT.md, then 'touch /home/kali/ctf/lanes/k21/DONE'.
