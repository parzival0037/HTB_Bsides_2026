# 04 — Secrets and configuration: where credentials hide

## 1. What this class of bug is

A program needs a password, token, key or connection string to do its job, so somebody
writes it down: in a dotfile, a client profile, an environment variable, a CI setting, a
kubeconfig. Nothing is broken cryptographically. The credential simply sits somewhere that
is readable by more people — or by a different principal — than the credential itself
authorises. Reading the file *is* using the credential.

**Precise definition:** secret material is stored in an artefact whose read access is wider
than the credential's own authorisation, so possession of the artefact (not authentication
as its owner) grants its capabilities. The artefact may be a file on a shared host, a
document served over HTTP, a process environment, or a CI job field. The bug is the
**mismatch between where the secret lives and what the secret can do**.

Two properties decide the blast radius:

| Property | Question to ask | Why it matters |
|---|---|---|
| Bearer or bound | Does possession alone authenticate? | A bearer token needs no password, no device, no second factor |
| Scope and lifetime | What objects, verbs, services, and for how long? | Turns "a leaked string" into "three footholds for six months" |

## 2. Why it exists

The developer's mistaken assumption is **"location is protection."** They reason: this file
is inside my home directory / this profile is only used by our client / this variable is
in the CI system, therefore it is private. Each clause silently substitutes *who can reach
the container* for *who is authorised to use the contents*.

Four variants of that same wrong assumption show up constantly:

- **"Config is not a secret."** Configuration and credentials are mixed in one file because
  they are both "settings". Then the config file gets published, logged, or committed.
- **"A scoped token contains the leak."** Scope is declared by the issuer and enforced by
  the resource server. If the server checks authentication but not the object instance, the
  scope is decoration. Distribution, not scope, becomes the boundary.
- **"Retired / disabled / old means revoked."** Lifecycle words describe intent. Only a
  verifier-side change revokes anything.
- **"Nobody looks there."** A directory named `retired-client/`, a dotfile, an unused
  namespace. Obscurity is being used as an access control.

The deeper error is architectural: the workstation, CI runner and client host are treated as
trusted extensions of the identity provider. They are untrusted infrastructure, imaged,
shared, backed up, phished and stolen — plan for the credential to be read.

## 3. How to spot it

- **Filenames that are credential stores by convention:** `.git-credentials`, `.netrc`,
  `.npmrc`, `.pgpass`, `.pg_service.conf`, `.aws/credentials`, `.kube/config`,
  `.docker/config.json`, `.config/gh/hosts.yml`, `.config/<vendor>/*.json`, `.env`,
  `.bash_history`, shell profiles, `.xsession`, browser profiles.
- **Fields whose names are secrets:** `authorization`, `token`, `access_token`,
  `_auth`, `password`, `passphrase`, `api_key`, `secret`, `private_key`,
  `client-key-data`, `connectionString`, `dsn`.
- **Credential shapes inside otherwise boring data:** `Bearer <opaque>`, a prefix like
  `fk_…`/`ghp_…`/`npm_…`, base64 that decodes to `user:token`, a URL of the form
  `https://user:token@host`, a PEM block, a kubeconfig `users[].user` block.
- **Wording that advertises distribution:** "retained for compatibility", "static client
  metadata for offline clients", "the profile the desk hands out", "copy this file to each
  workstation", "no login required".
- **Response differences:** an anonymous URL returning a JSON object with an
  `authorization` key; a `200` on a profile but `401` on the API it names; `403` for one
  object id and `200` for the id next to it.
- **Header shapes:** `Authorization: Basic <base64>` in a captured request; basic auth
  accepted *and* bearer accepted by the same service; `WWW-Authenticate` naming a realm
  you did not expect.
- **Config that points at authority:** `api_base`, `host`, `registry`, `kubeconfig`,
  `credential helper = store --file …`, `certificate-authority-data`, `tls.crt`/`tls.key`.
  The path tells you which secret unlocks which service.
- **Process and CI surfaces:** `docker inspect` env, `/proc/<pid>/environ`, job config XML,
  pipeline YAML, build logs that echo `env`, artifact bundles containing a runner's home.

## 4. How to test it

Work outside in, read-only, and stop as soon as you have proven reach. Use placeholders;
never paste a real credential into a shared shell history.

