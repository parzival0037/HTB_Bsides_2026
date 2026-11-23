# 05 — Git and artifacts: history is a data source

## 1. What this class of bug is

A team deletes a file, blanks a document, or stops linking an output, and believes the
data is gone. It is not: version control keeps every committed byte, and build systems keep
logs, workspaces and retained artefacts long after the current page stops mentioning them.
The current tree and the current results page are *views*, not the store.

**Precise definition:** data whose access-control lifecycle has ended — deleted, redacted,
superseded, unlisted — remains addressable by identity (blob SHA, commit, `ref`, artefact
name, run id) through an interface that checks *can you name it*, not *are you entitled to
this revision*. Two families share the shape:

| Family | What persists | Addressable by |
|---|---|---|
| Version history | every blob reachable from any commit, branch, tag, reflog or dangling object | `commit:path`, `?ref=<sha>`, `git show`, `fsck` |
| Build artefacts | console logs, expected-value dumps, workspace zips, run directories, retention stores | run id + artefact name, `/consoleText`, `/artifact/…` |

## 2. Why it exists

The developer's mistaken assumption is **"the current view is the system."** They publish a
working tree and call it a repository; delete a path and call it erasure; link some
artefacts and call the rest hidden; treat console output as disposable.

Three mechanisms turn it into a finding:

- **Content addressing is append-only.** A commit is an immutable snapshot. Blanking a file
  writes a *new* snapshot; the old blob is still reachable from the old commit, and every
  clone contains it. Git has no concept of forgetting — only history rewriting plus
  garbage collection, and even that cannot reach clones taken earlier.
- **Deletion is an add.** `git rm` adds a tree omitting a blob; its parent still has the
  content, which makes the removal *easier* to find than the original.
- **Retention outlives publication.** CI keeps more than it links: the console describes
  expected inputs, the workspace zip contains the checkout, and the run store retains
  artefacts for debugging. The results page is a filtered view over that store, not an
  access-control boundary.

Hence: **anything committed is published the moment the repository is readable; anything
logged is published the moment the log is readable.**

## 3. How to spot it

- **URLs and routes:** `/git/<name>.git`, `/info/refs`, `/.git/HEAD`, "browse source",
  "checkout" links, `/api/v1/repos/<owner>/<repo>/contents|raw|commits|git/trees`,
  `?ref=`, `?path=`, `?since=`.
- **Wording that admits history:** "removed from the current tree", "retired", "cleaned
  up", "blank template", "withdrawn". Retirement notes index the commit before them.
- **Paths that are promised but missing:** a review note, README or ticket names
  `fixtures/<name>.json`, `secrets/<name>.enc.json`, `docs/<file>.md` and the current tree
  returns `404`. That is a pointer, not a dead end.
- **Commit metadata:** messages beginning "remove", "drop", "retire", "replace with
  template"; diffs that are mostly deletions; tags named after a test baseline.
- **API fields:** `parents[].sha`, `files[].status: "removed"`, `deleted_commit`,
  `expected_fixture`, `fixture_revision`, `sha256`, `content` (base64),
  `retained_artifacts`, `listed_on_results_page`, `result_page.artifacts`.
- **CI surfaces:** `/job/<name>/<n>/consoleText`, `/artifact/<path>`, `/ws/*zip*/ws.zip`,
  `/api/runs/<id>`, `/api/runs/<id>/log`, `/api/runs/<id>/artifacts/<name>`, build caches
  and per-run temp directories.
- **Response differences:** `404` at `HEAD` but `200` at the parent; `raw` returns bytes
  while `contents` returns base64; a run lists an artefact no page links.

## 4. How to test it

Order matters: establish that the content existed, then find a revision that still has it,
then prove you retrieved the exact bytes. Everything below is read-only.

```bash
df -h /tmp                              # a full clone can dwarf the checkout
git clone http://target:8080/git/app.git /tmp/app && cd /tmp/app
git log --all --oneline --decorate --stat       # history as a map
git rev-list --all --count                       # commits reachable at all
git log --all --diff-filter=D --name-status --oneline   # deletions
git show <delete-commit>^:<path/from/the/note>  # bytes, no checkout
git cat-file -t <commit>:<path>                  # blob
git log --all -p -S 'BEGIN PRIVATE KEY' -- .     # content across revisions
git fsck --lost-found --no-reflogs               # refs nothing points at
```

Read the *shape* of the diff before the content: nine lines added, then replaced by three,
tells you the removed text is one hop back. `rev-list` tells you whether the blob is
reachable (both commits on `main`) or dangling (only `fsck` finds it).

