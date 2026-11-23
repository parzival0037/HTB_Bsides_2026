You are writing per-challenge CTF write-ups for a public GitHub repo.

READ FIRST, in this order:
1. /home/kali/ctf/wu_template.md   — the exact file template and hard rules. Follow it.
2. /tmp/htb_repo/writeups/K19.2.md — a finished example. Match its depth and tone.
3. /home/kali/ctf/wu_data.json     — the ONLY source of facts. Each entry has: code, title,
   desc, hints (unlocked hint text), flag, flag_src, who, evidence (verbatim snippets from
   lane reports, scripts and captured output for that card).
4. /home/kali/ctf/lanes/NETMAP.md and /home/kali/ctf/ARWC-FINDINGS.md — infrastructure
   context (hosts, ports, credentials, service routes).

YOUR CARDS (16): write ONE file per card at /tmp/htb_repo/writeups/<CODE>.md

- **K01.1 — The developer left a way back** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K01.2 — The tab that survived** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K01.3 — Outside the working folder** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K01.4 — Put it on the workbench** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K02.1 — The missing fixture** (2. KeplerOps, 50p, easy, solved by pi lane K02)
  The report test has been failing since its reference fixture disappeared. Recover the fixture from the development artifacts so the intended report is visible again.
- **K02.2 — An input outside its lane** (2. KeplerOps, 50p, easy, solved by pi lane K02)
  The report build failed, but it retained a review note separate from the console log. Recover that note and establish the input contract for submitting a corrected report provider.
- **K02.3 — Green, with our changes** (2. KeplerOps, 100p, medium, solved by pi lane K09)
  Change the report produced by the test job while keeping the interface its caller expects. The support engineer should receive Cinder's version with a successful job result.
- **K03.1 — Our predecessor's desk** (2. KeplerOps, 100p, medium, solved by team agent)
  Someone from Cinder worked this lead before you. Recover the staging artifact buried in their retained document and identify the collection it belongs to.
- **K03.2 — The script inside the script** (2. KeplerOps, 200p, hard, solved by team agent)
  The recovered staging material conceals another stage. Reconstruct the usable script and recover the instructions needed to understand what the earlier operator collected.
- **K03.3 — Finish the callback** (2. KeplerOps, 200p, hard, solved by team agent)
  Reconstruct the earlier operation's callback configuration and recover its lost collection. Find out what it learned about the unresolved ARWC maintenance ticket.
- **K04.1 — A bundle with consequences** (2. KeplerOps, 200p, hard, solved by team agent)
  The support indexer treats uploaded bundles as routine work. Construct a bundle that causes a controlled change beyond the object it should be allowed to affect.
- **K04.2 — Read past the index** (2. KeplerOps, 400p, expert, solved by team agent)
  Use the compromised indexing behavior to recover protected runtime information that an ordinary bundle cannot see.
- **K04.3 — Control the allocation** (2. KeplerOps, 800p, expert, solved by team agent)
  The indexer still restricts what your corrupted object can influence. Establish a controlled write capability under those restrictions and demonstrate it against the designated protected state.
- **K04.4 — The exception queue** (2. KeplerOps, 800p, expert, solved by team agent)
  Turn the indexer compromise into execution under its service identity. Recover the release-exception queue the support engineer has been trying to clear.
- **K05.1 — Speak the package's language** (2. KeplerOps, 50p, easy, solved by team agent)
  
- **K05.2 — The version they kept** (2. KeplerOps, 50p, easy, solved by team agent)
  

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

When done, write /home/kali/ctf/wu_agents/C/DONE listing the files you created.
