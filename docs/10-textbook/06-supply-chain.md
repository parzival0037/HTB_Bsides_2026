# 06 — Supply chain: metadata, hooks, contracts, signatures

## 1. What this class of bug is

You add a dependency, a plugin, a formatter, and something runs with your privileges. The
consumer decides whether to trust it from *metadata* — name, version, dist-tag, interface
conformance, key id — while what executes is *content* nobody bound to that metadata.

**Precise definition:** trust is decided on a mutable or forgeable attribute (name/scope,
dist-tag, declared version, interface conformance, key id) instead of authenticated content
bound to a publisher and a build, so control of that attribute yields code execution in the
consumer or write access to its trusted output. Four surfaces carry it:

| Surface | What is trusted | What the attacker gets |
|---|---|---|
| Install hooks | the package will behave like a library | code execution as the installer, with CI secrets in env |
| Plugin/provider slot | anything satisfying the interface is a legitimate producer | write access to the report everyone downstream believes |
| Version metadata | `latest`, a range, a channel slot describes what runs | the wrong bytes installed, or a false support answer |
| Signing/provenance | a valid signature or key id means the accepted lineage | acceptance of an artefact the lineage never authorised |

## 2. Why it exists

The root assumption is **"a package is data, not a program, and its name is its identity."**
Both halves are wrong.

- **"Installation is inert."** Every mainstream ecosystem runs code at install: npm
  `preinstall`/`install`/`postinstall`, Python `setup.py` or a build backend, RPM `%post`,
  Debian `postinst`, Rust `build.rs`. The hook runs before review of the library matters.
- **"The registry name is the publisher."** Names are registrable, scopes claimable,
  dist-tags mutable, tarball URLs arbitrary. Identity must be verified, not inferred.
- **"Conforming means correct."** A validator proves schema and types, not that the
  observations were taken. Shape is not provenance.
- **"Signed once, trusted forever."** A signature binds bytes to a key, not to policy.
  Exact-key pinning invalidates everything signed before a rotation; lineage checking keeps
  old releases verifiable while new ones need the successor.
- **"`latest` is what runs."** A dist-tag says what a resolver would pick now. It says
  nothing about what a tenant installed, retained, or rolled back to.

The sentence that ties the chapter together: **authority is inferred from metadata instead
of verified from content.**

## 3. How to spot it

- **Hook files:** `package.json` `scripts.preinstall|install|postinstall|prepare`,
  `setup.py` with a custom `cmdclass`, `pyproject.toml` `build-backend`, `*.postinst`,
  RPM `%post`, `build.rs`, gem `extensions`.
- **Hook behaviour that is not build behaviour:** reads `~/.ssh`, `~/.aws`, `.npmrc`,
  `.env`, `process.env`, `/etc`; opens a socket; base64 + `exec`; string-splitting to hide a
  URL. `strings` over a bundled hook is usually enough.
- **Metadata smells:** `latest` moved to a version with a new `postinstall`; a dependency
  with install scripts but no build step; a `deprecated` field; a version in metadata that
  is absent from the channel slot.
- **Contract documents:** `/.well-known/<vendor>-client` entries with `extension_point`,
  `entrypoint`, `expected_interface`, `required_files`, `submit_job`, and upload routes such
  as `buildWithParameters`, `PUT /api/packages/…`, or an approval route.
- **Signature metadata:** `algorithm`, `key_id`, `lineage`, `rollover`, `verification.reason`
  (`gpg.error.not_signed_commit`), release records naming commit + lineage, and dossier
  fields like `deleted_commit` or `rollover_record.passphrase_half`.
- **Response differences:** `result: SUCCESS` while the report's assessment disagrees with
  the metrics; a validator returns `200` plus parsed fields; an artefact accepted from a
  publisher that never authored the package; installed version ≠ manifest ≠ ticket.
- **Consumer-side wording:** "any package that satisfies the interface", "for
  compatibility", "the verifier accepts the current key".

## 4. How to test it

Treat a package as an executable artefact and read it statically. Do not install it to find
out what installation does.

```bash
# 1. Identify and list without extracting into your working tree.
file ./pkg.tgz
tar tzf ./pkg.tgz | head -40              # or: unzip -l, ar t, dpkg-deb -c

# 2. Extract into a throwaway directory and find the hook set; then
#    answer: what runs, what data, what sink — in that order.
mkdir -p /tmp/pkg && tar xzf ./pkg.tgz -C /tmp/pkg
find /tmp/pkg -maxdepth 3 \( -name setup.py -o -name package.json \
  -o -name pyproject.toml -o -name '*.postinst' -o -name build.rs \) -print
jq '.scripts // {}' /tmp/pkg/package/package.json
grep -rnE 'child_process|execSync|spawn|https?://|\.ssh|\.aws|\.npmrc|process\.env' /tmp/pkg
strings /tmp/pkg/**/hook* 2>/dev/null | grep -E '^https?://|/\.'
```

