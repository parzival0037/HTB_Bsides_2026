You are writing per-challenge CTF write-ups for a public GitHub repo.

READ FIRST, in this order:
1. /home/kali/ctf/wu_template.md   — the exact file template and hard rules. Follow it.
2. /tmp/htb_repo/writeups/K19.2.md — a finished example. Match its depth and tone.
3. /home/kali/ctf/wu_data.json     — the ONLY source of facts. Each entry has: code, title,
   desc, hints (unlocked hint text), flag, flag_src, who, evidence (verbatim snippets from
   lane reports, scripts and captured output for that card).
4. /home/kali/ctf/lanes/NETMAP.md and /home/kali/ctf/ARWC-FINDINGS.md — infrastructure
   context (hosts, ports, credentials, service routes).

YOUR CARDS (11): write ONE file per card at /tmp/htb_repo/writeups/<CODE>.md

- **W01.1 — The customer's copy** (3. ARWC, 50p, easy, solved by pi lane W01D)
  Recover the retained customer handover and identify the maintenance case attached to the accepted FieldLink delivery.
- **W01.2 — The planner's unfinished handover** (3. ARWC, 50p, easy, solved by team agent)
  Find the planning handover retained with the supplier documents. Identify the outstanding inspection and its planning assignee.
- **W01.3 — How the company buys time** (3. ARWC, 50p, easy, solved by team agent)
  Determine how ARWC handles a dry-period shortfall and which purchasing records govern supplementary water.
- **W02.1 — The asset and the contractor** (3. ARWC, 50p, easy, solved by team agent)
  Identify the asset and contractor associated with the outlet inspection order.
- **W02.2 — Three names for one job** (3. ARWC, 100p, medium, solved by team agent)
  Reconcile the internal work order, supplier job and engineering drawing that refer to the same outlet inspection.
- **W03.1 — An annex left with the order** (3. ARWC, 50p, easy, solved by pi lane W03B)
  Recover the work-order annex retained with the supplier order and identify its engineering drawing reference.
- **W03.3 — The integration's read contract** (3. ARWC, 100p, medium, solved by team agent)
  Establish what the approved planning read service actually publishes and what remains outside its boundary.
- **W13.1 — Window on Thursday** (3. ARWC, 50p, easy, solved by team agent)
  Recover the upcoming outlet-inspection appointment and its maintenance reference.
- **W14.1 — The field bag** (3. ARWC, 50p, easy, solved by team agent)
  Recover the inspection's field export from the contractor workspace.
- **W19.1 — The diagnostic nobody retired** (3. ARWC, 100p, medium, solved by team agent)
  Recover the retained engineering diagnostic associated with the outlet records and identify its actual project family.
- **W31.1 — The vault's misleading length** (3. ARWC, 100p, medium, solved by team agent)
  Recover the diagnostic vault's actual record-boundary behavior and the protected diagnostic reference associated with the supplied case.

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

When done, write /home/kali/ctf/wu_agents/G/DONE listing the files you created.