The same questions over HTTP:

```bash
# History for one path: the newest entry is usually the deletion, the next one has it.
curl -sS -u "$U:$P" \
  'https://source.example.test/api/v1/repos/<owner>/<repo>/commits?path=<path>&limit=5' \
  | jq -r '.[] | "\(.sha[0:7]) \(.commit.message | split("\n")[0])"'

# Exact bytes at a revision (raw), and the base64 variant (contents).
curl -sS -u "$U:$P" \
  'https://source.example.test/api/v1/repos/<owner>/<repo>/raw/<path>?ref=<rev>' -o out.bin
curl -sS -u "$U:$P" \
  'https://source.example.test/api/v1/repos/<owner>/<repo>/contents/<path>?ref=<rev>' \
  | jq -r '.content' | base64 -d > out.bin
sha256sum out.bin
```

Byte-exactness is not pedantry: consumers bind fixtures by digest, so a re-serialised JSON
object fails the check while looking identical. Compare the published `sha256` /
`report_sha256` before using what you recovered.

Build systems answer the other half:

```bash
curl -sS -u "$U:$P" 'https://ci.example.test/job/app/1842/consoleText' | tail -40
curl -sS -u "$U:$P" 'https://ci.example.test/job/app/1842/api/json' \
  | jq '{result, artifacts: [.artifacts[].relativePath]}'
curl -sS -u "$U:$P" 'https://review.example.test/api/runs/<run_id>' \
  | jq '{state, result_page, retained_artifacts}'
```

The console tail states the verdict and often the inputs. The run record separates "kept"
from "published": `listed_on_results_page: false` entries are the ones no page shows.
Fetch them by name and check the digest.

Safety: clone into scratch space (a small `tmpfs` fills and breaks unrelated work); never
`git checkout` recovered code; do not rewrite history on a host you do not own.

## 5. Case study from this range

**Deletion in a served repository — T01.1 and T03.1.** The training desk served
`/git/handover.git` anonymously. The clone contained one file, `handover.md`, as a blank
template. The log showed exactly two commits:

```text
a01d629 (HEAD -> main) leave blank handover template   handover.md | 8 +++-----
04176f3                record courier handover          handover.md | 9 +++++++++
```

Nine lines added, then replaced by three. `git cat-file -t 04176f3:handover.md` returned
`blob`, and `git show 04176f3:handover.md` printed the original text. Nothing was checked
out, so `HEAD` never moved. The reasoning worth copying is the diff-shape read: *the size
of the deletion tells you how much is recoverable, and the parent commit tells you where.*
The same technique appears on the developer-artifacts desk (T03.1): a review note named a
fixture at a documented path, the path returned a miss, and
`git log --diff-filter=D --name-status` pointed at the commit whose parent still held it.
That card asked a second question — *what behaviour did the fixture cover?* — which a
generic "undelete" tool cannot answer. T03.1's transcript was not retained; the technique
is reconstructed from the desk brief.
[`../writeups/T01.1.md`](../writeups/T01.1.md) · [`../writeups/T03.1.md`](../writeups/T03.1.md)

**Retained artefacts — K02.1 and K09.2.** A failing report build is a documentation
generator. Job `fieldlink-report` #1842 had removed its own fixture, so the console ended:

```text
FileNotFoundError: [Errno 2] No such file or directory: 'fixtures/report-crr-og2.json'
FAILED tests/test_crr_og2_report.py::test_report_fixture
FLAG{…}
Build step 'Execute shell' marked build as failure
Finished: FAILURE
```

The repository side was equally explicit: `main` was `c37effd…` "remove generated report
fixture from tree" (adding `review/FLK-7.4.2.md`, removing
`fixtures/report-crr-og2.json`), and its parent `80560bc…` was tagged `fk-test-6d1e9f7`,
"add CRR-OG2 report fixture". Fetching

```bash
curl -sS -u "$U:$P" \
  'https://source.example.test/api/v1/repos/<owner>/<repo>/raw/fixtures/report-crr-og2.json?ref=fk-test-6d1e9f7'
```

returned the 532-byte baseline (`schema fieldkest.report/v2`, `asset_id CRR-OG2`,
`connector_revision FLK-7.4.2`, two observations) whose SHA-256 matched the published
digest. The card's accepted value came from the *console*, not the recovered fixture —
exactly the trap K09.2 formalises: a run record can list artefacts the results page never
links.