```bash
# 1. Inventory the surface. What does the app say it publishes?
curl -sS -i http://target:8080/ | head -30
curl -sS http://target:8080/robots.txt

# 2. Fetch a published client profile and look at its SHAPE, not its values.
curl -sS http://target:8080/retired-client/profile.json \
  | jq 'keys, (.scope? // empty)'

# 3. Which fields are secret-shaped? Names only — do not print values.
curl -sS http://target:8080/retired-client/profile.json \
  | jq -r 'to_entries[] | select(.key|test("auth|token|key|pass|secret";"i")) | .key'

# 4. On a host you already control, find stores without dumping them.
grep -rIl --exclude-dir=.cache -e 'Bearer ' -e '_auth=' -e 'BEGIN .*PRIVATE KEY' ~ 2>/dev/null
git config --get-regexp '^credential' ; git remote -v

# 5. Establish what the credential is FOR, from the file itself.
#    (api_base / host / registry / scope are the routing instructions.)
```

The profile is the whole access story: `api_base` says where to send it, `scope` what it
claims to allow, `authorization` what to send. Make one request inside scope:

```bash
TOK='<token from the profile>'
B='http://target:8082'

curl -sS -o /dev/null -w '%{http_code}\n' -H "Authorization: Bearer $TOK" \
  "$B/request-history.txt"          # 200 = inside scope, 401 = revoked, 403 = enforced

curl -sS -o /dev/null -w '%{http_code}\n' "$B/request-history.txt"   # no header: should be 401
curl -sS -o /dev/null -w '%{http_code}\n' -H "Authorization: Bearer $TOK" \
  "$B/request-history.txt?delivery_id=<next-id>"                    # 200 here is the bug
```

`200` on the first means the credential works. `403` on the cross-instance request means
scope is really enforced — that is the *correct* behaviour and not a finding. `200` on the
cross-instance request means the token is a key to the service, not to the object, and the
`scope` field was aspirational.

Base64 is encoding, not encryption: a registry storing `user:token` base64-wrapped can be
decoded to confirm the shape without exposing the secret (`... | base64 -d | cut -d: -f1`
prints the username). A kubeconfig is a credential even without a token:
`client-certificate-data` plus `client-key-data` is a long-lived client certificate. Inspect
its subject and expiry, never the key:

```bash
kubectl config view --raw -o json | jq -r '.users[0].user["client-certificate-data"]' \
  | base64 -d > /tmp/cc.pem
openssl x509 -in /tmp/cc.pem -noout -subject -dates
```

Safety rules: GETs only until you understand the model; one object id step, not a loop over
a tenant range; no bulk export; record the request line and status; and if the credential
is real, tell the owner and rotate it — reading it was the finding.

## 5. Case study from this range

**K01.1 — one token, three services.** On a developer workstation the observed
configuration was ordinary: `~/.gitconfig` set `credential.helper = store --file
/home/<user>/.config/git/credentials`, `~/.npmrc` carried
`//packages.keplerops.test/:_auth=<base64 of user:token>` plus a CA path,
`~/.pg_service.conf` named a database and user, and `~/.pgpass` held the matching password.
`~/.config/fieldlink/` held per-service bearer JSON. The same `fk_developer_…` token was
accepted by the source host, the CI server and the report service; the npm entry was that
token base64-wrapped. The recovery step was therefore not password cracking but file
reading, and the use step was the documented contents route:

```bash
curl -sS -k -u '<user>:<fk_developer token>' \
  'https://source.example.test/api/v1/repos/<org>/<repo>/contents/?ref=main'
```

Why this is a whole bug class rather than an easy card: the token was a **bearer** secret
(reading a file authenticates you), **long-lived** (minted for one clone, valid for months),
and **shared across services** (one leak, three footholds). Requests made with it are
*authorised*, so they look like normal developer traffic. The lane kept no command trail;
the files and the token's acceptance are recorded, the winning request is reconstructed.
[`../writeups/K01.1.md`](../writeups/K01.1.md).

**T01.3 — the credential is the handout.** The training desk served an anonymous client
profile, and every field was a decision: where to send the token (`api_base`), which
resource the client fetched (`request_history`), which instance it was scoped to
(`delivery_id: DL-204`), and the credential itself
(`"authorization": "Bearer courier_DL204_CR17_…"` with `"scope":
["manifest:DL-204:read"]`). The bug is distribution: a capability placed under a public
document root next to deliberately public documents. The test is the three-way status
read above; the horizontal variant is asking for `DL-205` with `DL-204`'s token and getting
`200`, which proves the server authenticates the token but never binds it to the instance.
"Retired" was a lifecycle word, not a revocation — the file still authenticated. Full card:
[`../writeups/T01.3.md`](../writeups/T01.3.md).

