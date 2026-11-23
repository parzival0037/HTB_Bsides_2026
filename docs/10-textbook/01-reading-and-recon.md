# 01 — Reading a target: status, length, headers, source

## 1. What this class of bug is

Most of what you find on a target is not a broken check. It is the application answering a
question you were not supposed to ask: a page that still exists after being removed from the
menu, a lookup that says "this account is gone" instead of "no such account", a release
review that is missing from the repository but attached to a ticket. In each case the server
behaves exactly as coded; the defect is that its normal behaviour is *observable* and the
observation is worth something.

The precise definition used in this chapter: **unintended observability** — the target
discloses one of three things to a caller who should not have it:

1. **existence/location** of a resource that is served but not linked (a retired page, an
   unused API route, a manifest entry);
2. **state distinctions** between inputs that the caller has no need to distinguish
   (active / inactive / unknown account);
3. **a second copy** of governed data under a weaker policy than the system of record.

The finding is the *difference* between two responses. If every input produced byte-identical
output, there would be nothing to see — and nothing to exploit.

## 2. Why it exists

Every one of these bugs is a mistaken assumption about what "not visible" means. Name them,
because you will meet them by name in code review:

- **"Not in the navigation, therefore not reachable."** Developers retire content by
  de-linking it. Navigation is rendered from a list a human maintains; the route table and
  the document root are different artefacts that drift. The file stays on disk "for
  compatibility", and the client still needs to know about it — so the location is published
  in a manifest. The UI's menu is application logic, not an access-control decision.
- **"A generic error message is a safe error message."** Status codes are chosen branch by
  branch. A developer thinking in domain states writes `200 active`, `410 inactive`,
  `404 unknown` because those are three honest answers. They are also three answers to
  "does this handle exist?" — asked by an unauthenticated caller.
- **"The front page is documentation, not an attack surface."** A markdown index that lists
  every API route, a JS bundle that exports a function no page calls, and a `.well-known`
  client reference are all *contracts*. They exist so clients can work; you are a client.
- **"The policy follows the copy."** A document restricted in the repository is pasted into
  a work board, where the project-wide permission model decides who reads it. Nobody
  re-evaluates the classification, so the second copy becomes the weakest link.
- **"If you cannot see it, it is not there."** HTTP has no concept of visible. It has
  authorized and unauthorized, and most apps only implement the first badly.

## 3. How to spot it

- A front page written in markdown or HTML that documents its own endpoints (`GET /api/...`,
  "auth via the `X` cookie"). Read it literally; it is a map.
- Route strings in a JS bundle that no rendered page calls. In this range, `/directory/app.js`
  exported `loadCoordinatorAssignment(staffId)` while the page only used
  `loadPublicDirectory()`; the unused call named the hidden sub-resource.
- Path/host metadata files: `robots.txt`, `sitemap.xml`, `site.webmanifest`, `manifest.json`,
  `/.well-known/<client>`, `.git/`, `CHANGELOG`, `README.md`. Their *presence and content*
  are data; their absence proves nothing.
- Status codes that split hairs: `410 Gone` next to `404 Not Found`; `403` on a route that
  is otherwise a `404` everywhere else (403 = the route exists and something authorized it).
- `501` on `OPTIONS` — a hand-rolled HTTP handler, so expect hand-rolled routing and errors
  (here: `Server: CinderTraining/1.0 Python/3.12.11`, JSON errors `{"error":"..."}`).
- **Length clusters.** Two different paths returning exactly the same byte count are
  usually the same handler or a catch-all fallback. A `200` whose length equals the index
  page is a soft 404.
- Error strings that name internal concepts you were not meant to model:
  `staff_not_found`, `directory_detail_denied`, `record_binding_mismatch`,
  `invalid_upn`. Each is a labelled branch you can drive.
- Content-type mismatches: JSON error body where the route should return HTML, or HTML
  where the API returns JSON — a sign two layers disagree about the route.
- Copy signals outside HTTP: a ticket attachment, a board item, a client-config JSON on a
  workstation, a browser download history. "Missing from the checkout" is a scoping
  statement, not a deletion.

## 4. How to test it

