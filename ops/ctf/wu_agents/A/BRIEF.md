You are writing per-challenge CTF write-ups for a public GitHub repo.

READ FIRST, in this order:
1. /home/kali/ctf/wu_template.md   — the exact file template and hard rules. Follow it.
2. /tmp/htb_repo/writeups/K19.2.md — a finished example. Match its depth and tone.
3. /home/kali/ctf/wu_data.json     — the ONLY source of facts. Each entry has: code, title,
   desc, hints (unlocked hint text), flag, flag_src, who, evidence (verbatim snippets from
   lane reports, scripts and captured output for that card).
4. /home/kali/ctf/lanes/NETMAP.md and /home/kali/ctf/ARWC-FINDINGS.md — infrastructure
   context (hosts, ports, credentials, service routes).

YOUR CARDS (8): write ONE file per card at /tmp/htb_repo/writeups/<CODE>.md

- **T01.1 — The copy nobody deleted** (1. Training, 50p, easy, solved by team agent)
  
- **T01.2 — Off the menu** (1. Training, 50p, easy, solved by team agent)
  
- **T01.3 — A token with a job** (1. Training, 50p, easy, solved by team agent)
  
- **T01.4 — The helper has another job** (1. Training, 50p, easy, solved by me (manual))
  
- **T02.1 — An account by any other response** (1. Training, 50p, easy, solved by me (manual))
  
- **T02.2 — Hidden on the page** (1. Training, 50p, easy, solved by me (manual))
  
- **T02.3 — Recovery is another way in** (1. Training, 50p, easy, solved by me (manual))
  
- **T02.4 — Someone else's assignment** (1. Training, 100p, medium, solved by me (manual))
  

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

When done, write /home/kali/ctf/wu_agents/A/DONE listing the files you created.
