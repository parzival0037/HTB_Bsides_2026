# 07 — Crypto and PKI: what a certificate actually asserts

A client certificate is a public key plus a signed sentence: *this CA vouches that this key
belongs to this name, for this purpose, until this date.* Mutual TLS (mTLS) makes the client
prove possession of the key during the handshake, so the server learns that name before the
first HTTP byte. The cryptography is rarely the weak point. What fails is the **issuance
policy** — who the CA is willing to name — and the **authorisation policy** — what the
application decides a name is allowed to read.

## 1. What this class of bug is

Precisely: a certificate asserts `(issuer, subject, public key, EKU, validity)` and nothing
else. It does not assert that the subject is a person, that the subject is unique across
issuers, or that the subject may touch any particular record. Authorisation must combine the
certificate with a policy that says which issuer is trusted *for which subjects* and which
subjects own which objects. When a service indexes data by the subject string and trusts any
certificate its own CA signed, the security of the whole system collapses to one question:
*can a caller obtain a certificate for a name that is not theirs?*

## 2. Why it exists

The mistaken assumption is: **"a valid certificate means a verified identity."** It means a
verified *key*, signed under a policy. Developers collapse three different facts into one:

| Fact | Proved by | Often assumed |
|---|---|---|
| The caller holds this private key | handshake `CertificateVerify` | "the caller is this person" |
| A CA vouched for this name | signature chain | "the CA only vouches for the right people" |
| The name may access this object | application policy | "the name in the cert is the authorisation" |

Three concrete variants of the wrong assumption:

- **Issuance is self-service.** The subject is taken from the request body because "the
  client knows its own name" — safe only if the caller is authorised for that subject. The
  gate is one shared worker token and the only check is the *shape* of the UPN.
- **Issue and disclose.** The enrollment endpoint generates the keypair server-side and
  returns `private_key_pem` next to `certificate_pem`. The caller does not even need to prove
  possession of a key; issuance and key disclosure are one request.
- **The local check is the global check.** The archive compares the certificate subject to
  the handover subject, which is correct in form. It never asks whether the CA was allowed to
  sign that subject, so a locally correct comparison authorises a globally false identity.

A second, quieter assumption belongs to the same chapter: **"encrypted means confidential."**
A sealed record whose passphrase is derived from the very fact it records is not a secret; it
is an offline equality oracle. Whoever can enumerate candidate values can test them without
touching the server.

## 3. How to spot it

- A `401` whose body says `client_cert_required`, or a TLS-layer rejection before any HTTP —
  the check is in the handshake, not in a header.
- Endpoints named `/enrollment/`, `/issue/`, `/ca/`, `/requests`, `/.well-known/…`, or a
  service directory that advertises its own credential-issuing route.
- A template/config response containing `eku: clientAuth`, `provisioner`, `template`, and
  especially `subject_format: "{subject}"` — the subject comes straight from the request.
- A response containing `certificate_pem` **and** `private_key_pem`, or a `.p12` you did not
  generate. Real PKI returns a certificate for a CSR; it never hands back your key.
- Resources addressed by principal: `/archive/handovers/{upn}`, `/users/{email}`,
  `/home/{subject}`. The path segment is a name, and names are claims.
- Distinct error strings that reveal the binding logic: `401 client_cert_required` (no cert),
  `403 subject_mismatch` (cert is fine, object is not yours), `404 handover_not_found`
  (subject has no record). Three different answers map the authorisation model.
- `X-Client-Cert`, `X-SSL-Client-S-DN`, `X-Forwarded-Client-Cert` in a request — a proxy is
  terminating mTLS. The question becomes whether the backend trusts that header from anyone.
- Sealed artefacts: `.enc`, `.sealed`, `captures/`, a document explaining the passphrase
  convention, or a client that decrypts locally. A hash used as a password is a red flag.

## 4. How to test it

Work from the outside in, one question per request. Use your own test identity, in a lab or
under written scope; never enroll a colleague's real identity on a live system.

```bash
# 1. Does the endpoint require mTLS at all?
curl -sS -o /dev/null -w '%{http_code}\n' https://target:8443/api/archive/handovers/me@example.test
# 401 -> handshake-level. Try the same with a spoofed header; still 401 means headers are ignored.

# 2. What does the server ask for in the handshake?
openssl s_client -connect target:8443 -servername target -cert me.crt -key me.key \
  -CAfile ca.pem </dev/null 2>&1 | grep -E 'Acceptable client certificate|Verify return'
# A list of acceptable CAs tells you which issuer the app trusts.

# 3. What does your own certificate actually say?
openssl x509 -in me.crt -noout -subject -issuer -dates \
  -ext extendedKeyUsage -ext subjectAltName
# Compare EKU with how the app uses it. clientAuth is the only correct value for a client.

# 4. Read the published contract before touching the issuer.
curl -sS https://target:8443/api/service-directory | jq .
curl -sS https://target:8443/api/enrollment/StaffArchiveUser | jq .
# subject_format "{subject}" + a shared worker token = the subject is caller-chosen.
```