Rules first: work only inside your authorized scope, prefer **published lists** over
wordlists, use `GET` only during recon, one request per path, at most a few requests per
second, and stop as soon as you can prove existence. Never use recon as cover for state
changes (`POST`, `PUT`, `DELETE`).

```bash
T=http://target:8080
curl -sS -D /tmp/h -o /tmp/body "$T/"        # status line, Server, Content-Type, Length
head -20 /tmp/h
curl -sS "$T/" | tee /tmp/menu.txt | head -40
```

The front page tells you what the app *thinks* it is, and often enumerates the rest.

```bash
grep -oE '(href|src)="[^"]*"' /tmp/menu.txt | sort -u > /tmp/linked.txt   # what the menu shows
curl -sS -o /dev/null -w '%{http_code} %{size_download}\n' "$T/robots.txt"
curl -sS "$T/site.webmanifest" 2>/dev/null | grep -oE '"/[^"]*"' | tr -d '"' | sort -u > /tmp/declared.txt
comm -23 /tmp/declared.txt /tmp/linked.txt    # declared but unlinked: candidates
```

`comm -23` gives the set difference: locations the publisher declares and the UI does not
offer. That is the whole trick behind "hidden page" findings — you are reading the
publisher's own index instead of guessing names.

```bash
curl -sS "$T/app.js" | grep -oE '"/api/[A-Za-z0-9_/{}.$-]*' | sort -u
```

The bundle is the client's route list. Look for calls whose result is never rendered.

```bash
curl -sS -i -X OPTIONS "$T/api/assignments" | head -12
```

`200`/`204` with `Allow:` tells you the method set. `501` tells you the handler is custom and
will have its own error vocabulary; `405` tells you the route exists.

Now the differential test — the core of this chapter. Vary **one** input and record status,
length and body:

```bash
for p in /api/directory/staff/STF-204/assignment /api/directory/staff/STF-317/assignment; do
  printf '%-48s ' "$p"
  curl -sS -o /tmp/o -w '%{http_code} %{size_download} ' "$T$p"
  head -c 160 /tmp/o; echo
done
```

How to read what comes back:

| Response | Meaning |
|---|---|
| `200` + content | the read happened; this is your finding |
| `404` | no such route **or** no such object — indistinguishable by code alone |
| `403` | route and object exist; an authorization decision was made (a boundary, not a bug by itself) |
| `410` | existed, is gone — a *success* signal for enumeration |
| `400` + a filter-style error | a check fired on your input; note the check, then vary the input |
| `200` + index-page length | soft 404 / SPA catch-all, not a hidden page |

Confirm every difference twice, with the body saved to disk. A single length delta can be a
timestamp, a request id or a gzip artefact; the same delta with a stable field is a signal.

## 5. Case study from this range

### T01.2 — the page that was withdrawn from the menu

The dispatch desk states its own bug in prose. Captured from `:8081/`:

```text
# Dispatch desk
The current navigation contains the [public delivery notice](notice-DL-204.md).
The prior rehearsal page was withdrawn from the menu during cleanup. Static
client metadata is still published for offline desk clients.
```

Two sentences, two facts: a page was **removed from the menu** (not from disk), and the
publisher still ships **client metadata** that describes content. The reasoning step is to
translate prose into a request: "withdrawn from the menu" is an editorial statement; only a
status code tells you whether the file is still served. Guess from the vocabulary the page
itself gives you (`rehearsal`, `notice-DL-204`), request each once, and compare `404` with
`200`. A `404` means wrong name; a `200` with real content means the retirement was a
de-link — which is exactly what the card asks for. The write-up's manifest-diff step
(`did not link but declared`) is reconstructed rather than captured, so treat that command
as a recipe, not a transcript: [`../writeups/T01.2.md`](../writeups/T01.2.md).

### T02.1 — three answers for three account states

The identity desk documents its recovery API on the front page, and publishes the candidate
handles it wants reviewed. Three `POST`s, one variable each:

```bash
H=http://accounts.training:8080
for a in mina.cho rhea.moss owen.pike; do
  printf '%-12s ' "$a"
  curl -sS -o /tmp/o -w '%{http_code} ' -H 'Content-Type: application/json' \
       -d "{\"account\":\"$a\"}" "$H/api/recovery/lookup"; cat /tmp/o; echo
done
```

