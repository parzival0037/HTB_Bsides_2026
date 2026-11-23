// wave 1: three training desks + KeplerOps foothold
const common = `
You are solving part of an authorized CTF (BSides CTF 2026, team MoTM). Read
/home/kali/ctf/PLAYBOOK.md first — it defines range-box access (box.py), the network
map, submission (submit.py), and the rules. Follow it exactly.

Key operational facts:
- All target traffic must be run FROM the range box: /home/kali/ctf/box.py 'cmd'
  or /home/kali/ctf/box.py -f <local script>. Each call is a fresh SSH session (~8s),
  so batch aggressively into one script and prefer -f.
- Box has passwordless sudo and internet; install tools there.
- Work only inside your lane dir: /home/kali/ctf/lanes/<your lane>/
- Submit flags with /home/kali/ctf/submit.py '<challenge name prefix>' 'FLAG{...}'.
  Attempts are limited: never guess. Only submit when the flag is clearly the answer
  to that challenge's description.
- /home/kali/ctf/brief.py prints unsolved challenge descriptions/hints.
- When you finish or hit a hard wall, report: flags submitted + which challenge each
  solved, service/endpoint map you discovered, credentials found, the exact technique
  that worked, dead ends, and anything the next stage depends on. Be concrete.
`;

return await runs.all([
  {
    key: "t02",
    label: "Solve accounts.training desk",
    agent: "worker",
    task: common + `
LANE: T02 — identity desk. Work dir /home/kali/ctf/lanes/t02/
Target: http://accounts.training:8080/ (10.77.40.30) plus whatever it points to.

Challenges (in order, prerequisite chain):
- T02.1 "An account by any other response": identify the active rehearsal account and
  recover the account-bound case reference the identity desk exposes. The wording
  hints at response differences (status/length/headers) between valid and invalid
  accounts — enumerate users and read responses.
- T02.2 "Hidden on the page": the public directory UI hides rehearsal entries; the
  directory API does not apply the same filter. Fetch the API directly.
- T02.3 "Recovery is another way in": use the recovered identity evidence to take over
  the rehearsal account through its password-recovery workflow, then read its private
  handover.
- T02.4 "Someone else's assignment": from the recovered account, use the assignment
  service to obtain another operator's sealed rehearsal brief (object-level access
  control failure).

Method: read the front page, its page source (curl the HTML), any linked JS, robots,
API paths. Enumerate. Keep a notes.md in your lane dir.`
  },
  {
    key: "t03",
    label: "Solve developer.training desk",
    agent: "worker",
    task: common + `
LANE: T03 — developer artifacts desk. Work dir /home/kali/ctf/lanes/t03/
Target: http://developer.training:8080/ (10.77.40.40) plus what it links.

Challenges:
- T03.1 "Deleted from the checkout": a delivery fixture named in a review note is
  missing at its documented path; recover it from the checkout's version-control
  history (deleted content). Flag is presumably derivable from the recovered fixture
  or the behavior it covered.
- T03.3 "What installation really runs": inspect the supplied package WITHOUT
  installing it; recover the extra action installation would trigger, the data
  involved and its destination (install hooks / setup.py / postinstall).
- T03.4 "A release they will consume": deliver a compatible formatter package that
  adds Cinder's rehearsal marker to the intended consumer's delivery report — i.e.
  build the package against the interface the desk documents and submit/upload it to
  the consumer the desk names, then read the resulting report.

Note T03.2 is already solved; don't redo it. Read the desk front page and source
carefully, clone/download the artifacts, and study the consumer contract docs.`
  },
  {
    key: "t04",
    label: "Solve state.training outlet desk",
    agent: "worker",
    task: common + `
LANE: T04 — outlet / SCADA desk. Work dir /home/kali/ctf/lanes/t04/
Target: http://state.training:8080/ (10.77.40.50) plus its services/APIs.

Challenges:
- T04.1 "Which value is real": read the supplied training-tank observation and work
  out how much water it actually contains — separate the measurement from the
  requested/setpoint level. (Register/word interpretation, scaling, engineering units.)
- T04.2 "The light behind the number": decode the supplied controller status capture
  and identify the condition preventing the practice outlet from moving (bit/flag in a
  status word).
- T04.3 "A request is not a movement": actually move the specified bounded amount of
  water through the training outlet, then verify the transfer from the tank's
  observations. This requires writing to the outlet control, respecting bounds.
- T04.4 "Yesterday's green light": the report claims the latest outlet test succeeded
  but observations disagree — reconstruct what really happened from the evidence
  (timestamps, logs, values) and explain the discrepancy.

Be careful: this desk models physical process control. Respect the stated bounds when
actuating; verify before and after.`
  },
  {
    key: "k01",
    label: "KeplerOps foothold via rowan-dev",
    agent: "worker",
    task: common + `
LANE: K01 — KeplerOps initial access. Work dir /home/kali/ctf/lanes/k01/
The range box already has 'ssh rowan-dev' configured (user rowan, port 2222, key
~/.ssh/keplerops-foothold). Non-interactive: /home/kali/ctf/box.py 'ssh -o BatchMode=yes rowan-dev "cmd"'.
You can also copy tools over with scp through the same key. The box's sudo does NOT
apply on rowan-dev; find credentials on the workstation.

Challenges (Chapter 1 — the workstation is yours):
- K01.1 "The developer left a way back": recover the developer's usable repository
  access (git credentials/tokens on the workstation) and retrieve the current project
  handover from the FieldKest repositories.
- K01.2 "The tab that survived": recover the unfinished ARWC support ticket retained
  by the closed browser (Firefox profile: ~/.mozilla, session restore, form history,
  places.sqlite, logins.json).
- K01.3 "Outside the working folder": a release review is missing from the checkout;
  find its staff work-board record and recover the attached review plus unresolved
  comments (some internal work-board service reachable from the workstation).
- K01.4 "Put it on the workbench": the local FieldKest helper has an unfinished
  support-report job — make it produce a fresh inspection summary from the developer's
  supplied sample with the correct asset and revision.

IMPORTANT second objective: map how KeplerOps and the ARWC side are reached from
rowan-dev (network, /etc/hosts, ssh configs, internal web apps, credentials, VPN,
tunnels). The rest of the K and W chapters depend on that map. Record every host,
service, port, credential and app in /home/kali/ctf/lanes/k01/NETMAP.md and report it.
Keep long-running tunnels alive with tmux on the range box (see playbook).`
  }
]);
