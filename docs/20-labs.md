# Labs — rebuild the bugs, then break them

You cannot learn this by reading. Every lab below is something you can build on your own
machine in a few minutes, get broken, then fix. They mirror the bug classes in
[`10-textbook/`](10-textbook/) and the cards in [`../writeups/`](../writeups/).

Each lab has: **build it**, **break it**, **fix it**. Do them in order — later labs assume
you are comfortable with the loop from [00-start-here](00-start-here.md).

Requirements: `python3`, `flask` (`pip install flask`), `curl`, `jq`, `git`.

---

## Lab 1 — path traversal, and why prefix checks fail

**Build it**

```python
# lab1.py
from flask import Flask, request
app = Flask(__name__)

@app.get("/render")
def render():
    view = request.args.get("view", "")
    if not view.startswith("public/"):
        return {"error": "invalid_request"}, 400
    with open("/srv/docs/" + view) as f:      # the bug: string concatenation
        return {"body": f.read()}
```

Put `secret.txt` next to a `public/` folder, run it, then:

**Break it**

```bash
curl -s 'http://127.0.0.1:8080/render?view=public/../secret.txt'
```

Why it works: the guard checks the *prefix*, the filesystem resolves `..` afterwards.

**Fix it**

```python
import pathlib
base = pathlib.Path("/srv/docs").resolve()
target = (base / view).resolve()
if not str(target).startswith(str(base) + "/"):
    return {"error": "invalid_request"}, 400
```

Then try the bypass again — it must fail, including `public/../../etc/passwd` and
URL-encoded `%2e%2e%2f`.

**Lesson:** validate the *resolved* path, not the string.

---

## Lab 2 — IDOR: authentication that forgets authorisation

**Build it**

```python
# lab2.py
from flask import Flask, request, abort
app = Flask(__name__)
USERS = {"alice": "tok-alice", "bob": "tok-bob"}
NOTES = {1: ("alice", "alice's private note"), 2: ("bob", "bob's private note")}

@app.get("/notes/<int:nid>")
def note(nid):
    token = request.headers.get("Authorization", "").removeprefix("Bearer ")
    user = next((u for u, t in USERS.items() if t == token), None)
    if not user:
        abort(401)
    owner, body = NOTES[nid]          # the bug: no owner == user check
    return {"owner": owner, "body": body}
```

**Break it** as alice, reading note 2:

```bash
curl -s -H 'Authorization: Bearer tok-alice' http://127.0.0.1:8080/notes/2 | jq
```

**Fix it**

```python
owner, body = NOTES[nid]
if owner != user:
    abort(404)      # 404, not 403: don't confirm the object exists
```

**Lesson:** every object read needs *both* "who are you" and "may you see this". The
second check is the one developers forget.

---

## Lab 3 — user enumeration by response shape

**Build it**

```python
@app.post("/lookup")
def lookup():
    name = (request.json or {}).get("account", "")
    if name == "alice":
        return {"state": "active", "case": "CASE-1234"}
    if name == "carol":
        return {"state": "inactive"}, 410
    return {"state": "unknown"}, 404
```

**Break it** — measure, don't guess:

```bash
for u in alice bob carol; do
  printf '%-6s ' "$u"
  curl -s -o /dev/null -w '%{http_code} %{size_download}\n' \
    -X POST -H 'Content-Type: application/json' -d "{\"account\":\"$u\"}" \
    http://127.0.0.1:8080/lookup
done
```

Three accounts, three different responses: you now have a valid-account oracle.

**Fix it:** return an identical generic response and status for every case, do the work
asynchronously, and rate-limit per source.

**Lesson:** status codes, lengths and timing are all information. Compare, don't assume.

---

## Lab 4 — secrets in published config

**Build it** — serve this JSON at `/client/profile.json`:

```json
{"api_base": "http://127.0.0.1:8081", "authorization": "Bearer lab-token-1",
 "scope": ["manifest:DL-204:read"]}
```

and an API on `:8081` that accepts the bearer only for `/deliveries/DL-204/manifest`.

