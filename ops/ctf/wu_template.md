# Write-up template (follow exactly)

Every file is `writeups/<CODE>.md`, e.g. `writeups/K19.2.md`.

```markdown
# <CODE> — <Title>

> **Category:** <1. Training | 2. KeplerOps | 3. ARWC> · **Points:** <pts> · **Difficulty:** <diff>
> **Solved by:** <who>

## At a glance

| | |
|---|---|
| **Vulnerability / bug class** | e.g. IDOR, path traversal, credential reuse, weak delegation, git history leak |
| **Tools** | e.g. curl, git, openssl, psql, kubectl, jenkins API, custom python |
| **Attack surface** | host + endpoint(s) |
| **Prerequisite** | what you must already hold (credential, cert, session, prior flag) |
| **Flag** | `FLAG{...}` or "accepted, value not recorded" |

**What you are about to read:** two or three sentences naming the technique and why it
works, so the reader knows what they are learning before the detail starts.

## Objective

What the challenge asks for, in one paragraph, from the challenge description.

## Background you need

The minimum theory: what the service is, what the trust boundary is, what the bug class
means in general (2–6 sentences or a short bullet list). Teach, don't just narrate.

## Walkthrough

### 1. Recon
Concrete commands and their output (trimmed). What each tells you.

```bash
# example
```

### 2. Finding the flaw
How you located it, what the response looked like, why it looked wrong.

### 3. Exploitation
The actual request/script, step by step, with the reasoning between steps.

### 4. Getting the flag
Where the flag appeared (field name, response, file, log line).

## Why this works (the vulnerability explained)

The mechanism in general terms — the class of bug, what the developer forgot, what a
correct implementation would check. This is the transferable part.

## Detection and fix

How a defender would spot this (log signal, anomaly) and the concrete fix (authorization
check, path canonicalisation, scoping, etc.).

## Notes and dead ends

Anything tried that did not work, and why. If evidence was thin, say so here.
```

## Hard rules

1. **Only facts from `/home/kali/ctf/wu_data.json`** for that card (description, hints,
   evidence snippets, flag, who). Do not invent endpoints, credentials, hostnames or
   responses that are not in the evidence or in `/home/kali/ctf/lanes/NETMAP.md` /
   `ARWC-FINDINGS.md`.
2. If the evidence is thin (card was solved by another agent, `who` = `team agent`),
   write the Objective/Background/sections honestly from the description, and put the
   technique you *believe* applies in the "Why this works" section **labelled as
   reconstructed** in "Notes and dead ends". Never fabricate a command transcript.
3. Never invent a flag value. If `flag` is empty, write "accepted, value not recorded".
4. Keep to 60–120 lines. Code blocks must be real commands from the evidence or clearly
   generic templates marked as illustrative.
5. No leaderboard names, no real people, no credentials that were not in the CTF.
6. Tone: technical, direct, teaching a colleague who has never seen this challenge.