```json
"result_page": {"artifacts": ["junit.xml"]},
"retained_artifacts": [
  {"name": "integration-review-input-v3.json", "listed_on_results_page": false,
   "sha256": "b631b3…", "url": "/api/runs/BLD-1842/artifacts/integration-review-input-v3.json"},
  {"name": "REVNOTE-1842.json", "listed_on_results_page": false, "sha256": "7e8ecf…"}
]
```

Two catalogues, one store, one authorisation check. The service's own source comment said
the run metadata "lists retained_artifacts that are not on the Jenkins results page; the
participant must access this service to find them." Fetch each name, then use the digest to
tell the orphan from the published report. Do not mistake the embedded `report` object for
the artefact: the card is about a file the record lists but does not inline.
[`../writeups/K02.1.md`](../writeups/K02.1.md) · [`../writeups/K09.2.md`](../writeups/K09.2.md)

## 6. Variations and near-misses

- **Dangling vs reachable.** A deleted *branch* leaves commits reachable only through
  reflogs or `fsck`, until `git gc` prunes them; a deleted *file* on `main` stays reachable
  from the parent commit indefinitely. Say which one you found.
- **"Removed" by rewrite.** A force-push or `filter-repo` removes the ref, not the copies:
  server reflogs, CI caches, forks, and every clone taken earlier still have it.
- **`.git` served as static content.** `GET /.git/HEAD`, `/.git/config`,
  `/.git/objects/…` on a web root is the same bug with no forge in front of it.
- **Backups and editor residue** — `file.bak`, `file~`, `.orig`, `.swp` — are copies outside
  the VCS, often with looser permissions: adjacent, not identical.
- **CI variation:** workspace zip vs published artefact vs cache vs container layer. Each
  retains a different slice.
- **Large-file pointers.** Git LFS history holds a pointer, not the bytes.

What does **not** count:

- A `404` at the documented path. That proves the *current tree* lacks the path and nothing
  more. It is the start of the test, not the finding.
- A commit message saying "remove" whose diff only reformats or renames.
- A blank template that never had content, or a recovered file full of placeholders.
- An unreachable object already garbage-collected: `git fsck` finds nothing and the blob is
  genuinely gone from that repository.
- A secret that was deleted **and rotated**. The history is still a disclosure, but it no
  longer grants access — report it as data exposure, not as credential compromise.
- A public artefact that was always meant to be public (release notes, published contract).

## 7. How to fix it

- **Publish an export, not a repository.** If consumers need files, serve a generated,
  sanitised snapshot with no history, no `.git`, and no unreferenced objects. Keep
  history-read as a separate, audited permission.
- **Treat deletion as disclosure.** Anything ever committed is compromised: rotate every
  credential that appeared in history, and classify customer data as breached rather than
  "removed".
- **If content must disappear, do the whole job:** `git filter-repo`, expire reflogs,
  `git gc --prune=now`, force-push, invalidate caches and forks, ask every clone holder to
  re-clone, then verify the blob is unreachable. A rewrite without rotation is cleanup.
- **Keep expected values out of logs.** Generate fixtures at test time or pull them from a
  controlled store; print a digest or a diff summary instead of the full expected document;
  strip the environment from build output.
- **Give artefacts a visibility flag at write time** and enforce it on read. Serve published
  artefacts through authorised, expiring URLs; keep the debugging/retention view behind an
  operator role and audit every access.
- **Bound retention.** Set a TTL on run directories and logs, encrypt secret-bearing
  intermediates with a key the read API cannot use, and alert on ref-pinned reads of paths
  that no longer exist at `HEAD`.

## 8. Exercises

1. **Reproduce and then actually remove.** In a local repo: commit a file containing
   `TOKEN=example`, then commit a blank replacement. Recover it with
   `git show <commit>^:<path>`. Then run `git filter-repo --path <path> --invert-paths`,
   `git reflog expire --expire=now --all`, `git gc --prune=now`, and confirm `git fsck`
   finds nothing. Write two sentences on why you would still rotate the token.
2. **Read a run record.** Given a run JSON containing `result_page.artifacts: ["junit.xml"]`
   and three `retained_artifacts` entries, one with `listed_on_results_page: false`, write
   the exact requests you would make, in order, and say what a matching `sha256` proves and
   what it does not.
3. **Predict the response.** After `git rm fixtures/x.json && git commit`, predict what
   `git show HEAD:fixtures/x.json` and `git show HEAD^:fixtures/x.json` return, and what
   `GET /contents/fixtures/x.json?ref=main` returns versus `?ref=<parent-sha>`. Then explain
   which of those four answers is the bug and which are just normal git behaviour.
