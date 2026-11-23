# K02 lane report — ALL THREE SOLVED (verified with submit.py)

Lane: K02 (KeplerOps chapter 02 "report fixture / report provider / review job")
Work dir: /home/kali/ctf/lanes/k02

## Flags submitted (all correct)

| Challenge | Flag | Where it came from |
|---|---|---|
| K02.1 The missing fixture (50p) | `FLAG{7db9f86b38c288ab}` | Jenkins `fieldlink-report` #1842 **consoleText** (last line before "Build step ... marked as failure"). Jenkins artifact: `GET /job/fieldlink-report/1842/consoleText` (basic auth rowan.ito). |
| K02.2 An input outside its lane (50p) | `FLAG{ad920ac857c12cd3}` | Retained **review note** `REVNOTE-1842.json`: Jenkins artifact `GET /job/fieldlink-report/1842/artifact/reports/REVNOTE-1842.json` (field `review_token`) and job workspace zip `/job/fieldlink-report/ws/*zip*/ws.zip` (field `flag`). |
| K02.3 Green, with our changes (100p) | `FLAG{12791115ad005ed7}` | **Support handover current** returned after our successful provider submission: `GET https://support.keplerops.test:8443/api/handovers/current` (bearer `fk_support_rowan_...`). Handover `schema=fieldkest.support-handover/v1`, `state=success`, `job_id=JOB-BA11FC0CCB19`, report = Cinder's changed assessment. |

submit.py results: K02.1 correct, K02.2 correct, K02.3 correct.

## Exact technique

### K02.1 — recover the fixture
Repo `fieldkest/fieldlink-connector` on Gitea `https://source.keplerops.test`
(auth `rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`).

