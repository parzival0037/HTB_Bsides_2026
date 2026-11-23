# Start here — learn to do this yourself

This repo documents a CTF that was largely executed by AI agents under human direction.
That is worth saying plainly, because **reading an AI's output is not the same as learning
the skill**, and the goal of this page is to close that gap.

If all you can do today is `curl` a URL and read the reply, that is genuinely enough to
start. Four of the challenges in this range are solvable with exactly that skill. This
page teaches the loop, the tools, and then walks you through real challenges at that level
so you can build up.

---

## 1. The loop you repeat for every challenge

Everything in this repo is an application of one loop. Learn the loop and the specific
tools stop mattering.

```
read  →  enumerate  →  hypothesise  →  test  →  verify  →  write it down
```

| Step | What it means in practice | What it looks like |
|---|---|---|
| **Read** | The challenge text tells you the target and often the bug class. The target's front page tells you what it *thinks* it is. | `curl -s http://target:8080/` |
| **Enumerate** | List what exists: paths, parameters, files, versions, users, responses. Never assume; get evidence. | `curl -s -i`, `git log`, `robots.txt`, error messages |
| **Hypothesise** | Form one sentence: "if the server does X, then sending Y should Z". | "If `view` is joined to a path, `..` should escape it." |
| **Test** | Smallest request that can prove/disprove the sentence. | one `curl` with one changed parameter |
| **Verify** | Confirm what you got is what you think (status code, length, field). | `jq`, `sha256sum`, diff two responses |
| **Write it down** | Record the request that worked. This is the write-up, and it is how you stop re-learning. | `notes.md` |

The thing that separates people who "can do CTFs" from people who can't is not tool
knowledge. It is running this loop deliberately instead of clicking around.

---

## 2. The only tools you need to start

Four commands. Learn these before touching anything else.

### `curl` — talk to HTTP by hand

```bash
curl -s http://target:8080/                 # body only
curl -s -i http://target:8080/              # include response headers
curl -s -o /dev/null -w '%{http_code}\n' URL   # just the status code
curl -s -X POST -H 'Content-Type: application/json' -d '{"a":1}' URL
curl -s -b cookies.txt -c cookies.txt URL   # keep a session
```

Why it matters: `curl -i` shows you the status line, `Server:` header, `Content-Type`
and length. **Status codes and lengths are data.** An endpoint that answers `404` for
unknown users and `200` for real ones has just told you its user list.

### `jq` — read JSON without drowning

```bash
curl -s URL | jq .                 # pretty print
curl -s URL | jq 'keys'            # what fields exist
curl -s URL | jq '.hints[]?.text'  # one field
```

### `git` — history is data

```bash
git log --oneline --all            # every commit, including "deleted" work
git show <commit>:path/to/file     # file as it was in that commit
git log --diff-filter=D --name-only  # files that were deleted
```

A "cleaned up" repository almost always still contains the thing that was cleaned up.

### `grep` / `sort -u` — reduce output to signal

```bash
curl -s URL | grep -oE 'FLAG\{[0-9a-f]{16}\}'
curl -s URL | grep -oE 'href="[^"]*"' | sort -u
```

---

## 3. Worked example — the training desk, by hand

The first four challenges in this range are one desk (`workbench.training:8080`). Here is
the whole thing at beginner level, with the reasoning spelled out. Reproduce it in order;
each step is one command and one sentence of thought.

### 3.1 Read the front page

```bash
curl -s http://workbench.training:8080/
```

It is markdown that lists a handover git repo, a delivery tracker CSV, a dispatch desk on
`:8081`, a retired courier client profile, and a diagnostics helper on `:8083`.

**Thought:** this page is a menu. Everything on it is fair game, and the phrasing tells
you what each artefact is for.

### 3.2 Pull the repositority and look at history, not just files

```bash
git clone http://workbench.training:8080/git/handover.git /tmp/handover
cd /tmp/handover && git log --oneline --stat --all
```

Output shows two commits: `record courier handover` and a later `leave blank handover
template`. The current `handover.md` is a blank template.

**Thought:** "blank replacement" means the previous content is still in the object
database. Read it:

```bash
git show <first-commit>:handover.md
```