**Break it:** use the token exactly where its scope points, then try somewhere it
shouldn't work and note the difference:

```bash
curl -s -H 'Authorization: Bearer lab-token-1' http://127.0.0.1:8081/deliveries/DL-204/manifest
curl -s -H 'Authorization: Bearer lab-token-1' http://127.0.0.1:8081/deliveries/DL-999/manifest
```

**Fix it:** never ship credentials to a public path; scope tokens server-side to the
object, not just the verb; rotate on exposure.

**Lesson:** read the *scope* field. It tells you where the credential was meant to work —
and scope bugs are where it works beyond that.

---

## Lab 5 — history you thought you deleted

**Build it**

```bash
mkdir lab5 && cd lab5 && git init -q
echo 'FLAG{this-should-not-be-public}' > secret.txt
git add . && git commit -qm "add secret"
git rm -q secret.txt && echo 'nothing here' > readme.md
git add . && git commit -qm "remove secret, add readme"
```

**Break it**

```bash
git log --oneline --all
git log --diff-filter=D --name-only --oneline
git show <first-commit>:secret.txt
```

**Fix it:** deleting files is not redaction. If a secret was ever committed, rotate it and
rewrite history (`git filter-repo`), then force-push and re-clone everywhere.

**Lesson:** the object database keeps everything reachable. Treat every commit as public.

---

## Lab 6 — mTLS where the subject is attacker-controlled

**Build it** (self-signed CA, two client certs, one endpoint keyed by subject)

```bash
# CA + client cert for alice
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
  -keyout ca.key -out ca.crt -days 2 -subj "/CN=Lab CA"
openssl req -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
  -keyout alice.key -out alice.csr -subj "/CN=alice"
openssl x509 -req -in alice.csr -CA ca.crt -CAkey ca.key -days 2 -out alice.crt
```

Serve an endpoint that returns the note belonging to `$SSL_CLIENT_S_DN_CN`.

**Break it:** generate a cert with `-subj "/CN=bob"` signed by *your* CA — the server prints
bob's note.

**Fix it:** the server must verify the chain against a trusted CA **and** authorise the
subject against an application-level record (is this principal allowed this object?), not
just trust the subject string. Bind certs to an enrollment record created by an authorised
human action.

**Lesson:** a certificate proves *someone holding that key*. It only proves *identity* if
the CA's issuance policy is trustworthy — which is what broke in K19.

---

## Lab 7 — SCADA semantics: measured vs requested

**Build it** — a tiny process simulator:

```python
STATE = {"level_l": 1200.0, "setpoint_l": 1000.0, "status": 0b0101, "open": False}
# bit0 ready, bit1 outlet_open, bit2 service_hold, bit3 transfer_active
```

Expose `/state`, and a `/transfer` that refuses while `status & 0b0100`.

**Break it / use it**

```bash
curl -s http://127.0.0.1:8080/state | jq
# clear the hold, request 200 L, then verify from observations, not from the reply
```

**Fix it:** verify transfers from independent observation; separate the operator display
from the control path; alarm on request-vs-measurement drift.

**Lesson:** in OT, "accepted" ≠ "moved". The flag is in the observation, not the command.

---

## Lab 8 — LLM app leaking its own context

**Build it** — a Flask app with two workspaces, each with a system prompt and a
documents list, and an endpoint `/api/workspace/<slug>` that returns the prompt.

**Break it:** fetch the other workspace's prompt and documents with the same user token.

```bash
curl -s -H 'Authorization: Bearer user-token' http://127.0.0.1:8080/api/workspace/other
```

**Fix it:** authorise per (principal, workspace); never let retrieval contexts be readable
by anything but the workspace owner; treat system prompts as data with the same
classification as the documents they reference.

**Lesson:** the assistant's context is a database with a UI on top. Test it like one.

---

## After the labs

Work through [`10-textbook/`](10-textbook/) in order, then pick a KeplerOps chapter in
[`../writeups/`](../writeups/) and re-derive it: read the card, predict the response of
each request, then check. That prediction habit is what the whole repo is trying to teach.