`file`/`tar` answer "what files"; `jq .scripts` answers "what runs at install"; the grep
answers "what data and destination". A finding is a sentence — *this hook reads X and sends
it to Y* — not a payload. Compiling native code is normal; data leaving the tree is not.

Metadata next: what *would* be installed, and what does the registry claim about it?

```bash
curl -sS https://registry.example.test/@scope%2fname \
  | jq '{tags: .["dist-tags"], versions: (.versions | keys)}'
curl -sS https://registry.example.test/@scope%2fname \
  | jq '.versions["1.2.3"] | {scripts, dist, deprecated}'
```

The `dist-tags` map is a pointer, not a deployment record: compare it with the channel slot,
the customer record, and the file actually present. A version range is a *query*; the
resolver's answer is evidence you collect (installed file + digest), not the label itself.

Provenance and contract, when they exist:

```bash
openssl dgst -sha256 -verify pub.pem -signature sig.bin ./pkg.tgz
curl -sS https://target:8443/.well-known/app-client \
  | jq '.routes[] | select(.key|test("publish|check|provider|approval"))'
curl -sS -u "$U:$P" https://target:8443/api/releases/<id> | jq '{release, signatures, lineage}'
```

`dgst` gives one bit — these bytes match this key — and nothing about whether that key may
sign this release. The contract tells you which gate exists; an upload route with no
publisher check is the finding. For anything you must execute: disposable container, fake
`HOME`, no registry or cloud credentials, scripts disabled where possible
(`npm ci --ignore-scripts`). A package that needs the network to install is itself a signal.

## 5. Case study from this range

**T03.3 — what installation really runs.** The developer-artifacts desk supplied a package
and explicitly forbade installing it. The task: recover three facts — the extra action
installation triggers, the data involved, its destination. That is the static method above,
tracing every file open, environment lookup, subprocess and network client. The card traps
impatience: installing "just to see" executes the payload in an environment that may hold
the credentials you are protecting. No transcript was retained, so the shell above is a
template, not captured output. [`../writeups/T03.3.md`](../writeups/T03.3.md)

**The provider slot — K02.3 and T03.4.** A CI job imported `provider.zip`, loaded
`provider.py` and published whatever `render_report` returned. The review note published
the contract verbatim: `expected_interface: fieldkest.report/v2`, `extension_point:
report_provider`, `required_files: ["provider.py", "fixture.json"]`,
`submit_job: fieldlink-report-review`, `immutable_fields: asset_id, connector_revision,
captured_at, observations`, `mutable_fields: assessment.rating, assessment.summary`. The
submitted provider was honest about the interface and changed only the mutable field:

```python
def render_report(fixture):
    report = {k: fixture[k] for k in fixture}   # every immutable field preserved
    report["assessment"] = {"rating": "callback-review-required",
                            "summary": "Cinder review: 1840 ms exceeds the 250 ms limit …"}
    return report
```

The build went green — `result: SUCCESS` — and the support handover became
`fieldkest.support-handover/v1` with `state: "success"` and the changed assessment. Nothing
was bypassed: the provider satisfied the contract, and the validator proved *shape*, not
*truth*. (Operational trap: Jenkins' CSRF crumb must share a cookie jar with the POST, or
you get `403 No valid crumb`, which looks like a permission problem.) T03.4 is the same bug
on the training desk: a formatter satisfying the documented interface writes a marker into
the consumer's delivery report — compatibility is the only gate.
[`../writeups/K02.3.md`](../writeups/K02.3.md) · [`../writeups/T03.4.md`](../writeups/T03.4.md)

**Capability scope and signing — K29.1, K29.2, K29.4.** Build dossier `BLD-REL-742`
(`release_principal: release-reader`, `status: retained`) returned an opaque
`exchange_handle`; exchanging it yielded a token whose subject was `svc-fieldlink-export`,
audience `release-reader`, role `role/support-export-editor` — a mismatch worth noticing.
The consumer's check was the whole bug:

```python
_release_reader_auth = (
    self.headers.get("Authorization") == f"Bearer {RELEASE_READER_TOKEN}"
    and "/artifacts/" in path
    and path.startswith("/api/runs/")
)
```

One module-level token compared as a magic string, and a **substring** test for
`/artifacts/` instead of resolving the path and comparing the run id to the dossier it was
minted for. The scope was therefore "any retained artefact on any run".