**K05.1 — config disclosure without a secret.** The same lesson has a milder form. A
published client reference at `/.well-known/<vendor>-client` documented a validation route
and shipped a working example request; replaying that example to
`POST /api/consumer-checks` returned a check result, an identifier, and normalised fields.
No credential was stolen, but a **self-documenting interface is a live oracle**: the
published config told an outsider exactly which route, schema version and payload shape to
use, and the validator echoed structure back. The response was recorded as a check result
plus identifier, not a transcript, so treat the replay as the technique rather than captured
output. Full card: [`../writeups/K05.1.md`](../writeups/K05.1.md).

## 6. Variations and near-misses

The same bug with different packaging:

- **Base64 "obfuscation"** in `.npmrc`/`.netrc`: reversible, still a bearer secret at rest.
- **Environment variables**: masked in the CI UI, visible in `docker inspect`,
  `/proc/*/environ`, crash dumps, child processes, and any step that prints `env`.
- **CI variables at project scope**: readable by anyone who can edit a pipeline — editing
  the pipeline is the exfiltration primitive.
- **kubeconfig / client certificates**: no password at all; the certificate *is* the
  identity, often valid for a year, often cluster-admin in a namespace.
- **Connection strings**: `postgres://user:pass@host/db` combines endpoint and secret in
  one line, so a leak is also a map.
- **`.pgpass` / `.netrc` permissions**: mode `0600` protects against other local users, not
  against an attacker who already has your shell, a backup, or the disk image.
- **Scope declared but partially enforced**: object and verb checked, instance not (T01.3);
  or instance checked, verb not. Test one dimension at a time.

What does **not** count:

- A **public key**, a certificate without its private key, or a `kid` — verification
  material, not signing authority.
- A **placeholder**: `YOUR_TOKEN_HERE`, `${NPM_TOKEN}`, `<redacted>`, an example value in
  documentation.
- A token that returns `401` because it was genuinely revoked or expired. Verify; do not
  claim a leak because a string looks like a token.
- An **OAuth public client id** with no secret (PKCE clients are designed to be public).
- A `scope` field that is enforced: `403` on the neighbouring object is the control working.
- A credential to a host that does not exist or an account with no permissions — still
  hygiene debt, but not the access finding you are claiming.

## 7. How to fix it

- **Separate config from credentials.** Public profiles carry endpoints, schema versions and
  a *reference* to a secret (`credential_provider: "os-keyring"`), never the secret itself.
- **Stop storing plaintext at rest.** Use the OS keyring, an SSH agent, a cloud workload
  identity, or a short-lived token minted per process. A file that must exist should be
  `0600`, generated at runtime, and deleted at exit.
- **Issue per-service, least-privilege, short-TTL credentials.** No single token for git,
  CI and reporting. Bind tokens to a principal and an audience, and log the token id per
  request so one credential used by two services is visible.
- **Enforce scope at the resource server, on all three axes.** Resolve the object, then
  assert object + instance + verb for the presented principal; return `403`, not a filtered
  list. A scope that is not checked server-side is a comment.
- **Make revocation real.** Deleting a file, retiring a directory or marking a client
  "legacy" does not revoke. Revoke in the issuer, rotate the secret, and invalidate
  sessions and certificates.
- **Add guardrails.** Fail the build if a credential-shaped file or an inline
  `user:token@` remote is present; scan images and repos for high-entropy strings; audit
  anonymous static roots for JSON containing `authorization`.

## 8. Exercises

1. **Build the vulnerable desk, then break it.** Write a 30-line Flask app that serves
   `/profile.json` containing `{"api_base": "...", "authorization": "Bearer t1",
   "scope": ["doc:A:read"]}` and a `/doc/<id>` route. Implement the scope check in two
   versions: one that checks only the token, one that checks token + id. Use `curl` to show
   `200` on `/doc/B` in the first and `403` in the second. Write one sentence naming the
   missing check.
2. **Spot it in a snippet.** Given these four lines, say which are secrets, which are paths,
   and what a single read of the file grants:
   `credential.helper = store --file ~/.config/git/credentials`,
   `//registry.example.test/:_auth=cm93YW46dG9rZW4=`,
   `[fieldlink] user=report_ro`, `data.example.test:5432:db:report_ro:<password>`.
   Decode the base64 and state the username without printing the token.
3. **Predict the response.** A token declares `scope: ["manifest:DL-204:read"]`. Predict the
   status for (a) `GET /manifest/DL-204`, (b) the same request with no header, (c)
   `GET /manifest/DL-205`, (d) `DELETE /manifest/DL-204`. Then say which of the four
   statuses would prove a bug and which would prove the control works.