```text
200 {"account":"rhea.moss","case_fragment":"CASE-7Q4M","flag":"FLAG{7502f8e82360c288}","state":"active"}
410 {"state":"inactive"}
404 {"state":"unknown"}
```

`410` is the finding. The caller is unauthenticated, yet the service distinguishes *was
real* from *never existed* — and the active branch returns the account-bound case fragment,
which is half of the recovery credential. No brute force was needed: the desk published the
candidate set, and one random handle confirms the `404` shape. Read
[`../writeups/T02.1.md`](../writeups/T02.1.md) for the chain into the account takeover.

### K01.3 — the copy in the other system

A release review was absent from the checkout: not in a branch, a tag, a stash or
`git fsck --lost-found`. The productive move is not more git — it is changing systems. The
review had been attached to a work-board item, where a project-membership model governed
it instead of the repository's release controls. "Missing here" was a statement about one
container, not about the bytes. That write-up is explicitly reconstructed (no transcript):
[`../writeups/K01.3.md`](../writeups/K01.3.md).

## 6. Variations and near misses

- **Soft 404.** `200` with "not found" in the body. Compare body hashes, not just lengths:
  `curl -sS "$T/a" | sha256sum` against `curl -sS "$T/nope" | sha256sum`.
- **SPA catch-all.** Every unknown path returns `index.html` with identical length. This is
  the classic false positive for directory guessing; the only reliable test is a body diff
  plus a route the app actually renders.
- **`robots.txt` is not a content index.** On this range it returns `404` on the identity
  desk — nothing hidden, and nothing proven. A `Disallow:` line is a *hint*, not a control.
- **`403` where you expected `404`.** `STF-317/assignment` answers `403
  directory_detail_denied` even with a valid session — authorization exists and is doing its
  job. Reporting it as an access-control bug is a false positive; it is a boundary marker.
- **Unlinked static assets.** A retired `logo-old.png` returning `200` is not a finding
  unless the content is sensitive; publication scope, not existence, is the test.
- **`410` as an intentional tombstone.** Some APIs deliberately keep "gone" semantics for
  redirects. Whether it is a leak depends on whether an unauthenticated caller should learn
  the handle ever existed.
- **Length deltas from infrastructure.** gzip, dates, nonces, ETags. Re-run once and diff
  the saved bodies before you believe a one-byte difference.

## 7. How to fix it

- Give account/identifier lookups **one response shape and status for every input**:
  `202` "if that account exists, a message has been sent", work done server-side. Do not
  return `410`/`404` splits, and never return recovery material to an unauthenticated caller.
- **Retire by removal, not de-linking**: delete the file, or gate it with the same
  authorization as private content. If a manifest must list it, the route must check access.
- **Generate navigation and authorization from one source of truth.** A path in the menu and
  a path in the policy store should be the same record; a CI diff between document root and
  menu catches drift.
- **Do not publish the location of sensitive documents** in a client-readable index; ship an
  opaque id and resolve it server-side against the caller.
- Log the *resolved* route plus subject and status, and alert on one source walking many
  identifiers with a high `404`/`410` ratio — the pattern, not a single failed lookup.
- Apply classification to the bytes: if a governed document is copied into a ticket or board,
  the copy inherits the original's access rule and retention, or it does not get made.

## 8. Exercises

1. **Build the menu/manifest gap.** A 30-line Flask app with `/`, `/internal/notes.json` and
   `/site.webmanifest`, where the manifest lists both the public page and the internal one,
   and the index links only the public page. Run the `comm -23` recipe and report the
   candidate. Then delete the internal file and show the same recipe produces no `200`.
2. **Predict then verify the oracle.** Given this handler, write down the status and body for
   `active`, `inactive`, `unknown` and a random handle *before* running it; then run it.
   Rewrite the handler to a single `202` response and show that your own enumeration loop can
   no longer tell the three cases apart.
3. **Triage five responses.** You observe: `200` len 512 (twice on different paths),
   `404`, `403`, `500` with a stack trace. Which indicate existence, which need a second
   probe, and which are likely artefacts? Name the one extra request you would send for each.