The signing half uses the same index. Commit `ae381c7` "Record encrypted release signer
rollover" *added* `secrets/release-signer.enc.json`; `9c3bcec` "Publish verification key and
retire signer object" *removed* it and added `release-public-key.json` (`algorithm:
Ed25519`, `key_id: fk-release-2026-old`, `lineage: fieldkest-release-2026`). The public key
is meant to be readable and grants nothing; the private half survived in history, and the
dossier's `passphrase_half` plus the retained rollover record made it usable. The dossier's
own `deleted_commit` was stale and returned `object does not exist` — the commit list, not
the metadata pointer, is the source of truth. K29.4 inverts it: a verifier pinned to the
exact current `key_id` rejects everything signed before the rollover, so continuity needs a
lineage check and an overlap window with dual signatures.
[`../writeups/K29.1.md`](../writeups/K29.1.md) · [`../writeups/K29.2.md`](../writeups/K29.2.md) ·
[`../writeups/K29.4.md`](../writeups/K29.4.md)

**Which version they kept — K05.2.** Package metadata exposed `dist-tags.latest 7.4.2`,
`pending_release 7.4.3-cinder.rset1`, legacy `6.9.8` (with a `deprecated` field) and
`rollback_slot: 7.4.2`; the support ticket said the tenant ran `6.9.8`. Three claims, three
questions: released, promoted, retained. The customer record was unreachable with the
available database role (`permission denied for schema support`), so the supported route was
tenant–package reconciliation. Answering `7.4.2` because it is newest is the tested error.
[`../writeups/K05.2.md`](../writeups/K05.2.md)

## 6. Variations and near-misses

- **Identity attacks, same shape:** typosquatting, dependency confusion across public and
  private scopes, a compromised maintainer account. The hook may be identical; only the
  route into the trusted name changes.
- **Install-time vs load-time.** A package with no hook can still execute on
  `require`/`import`; hook review is necessary, not sufficient.
- **Signed upload, unsigned load.** The registry verifies at publish, then serves by tag to
  a consumer that never re-verifies.
- **Verification granularity.** "signature invalid", "key expired", "key not accepted" are
  different failures; exact-key pinning breaks rotation, lineage-only checking can accept a
  key retired for cause.
- **Metadata-only changes.** Moving `latest` changes what new installs get without touching
  a byte; transitive reach makes one compromised leaf run in every downstream build.

What does **not** count:

- A `postinstall` that compiles native code or fetches a prebuilt binary from the same
  publisher, with no data access and no unknown destination.
- A `deprecated` field or an old version still in metadata — informational.
- A version mismatch caused by documentation lag (K05.2) is a process bug, not a compromise.
- A **public** verification key in a repository, even a retired one: it grants nothing by
  itself.
- A valid signature over malicious code from the legitimate publisher: the signature works;
  the publisher is compromised. Report it as such.
- A provider that returns a valid report with a different *assessment*: that is the bug only
  if the assessment is supposed to be derived from observations the provider did not make —
  say which field is unbound rather than calling any output "forged".

## 7. How to fix it

- **Consumers:** lockfiles with integrity hashes, scripts disabled where possible, mirrored
  dependencies, and a build sandbox with no registry, cloud or SSH credentials. Review the
  hook set of every new direct dependency.
- **Producers and registries:** sign the build, not just the tag; publish an attestation
  binding publisher, source commit and digest (sigstore/in-toto style), and verify digest +
  publisher at install/load, not only at upload.
- **Plugin slots:** allow-list publishers, pin version **and** digest per consumer, run the
  plugin in a sandbox taking raw input in and returning only the report value, and keep the
  raw result beside the report so they can be diffed. Enforce immutable fields server-side
  and recompute derived fields from raw data.
- **Version truth:** expose one "effective version" resolver (tenant → channel → release)
  labelling each layer and its source; never answer "what does this customer run?" from a
  manifest or a `latest` tag.
- **Key lifecycle:** verify lineage membership **and** validity at signing time; publish a
  key history with an overlap window; require dual signatures during rotation; publish and
  honour a revocation list.
- **Never commit key material**, even wrapped with a split passphrase. Keep signing keys in
  an HSM/KMS behind a signing oracle; log principal and digest of every accepted artefact.

## 8. Exercises

1. **Build the hook and read it without running it.** Create a local npm package whose
   `postinstall` writes `process.env` to a file and POSTs it to `http://127.0.0.1:9999`.
   Inspect it with `tar tzf`, `jq .scripts`, `grep -rnE 'process\.env|http://'`. Install it
   twice — once with `--ignore-scripts`, once in a container with a fake home and a local
   listener — and state the three facts (action, data, destination) before each run.
2. **Break a shape-only validator.** Write a 40-line service with a `render_report`
   extension point and a validator checking `schema`, required keys and types. Submit a
   provider returning a valid report with `assessment: "pass"` and no observations; confirm
   it is accepted. Add an input digest and a signature check; show it now fails. Name the
   check in one sentence.
3. **Answer the version question with evidence.** Given `dist-tags.latest = 7.4.2`, a
   channel `rollback_slot = 7.4.2`, `pending_release = 7.4.3-…`, and a ticket claiming
   `6.9.8`, write the requests that establish what the tenant retained. For each, say what
   `200`/`403`/`404` tells you and which single answer goes in the ticket.