There is the first flag. This is the entire idea behind *"deleted content in version
control"* — a class of leak that appears in real engagements constantly.

### 3.3 Notice what the desk itself withholds

```bash
curl -s -i http://workbench.training:8081/
```

```text
# Dispatch desk
The current navigation contains the [public delivery notice](notice-DL-204.md).
The prior rehearsal page was withdrawn from the menu during cleanup. Static
client metadata is still published for offline desk clients.
```

**Thought:** "withdrawn from the menu" ≠ "removed". The text is telling you the page still
exists. Guess its name from the sentence (`rehearsal`, `notice-DL-204`) and fetch it. That
is the second flag: *navigation is not authorisation*.

### 3.4 Read the published client metadata for credentials

```bash
curl -s http://workbench.training:8080/retired-client/profile.json
```

```json
{
  "courier_id": "CR-17",
  "api_base": "http://workbench.training:8082",
  "authorization": "Bearer courier_DL204_CR17_4N7Q2M9K",
  "scope": ["manifest:DL-204:read"]
}
```

**Thought:** this is a *credential with a scope*. The scope says `manifest:DL-204:read`.
Use it exactly there:

```bash
curl -s -H 'Authorization: Bearer courier_DL204_CR17_4N7Q2M9K' \
     http://workbench.training:8082/deliveries/DL-204/manifest
```

Third flag. This shape — a client profile or config file that leaks a scoped token — is
one of the most common real-world findings there is.

### 3.5 Follow the hint about a render helper

The front page also links:

```
http://workbench.training:8083/api/diagnostics/render?delivery_id=DL-204&view=public/DL-204.json
```

Fetch it, note the ordinary response. Then ask the question the challenge asks: *what does
this helper do with `view`?* Likely `open(BASE + view)`. So:

```bash
curl -s 'http://workbench.training:8083/api/diagnostics/render?delivery_id=DL-204&view=public/../internal/DL-204.json'
```

That is **path traversal**: the parameter is joined to a directory with no
canonicalisation, so `..` walks out. The internal document contains the fourth flag.

**Why the naive attempts failed:** sending `../internal/...` directly was rejected with
`400 invalid_request`, because that check happens on the *prefix*. Putting a legitimate
prefix first (`public/../`) satisfies it and still escapes. This is the single best lesson
on this desk: filters that validate shape rather than meaning are everywhere.

---

## 4. What each of those four taught

| Challenge | Bug class | Transferable idea |
|---|---|---|
| The copy nobody deleted | data in git history | deleting a file does not delete its objects |
| Off the menu | hidden-but-published page | the UI's navigation is not an access control |
| A token with a job | credential in published metadata | client configs leak scoped tokens; scope tells you where to use them |
| The helper has another job | path traversal | parameters joined to paths need canonicalisation, and prefix checks are bypassable |

If you can do those four by hand and explain *why* each worked, you have the foundation
for the KeplerOps chapters — they are the same skills on a much larger estate.

---

## 5. Honest notes about this repo

- **Authorship:** the operator drove the tools and made the decisions; a fleet of AI
  agents executed most of the enumeration and exploitation, and drafted most of the
  prose in `writeups/`. The diagrams, the network map and the training-desk walkthrough
  above are reviewed against captured output.
- **Reconstruction:** some per-challenge files describe cards that were closed by another
  agent whose working notes we don't have. Those files say so in "Notes and dead ends"
  and mark the technique as reconstructed. Treat them as "this is how the bug class
  works", not as a transcript.
- **Flags:** values are included where they were captured. Where they weren't, the file
  says "accepted, value not recorded" rather than inventing one.
- **Credentials:** every credential here existed only inside the exercise range, which was
  destroyed. They are for study, not reuse.

## 6. Suggested next steps for you

1. Redo section 3 from scratch without looking, on a local HTTP server you build yourself
   (`python3 -m http.server` plus a tiny Flask app is enough to recreate the patterns).
2. Pick one KeplerOps chapter whose write-up you find readable (K19 is the cleanest chain:
   directory → enrolment → mTLS → delegation) and follow it command by command, predicting
   each response before you run it.
3. Keep a `notes.md` per chapter with the loop from section 1 written out. The habit is the
   skill.
