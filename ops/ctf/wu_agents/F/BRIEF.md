You are writing per-challenge CTF write-ups for a public GitHub repo.

READ FIRST, in this order:
1. /home/kali/ctf/wu_template.md   — the exact file template and hard rules. Follow it.
2. /tmp/htb_repo/writeups/K19.2.md — a finished example. Match its depth and tone.
3. /home/kali/ctf/wu_data.json     — the ONLY source of facts. Each entry has: code, title,
   desc, hints (unlocked hint text), flag, flag_src, who, evidence (verbatim snippets from
   lane reports, scripts and captured output for that card).
4. /home/kali/ctf/lanes/NETMAP.md and /home/kali/ctf/ARWC-FINDINGS.md — infrastructure
   context (hosts, ports, credentials, service routes).

YOUR CARDS (9): write ONE file per card at /tmp/htb_repo/writeups/<CODE>.md

- **K31.1 — Whose maintenance job** (2. KeplerOps, 100p, medium, solved by team agent)
  Recover the scheduler's maintenance policy and establish which identity its different operations actually evaluate.
- **K24.1 — Complete the job** (2. KeplerOps, 50p, easy, solved by pi lane K23)
  
- **K27.1 — A job for that customer** (2. KeplerOps, 100p, medium, solved by team agent)
  Bind a support diagnostic job to the active ARWC connector despite the support account's ordinary customer restrictions.
- **K27.2 — Our diagnostic, their interface** (2. KeplerOps, 100p, medium, solved by team agent)
  Alter the diagnostic package while preserving the interface the ARWC connector expects. Make the job accept the changed package for this customer.
- **K27.3 — The other side of support** (2. KeplerOps, 100p, medium, solved by team agent)
  Deliver the changed diagnostic through the support workflow and demonstrate its execution inside ARWC's corporate connector.
- **K28.1 — A connector with two faces** (2. KeplerOps, 100p, medium, solved by team agent)
  Determine when the archived connector behaves differently from its ordinary interface and recover the diagnostic evidence for that difference.
- **K29.1 — The build record's principal** (2. KeplerOps, 100p, medium, solved by team agent)
  Recover the limited release principal behind the protected build dossier and establish what it can actually access.
- **K29.2 — The signer in the history** (2. KeplerOps, 200p, hard, solved by team agent)
  Recover usable signing authority for the accepted release lineage from the protected source history and release records.
- **K29.4 — After the old key expires** (2. KeplerOps, 400p, expert, solved by me (manual))
  Carry your delivery capability through the disclosed release-credential rollover. Make the replacement release work after the old credential stops being accepted.

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

When done, write /home/kali/ctf/wu_agents/F/DONE listing the files you created.
