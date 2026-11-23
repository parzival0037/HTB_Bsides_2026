You are writing per-challenge CTF write-ups for a public GitHub repo.

READ FIRST, in this order:
1. /home/kali/ctf/wu_template.md   — the exact file template and hard rules. Follow it.
2. /tmp/htb_repo/writeups/K19.2.md — a finished example. Match its depth and tone.
3. /home/kali/ctf/wu_data.json     — the ONLY source of facts. Each entry has: code, title,
   desc, hints (unlocked hint text), flag, flag_src, who, evidence (verbatim snippets from
   lane reports, scripts and captured output for that card).
4. /home/kali/ctf/lanes/NETMAP.md and /home/kali/ctf/ARWC-FINDINGS.md — infrastructure
   context (hosts, ports, credentials, service routes).

YOUR CARDS (20): write ONE file per card at /tmp/htb_repo/writeups/<CODE>.md

- **K06.1 — House credentials** (2. KeplerOps, 100p, medium, solved by team agent)
  The delivery team removed its local npm configuration from the current source tree. Recover usable publishing authority from the retained native history and establish its limits.
- **K06.2 — A private package in the wrong view** (2. KeplerOps, 100p, medium, solved by team agent)
  Your publishing account cannot read the private support package. Investigate the independent package-check build and recover the distinct CI identity that can.
- **K06.3 — The rehearsal consumer** (2. KeplerOps, 100p, medium, solved by team agent)
  Publish a compatible connector package under the authority you recovered, then make the isolated rehearsal consumer run its actual code and return your changed result.
- **K07.3 — The protected inspection** (2. KeplerOps, 400p, expert, solved by team agent)
  Use the framing capability to perform the inspector's protected package action and recover its restricted assessment.
- **K08.1 — The old entitlement** (2. KeplerOps, 100p, medium, solved by team agent)
  FieldKest still recognizes an old entitlement format. Recover its protected compatibility record and determine what the checker considers an entitlement.
- **K09.1 — A runner tells on itself** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K09.2 — The artifact without a link** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K09.3 — A job input with reach** (2. KeplerOps, 100p, medium, solved by pi lane K09)
  
- **K09.4 — Run in the runner** (2. KeplerOps, 100p, medium, solved by pi lane K09)
  Use the review job to retrieve Build Operations' private runner note and verify the build-record connection it describes.
- **K10.1 — Whose preview is this** (2. KeplerOps, 100p, medium, solved by me (manual))
  Recover the restricted preview association for the supplied support attachment. Establish which document identity the viewer believes it is presenting.
- **K10.2 — Two inputs, one identity** (2. KeplerOps, 100p, medium, solved by team agent)
  Find distinct preview inputs that the viewer treats as the same protected document identity. Demonstrate the ambiguity with the supplied rehearsal documents.
- **K10.3 — The other document's contents** (2. KeplerOps, 200p, hard, solved by team agent)
  Deliver a crafted support document that crosses the viewer's intended isolation boundary and recovers the protected preview content.
- **K11.1 — Where the policy begins** (2. KeplerOps, 100p, medium, solved by team agent)
  Recover the policy program embedded in the retained rules compiler and identify the input it actually evaluates.
- **K11.3 — The rule behind the rule** (2. KeplerOps, 200p, hard, solved by team agent)
  Recover the complete acceptance conditions enforced by the embedded policy program. Account for the constraints the ordinary documentation omits.
- **K12.1 — The reviewer arrives second** (2. KeplerOps, 200p, hard, solved by team agent)
  Place your controlled preview content in the privileged reviewer's effective workflow despite the account and review-state boundaries.
- **K12.2 — A value across the action boundary** (2. KeplerOps, 400p, expert, solved by team agent)
  Recover the protected browser value required for a privileged preview action and make that separate action accept it.
- **K13.1 — The listing nobody closed** (2. KeplerOps, 50p, easy, solved by pi lane K13)
  
- **K13.2 — Before the correction** (2. KeplerOps, 50p, easy, solved by pi lane K13)
  
- **K13.3 — The export next door** (2. KeplerOps, 50p, easy, solved by pi lane K13)
  
- **K13.4 — What the workload can do** (2. KeplerOps, 100p, medium, solved by pi lane K13)
  Establish the limited workload identity available from this workspace and recover the protected record within its actual scope.

RULES (non-negotiable):
- Use only facts present in wu_data.json for that card plus NETMAP/ARWC-FINDINGS. Do not
  invent endpoints, hosts, credentials, responses or flags.
- If `who` is "team agent" or evidence is thin, write Objective/Background properly and in
  "Notes and dead ends" state clearly that the technique is reconstructed from the
  challenge description, not observed. Never fabricate a command transcript.
- If `flag` is empty write "accepted, value not recorded". Never invent a flag value.
- 60-120 lines per file, GitHub-flavoured markdown, real fenced code blocks.
- Teach the vulnerability class in "Why this works" — that section is the point of the repo.
- Do not touch any file outside /tmp/htb_repo/writeups/.

When done, write /home/kali/ctf/wu_agents/D/DONE listing the files you created.
