You are writing per-challenge CTF write-ups for a public GitHub repo.

READ FIRST, in this order:
1. /home/kali/ctf/wu_template.md   — the exact file template and hard rules. Follow it.
2. /tmp/htb_repo/writeups/K19.2.md — a finished example. Match its depth and tone.
3. /home/kali/ctf/wu_data.json     — the ONLY source of facts. Each entry has: code, title,
   desc, hints (unlocked hint text), flag, flag_src, who, evidence (verbatim snippets from
   lane reports, scripts and captured output for that card).
4. /home/kali/ctf/lanes/NETMAP.md and /home/kali/ctf/ARWC-FINDINGS.md — infrastructure
   context (hosts, ports, credentials, service routes).

YOUR CARDS (18): write ONE file per card at /tmp/htb_repo/writeups/<CODE>.md

- **K14.1 — The trust document** (2. KeplerOps, 50p, easy, solved by pi lane K13)
  Recover the workload's current trust document and the service relationship it describes.
- **K14.2 — Intended for someone else** (2. KeplerOps, 100p, medium, solved by team agent)
  Use the workload trust relationship to establish the scoped role intended for another audience and retrieve its protected role record.
- **K15.1 — An export in progress** (2. KeplerOps, 50p, easy, solved by pi lane K15)
  Recover the export job that support started for its unresolved customer case. Identify the actual dataset and job revision.
- **K15.2 — A job outside your account** (2. KeplerOps, 100p, medium, solved by pi lane K15)
  Obtain the restricted export definition for the customer's job even though your identity does not own it.
- **K16.1 — Tomorrow's job** (2. KeplerOps, 50p, easy, solved by team agent)
  Recover the scheduled support workflow that will run after the current operator's shift ends.
- **K16.2 — The next startup** (2. KeplerOps, 100p, medium, solved by team agent)
  Change the scheduled workflow's startup behavior so its next rehearsal run carries Cinder's marker without breaking its support output.
- **K17.1 — A support session left behind** (2. KeplerOps, 50p, easy, solved by pi lane K25)
  
- **K17.2 — A different way to recover** (2. KeplerOps, 100p, medium, solved by team agent)
  
- **K17.3 — Which customers belong here** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K18.1 — The note behind the preview** (2. KeplerOps, 100p, medium, solved by team agent)
  Recover the restricted support-note draft and establish which identity workflow consumes its preview.
- **K19.1 — Who vouches for whom** (2. KeplerOps, 100p, medium, solved by me (manual))
  Recover the staff certificate relationship and the enrollment record relevant to the archive handover.
- **K19.3 — The archive delegates** (2. KeplerOps, 400p, expert, solved by me (manual))
  Use the colleague's archive workflow to establish the delegated authentication context needed by supplier administration.
- **K21.1 — The policy beside the prompt** (2. KeplerOps, 50p, easy, solved by pi lane K21)
  Recover the support assistant's exposed configuration and identify the restricted support context attached to it.
- **K21.2 — A conversation kept too long** (2. KeplerOps, 50p, easy, solved by pi lane K21)
  Recover the separately retained support conversation and the unpublished case detail it contains.
- **K21.3 — The answer it should withhold** (2. KeplerOps, 100p, medium, solved by pi lane K21)
  Recover the support engineer's private escalation note about ARWC from the assistant's case context, although the assistant's ordinary support role should withhold it.
- **K23.1 — A context view left open** (2. KeplerOps, 50p, easy, solved by pi lane K23)
  Recover the assistant's exposed context inventory and the unpublished support-source entry it includes.
- **K23.2 — The conversation reference** (2. KeplerOps, 50p, easy, solved by pi lane K23)
  A retained support artifact refers to a conversation outside the current case. Recover the actual reference and its customer binding.
- **K23.3 — A missing tenant boundary** (2. KeplerOps, 100p, medium, solved by pi lane K23)
  Use the exposed context and conversation evidence to recover the another customer's restricted support document.

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

When done, write /home/kali/ctf/wu_agents/E/DONE listing the files you created.
