You are writing ONE chapter of a teaching textbook built from a real CTF.

Goal: a reader who can only run `curl` should finish your chapter able to (a) explain the
bug class, (b) recognise it in an unfamiliar app, (c) test for it safely, (d) exploit it,
and (e) say how to fix it.

SOURCES you must read first:
- /home/kali/ctf/wu_data.json          — every solved card: description, hints, evidence snippets
- /tmp/htb_repo/writeups/*.md          — per-card write-ups (use as case studies, cite by code)
- /home/kali/ctf/lanes/NETMAP.md       — infrastructure
- /home/kali/ctf/ARWC-FINDINGS.md      — the ARWC/OT side
- /tmp/htb_repo/docs/00-start-here.md  — tone and level: teach the loop, explain why

CHAPTER FORMAT (markdown, GitHub-flavoured):
1. **What this class of bug is** — one paragraph, plain language, then the precise definition.
2. **Why it exists** — the developer's mistaken assumption. This is the most important
   section: every bug class is a wrong assumption, name it.
3. **How to spot it** — concrete signals: parameters that look like paths/ids/roles,
   response differences, wording in pages, header shapes. Bullet list.
4. **How to test it** — small, safe, ordered commands (`curl`, `jq`, `git`, `openssl`).
   Explain what each response tells you. Use placeholders, not real hosts.
5. **Case study from this range** — one or two cards, with the real request and result from
   the evidence, and a link `../writeups/<CODE>.md`. Explain the reasoning, not just steps.
6. **Variations and near-misses** — how the same bug appears slightly differently, and what
   does NOT count as the bug (avoid false positives).
7. **How to fix it** — the concrete correct implementation, in 3-6 bullets.
8. **Exercises** — 2-3 tasks the reader can do to prove they understood (build it locally,
   spot it in a snippet, or predict a response).

RULES:
- 150-250 lines. Dense, no filler, no "in this section we will".
- Never invent facts about the CTF: only what is in the sources. Generic teaching examples
  are fine but must be clearly generic (use `target:8080`, `example.test`).
- No personal data, no leaderboard names.
- Write the file to /tmp/htb_repo/docs/10-textbook/<name>.md exactly as specified in your task.
- Finish with `touch <yourdir>/DONE`.

TASK: write these two chapters:
- /tmp/htb_repo/docs/10-textbook/10-llm-applications.md — assistant apps as attack surface: workspace/system prompts, retrieval contexts, conversation retention, cross-tenant context, prompt injection and why it becomes an action. Case studies: K21.1-3, K22.x, K23.x.
- /tmp/htb_repo/docs/10-textbook/11-ot-and-scada.md — registers and engineering units, measurement vs setpoint, status-word bits, permissives, bounded actuation, historian correlation, report-vs-observation. Case studies: T04.1-4, W17.x, W19.x.
