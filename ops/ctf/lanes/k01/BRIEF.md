LANE: K01 — KeplerOps initial access.
The range box already has 'ssh rowan-dev' configured (user rowan, port 2222, key
~/.ssh/keplerops-foothold). Non-interactive:
  /home/kali/ctf/box.py 'ssh -o BatchMode=yes rowan-dev "cmd"'
scp through the same key for tools. The range box's sudo does NOT apply on rowan-dev;
find credentials on the workstation itself.

Challenges (Chapter 1 — the workstation is yours):
- K01.1 "The developer left a way back": recover the developer's usable repository
  access (git credentials/tokens on the workstation) and retrieve the current project
  handover from the FieldKest repositories.
- K01.2 "The tab that survived": recover the unfinished ARWC support ticket retained
  by the closed browser (Firefox profile in ~/.mozilla: session restore, form history,
  places.sqlite, logins.json, recovery.jsonlz4).
- K01.3 "Outside the working folder": a release review is missing from the checkout;
  find its staff work-board record and recover the attached review plus unresolved
  comments (an internal work-board service reachable from the workstation).
- K01.4 "Put it on the workbench": the local FieldKest helper has an unfinished
  support-report job — make it produce a fresh inspection summary from the developer's
  supplied sample with that sample's asset and revision correctly represented.

SECOND OBJECTIVE, equally important: map how KeplerOps and the ARWC side are reached
from rowan-dev — network interfaces, /etc/hosts, ssh configs and keys, internal web
apps, credentials, VPN, tunnels, docker. The remaining ~28 K chapters and 35 W chapters
depend on that map. Write it all to NETMAP.md in your lane dir with exact hosts, ports,
URLs, credentials and how to pivot from the range box.
Keep long-running tunnels/listeners alive with tmux on the range box (see playbook).