- `main` = `c37effd7cc86ae4d44f18e95f899b7557d65e0a9` "remove generated report fixture from tree".
- tag `fk-test-6d1e9f7` = `80560bcf8381c36ef82be771e58fc164a349ea07` "add CRR-OG2 report fixture".
- Recover exact bytes (532 B, sha256 `da511020fa2f2e23ec74ea3e8e2f8e19452ae90bcdd32fea2e0602b8573d6564`):
  `GET /api/v1/repos/fieldkest/fieldlink-connector/raw/fixtures/report-crr-og2.json?ref=fk-test-6d1e9f7`
  (the review note's baseline ref is exactly `fk-test-6d1e9f7`).
- The failing build's console (a retained development artifact) carries K02.1's flag.

Fixture content: schema fieldkest.report/v2, report_id RPT-CRR-OG2-BASELINE,
asset_id CRR-OG2, connector_revision FLK-7.4.2, captured_at 2026-09-18T14:22:16Z,
observations (connector-heartbeat delayed 1840 ms; archive-synchronization ok 28),
assessment {observe, "Connector responds, but heartbeat latency should be reviewed."}.
Note: 532-byte file ends with `}\n` plus an extra trailing newline — byte-exact matters
for the review consumer digest binding.

### K02.2 — review note / input contract
The Jenkins build retained a review note separate from the console log:
`reports/REVNOTE-1842.json` (artifact and workspace). The review worker's own copy
(`GET https://review.keplerops.test/api/runs/BLD-1842/artifacts/REVNOTE-1842.json`) is
sanitized (no token) but publishes the machine-readable provider contract:

```
expected_interface: fieldkest.report/v2
extension_point: report_provider        (provider.py with render_report(fixture) -> dict)
archive_layout: provider.py, fixture.json (zip root)
submit_job: fieldlink-report-review     (FileParameter provider.zip)
immutable_fields: asset_id, connector_revision, captured_at, observations
mutable_fields: assessment.rating, assessment.summary
baseline: fieldkest/fieldlink-connector @ fk-test-6d1e9f7 : fixtures/report-crr-og2.json
```

Docs also at repo `docs/report-provider.md`; consumer binds `fixture.json` to the
baseline by SHA-256 of its exact bytes (copy the recovered file, do not re-serialize).

### K02.3 — change the report, keep the interface, succeed
Built `provider.zip` (zip root: `provider.py` + byte-exact `fixture.json`) on the range
box and submitted it to Jenkins job `fieldlink-report-review` (FileParameter
`provider.zip`) with basic auth + CSRF crumb tied to the same cookie jar:

```bash
CRUMB=$(curl ... -c cj https://ci.keplerops.test/crumbIssuer/api/json | jq -r .crumb)
curl ... -u "$AUTH" -b cj -c cj -H "Jenkins-Crumb: $CRUMB" \
     -F "provider.zip=@provider.zip" \
     "https://ci.keplerops.test/job/fieldlink-report-review/buildWithParameters"
# 201 + Location: /queue/item/6  -> build #1 SUCCESS
# console: "Report accepted: JOB-BA11FC0CCB19" / "Report SHA-256: 93b11c..."
# artifacts: reports/report.json, reports/review-result.json
```

provider.py used (keeps every immutable field, only replaces assessment):

```python
def render_report(fixture):
    report = {k: fixture[k] for k in fixture}
    report["assessment"] = {
        "rating": "callback-review-required",
        "summary": "Cinder review: heartbeat latency 1840 ms exceeds the 250 ms connector limit while 28 records remain synchronized; support follow-up required."
    }
    return report
```

Cinder's connector reference: npm `@keplerops/fieldlink-connector@7.4.3-cinder.rset1`
(registry `https://packages.keplerops.test`; `npm pack` on rowan-dev). Its limits are
250 ms max callback latency / minimum 10 samples -> 1840 ms / 28 samples =>
`callback-review-required` (hence the chosen rating).

After success the report is published to support:
`GET https://support.keplerops.test:8443/api/handovers/current` (bearer
`fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b`, supplied in
`/home/kali/ctf/lanes/NETMAP.md`) returned our changed report with `state=success`
and the K02.3 flag.

## Service / endpoint map discovered (K02-relevant)
- Gitea `https://source.keplerops.test` — repo fieldkest/fieldlink-connector (tags,
  branches incl. `delivery-operations` d1b7679, issues). Tag `fk-test-6d1e9f7` holds
  the fixture. Auth: rowan.ito / fk_developer_... (same creds work for Jenkins+review).
- Jenkins `https://ci.keplerops.test` — `fieldlink-report` #1842 FAILURE, consoleText
  (flag), artifacts `reports/{integration-review-input-v3,ordinary-support-input-v1,REVNOTE-1842}.json`,
  workspace browse `/job/fieldlink-report/ws/` and zip `/job/fieldlink-report/ws/*zip*/ws.zip`.
  `fieldlink-report-review` job: FileParameter `provider.zip`, build #1 SUCCESS.
- Review worker `https://review.keplerops.test` — `/.well-known/fieldkest-client`:
  POST /api/jobs, GET /api/jobs/{job}, POST /api/rehearsals/connector,
  GET /api/runs/{run_id}[/log|/artifacts/{name}], POST /api/review-jobs.
  Basic auth rowan.ito. Run BLD-1842 record/log (mentions BLD-REL-742 dossier,
  BLD-REC-021 recovery record which 404s).
- Preview `https://preview.keplerops.test` — associations/reviews/render/prepare.
  (Not needed for K02; its flag belongs to K10.1 — do not submit here.)
- Support `https://support.keplerops.test` osTicket `/scp/` (maya.ranscombe /
  sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk); support API `:8443` with
  `/.well-known/fieldkest-client` (handovers/current, diagnostics jobs).

## Dead ends / notes for later lanes
- K10.1's flag is `FLAG{e79c34cd2ef12e6e}` (preview association source `SUP-K-2841`,
  viewer_request PRV-771, document DOC-9BC054D6F95DFA6A) — belongs to K10.1, NOT K02.
- SUP-2841 osTicket thread carries retention flag `FLAG{408710d448134ab5}` (belongs to
  another retention challenge, not K02).
- rowan-dev local helper `http://127.0.0.1:8701/api/inspection-summary` (sample
  `samples/FK-SAMPLE-017.json`) returns `FLAG{2b66416be507ee69}` — belongs to a
  different (inspection) challenge, not K02.
- Object storage `s3://fieldlink-exports` lists only `backups/company-history.dump`
  (retained collections are not listable; exact keys/digests must come from retained
  material).
- `ssh -D` does not work; use the pre-existing SOCKS5 pivot `127.0.0.1:1080` on the
  range box (tmux `pivot` + remote relay on rowan-dev :13389). Jenkins CSRF crumb must
  share a cookie jar with the POST, otherwise 403 "No valid crumb".

## Downstream dependencies
- K02.2's contract (fieldkest.report/v2, provider.py render_report, immutable vs
  mutable assessment, exact-byte fixture digest binding, submit via
  `fieldlink-report-review`) is the prerequisite for K02.3 and for any later
  report-provider/consumer work (e.g. K06.3 rehearsal consumer, K27.x diagnostic
  packaging).
- The `support.keplerops.test:8443` diagnostics API (`POST /api/customers/{tenant}/diagnostics`,
  `PUT /api/diagnostics/{job}/package` with `expected_output/interface/source`,
  `POST /api/diagnostics/{job}/deliver`) is the ARWC-side counterpart used by
  K27.x/W-chapters and is reachable with the same bearer token from NETMAP.