The decisive test is a **pair**, not a single request. Ask for a record that belongs to the
subject in your certificate (expect `200`), then ask for a record addressed by a different
subject or a non-subject id:

```bash
curl -sS --cert me.crt --key me.key \
  https://target:8443/api/archive/handovers/me@example.test          # 200
curl -sS --cert me.crt --key me.key \
  https://target:8443/api/archive/handovers/other@example.test      # 403 or 404?
```

`403 subject_mismatch` proves the app enforces subject binding but trusts the CA's issuance.
`404` proves the object lookup is keyed by the path, with no ownership check at all. Both are
findings; they are different bugs with different fixes.

For the issuer, the safe question is: *does it validate anything except shape?*

```bash
curl -sS -X POST -H "Authorization: Bearer $ENROLL_TOKEN" \
  -H 'Content-Type: application/json' -d '{"upn":"not-a-principal"}' \
  https://target:8443/api/enrollment/StaffArchiveUser/requests
# 422 invalid_upn -> shape check only. Does "someone@example.test" get signed, with a key?
```

Sealed records are tested offline, on a copy:

```bash
printf '%s' '1200.0:VC-017' | sha256sum     # candidate value : record id
openssl enc -d -aes-256-cbc -pbkdf2 \
  -pass "pass:$(printf '%s' '1200.0:VC-017' | sha256sum | cut -d' ' -f1)" \
  -in volume-sealed.enc -out volume.plain && echo DECRYPTED
```

Valid padding plus a parseable body means the candidate is right. Garbage means the candidate
is wrong — or that your serialisation differs from the producer's (see near-misses). Check
`$?`; `openssl enc` fails loudly on bad padding, which is exactly the oracle.

## 5. Case study from this range

**K19.1 / K19.2 — the CA that signs any name.** A developer credential reads
`GET /api/service-directory` on `staff.keplerops.test`, which advertises the archive subject,
the enrollment endpoint, and the enrollment worker token in one JSON object. The enrollment
template then reports `subject_format: "{subject}"`, `eku: clientAuth`.

```bash
curl -sS -k -X POST \
  -H 'Authorization: Bearer fk_cert_enrollment_…' \
  -H 'Content-Type: application/json' \
  -d '{"upn":"<subject>@keplerops.test"}' \
  https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests
```

The response contains `upn`, `eku: "clientAuth"`, `certificate_pem`, `private_key_pem`, and a
`flag`. Two details are the whole lesson. First, the private key comes back: the issuer is not
binding a key to a person, it is minting an identity and mailing it. Second, the `flag` is
*identical for every UPN*. A per-identity record would differ; an identical value proves the
response is a template evaluation, not a lookup of the named principal.

Presenting the keypair to the archive is an ordinary mTLS request:
```bash
curl -sS -k --cert subject.crt --key subject.key \
  https://staff.keplerops.test/api/archive/handovers/<subject>@keplerops.test
```

It returns the archive record — `archive: "REL-FLK-7.4.2-11"`, `provisioner:
"keplerops-staff"`, `delegation_spn: "HTTP/staff.keplerops.test@KEPLEROPS.TEST"`, and
`FLAG{e47f6aa72d8045aa}`. The controls are what make it conclusive: a colleague's subject
returns `404 handover_not_found`, and `/api/archive/handovers/DIAG-CRR-MIXED-19` with a valid
certificate returns `403 subject_mismatch`. The service *is* checking subject binding. It just
trusts whichever subject the CA signed — and the CA signed whatever the worker token asked
for, after a regex-shaped check that rejected `arwc-connector-consumer` with `422 invalid_upn`
but accepted any `@keplerops.test` name.

No cryptography was broken. The chain is: leaked worker token → caller-chosen subject →
valid `clientAuth` certificate → archive authorises on subject → colleague's data. Read
[K19.1](../writeups/K19.1.md) and [K19.2](../writeups/K19.2.md) for the full transcript.

**T04.1 — the sealed record as an oracle.** A training desk ships an observation `VC-017`
carrying both `requested_volume_l = 1000.0` (intent) and `observed_volume_l = 1200.0`
(measurement), plus `captures/volume-sealed.enc`. The sealing convention is a passphrase of
`sha256("<value>:<record-id>")`, so the *interpretation* is the key:

```
sha256("1200.0:VC-017")  -> decrypts, yields the flag
sha256("1000.0:VC-017")  -> padding failure
```

The record does not hide the answer; it makes the answer checkable offline. That is useful
when the ambiguity is real (two plausible numbers, two plausible scales) and dangerous when
the sealed blob is treated as proof of confidentiality. The openssl block in the write-up is
marked illustrative; the convention and the result are recorded. See
[T04.1](../writeups/T04.1.md). Chapter 11 covers the measurement-versus-setpoint reasoning;
here the point is cryptographic: **a key derived from the claim is a verifier, not a secret.**

## 6. Variations and near-misses

- **EKU not checked.** A `serverAuth` certificate accepted as a client identity. The bug is
  the missing EKU check *combined with* subject-based authorisation; the certificate alone is
  not an exploit.
- **SAN vs CN confusion.** The CA constrains `subjectAltName`, the app parses `CN` (or the
  reverse). Two different names for one certificate, and the weaker one wins.
- **mTLS terminated at a proxy.** The backend trusts `X-Client-Cert` from any source, so the
  TLS layer protects the proxy, not the application. Test by sending the header directly to
  the backend port with no certificate.
- **Per-tenant intermediate CAs.** A CA that signs any subject *within a namespace the caller
  controls* is not this bug; the authorisation boundary is the intermediate, and the subject
  is scoped by it. Check what the issuer is allowed to sign, not just that it signs.
- **Self-signed accepted.** That is "no PKI", a different and blunter bug. It still needs a
  subject-based authorisation flaw to become data disclosure.
- **Case and canonicalisation.** `Alice@example.test` and `alice@example.test` may be two
  certificates for one principal. If the issuer checks shape and the app compares strings
  exactly, you get two identities — or a bypass of a deny-list.
- **Sealed-record false negatives.** The same logical JSON serialises many ways: key order,
  whitespace, `1200` vs `1200.0`, trailing newline. If the producer hashed canonical JSON
  (RFC 8785) and you hashed `json.dumps`, a mismatch means *your bytes differ*, not that the
  value is wrong. The range's convention is a plain `"<value>:<record-id>"` string; when you
  meet digest-sealed JSON elsewhere, canonicalise first.
- **Not the bug:** a `401` without a certificate, a `403 subject_mismatch`, or a CA issuing a
  certificate to an authenticated principal for its own subject. Those are the controls
  working.

## 7. How to fix it

- **Derive the subject from the authenticated principal**, never from the request body. If an
  operator must enroll on behalf of someone, require an explicit, audited authorisation
  record, and restrict the template to that subject.
- **Generate keys client-side.** Accept a CSR, return only the certificate. Never transmit or
  store a private key you generated for someone else.
- **Constrain the certificate**: `eku=clientAuth`, `basicConstraints CA:FALSE`, short
  validity, and a per-template role allow-list. Log `(requester, subject, template, serial)`
  and alert when one token enrolls many subjects.
- **Authorise objects, not names.** Bind each record to `(issuer, subject)` and verify that
  the issuer's policy permits that subject. Index by an immutable id, not by a path segment
  the caller supplies.
- **Make revocation real**: short TTLs plus a revocation path, and rotate the enrollment
  credential on leak. A certificate for a colleague's name *is* their data access.
- **Seal with real keys.** Use AEAD (AES-GCM, `age`) with a key from a KMS or secret store,
  not a digest of the plaintext. If you need a binding, hash canonical JSON with a
  domain-separated label, and never treat "decryption succeeded" as authorisation.

## 8. Exercises

1. **Build the bug, then fix it.** With `openssl`, create a lab CA and a 30-line Python
   enrollment endpoint that signs any `{"upn": ...}` it is given (server-side keypair). Add an
   app route `/whoami/<upn>` that returns 200 only when the mTLS subject matches the path.
   Show the two `curl` commands that read another name, then change enrollment to derive the
   subject from a bearer token and re-run both — the second must now fail.
2. **Spot it in a snippet.** Given `cn = request.json["upn"]; cert, key = ca.sign(cn); return
   {"cert": cert, "key": key}`, list three distinct fixes and say which one stops the attack
   even if the worker token leaks.
3. **Predict, then canonicalise.** An enrollment service validates `^[^@]+@example\.test$`
   and signs the subject verbatim; the archive compares `cert.subject == path` byte-for-byte.
   Predict what happens for `Admin@example.test`, `admin@example.test`, and
   `admin@example.test.`, and say which case is a real vulnerability rather than a naming
   collision. Then seal a JSON object with `sha256` of `json.dumps(..., sort_keys=True)`,
   verify with plain `json.dumps`, and explain why a semantically identical object fails.
