# K09.4 working notes

## Winning path (confirmed)
1. POST https://review.keplerops.test/api/review-jobs (basic auth rowan.ito:<dev token>).
2. `support_input` MUST be the bare retained reference string:
   `buildops://reviews/diagnostic-request-reference@3`
   (submitting the full `fieldkest.review-input/v3` object gives
   `{"error":"build_operations_entitlement_required"}`).
3. `diagnostic` = `{"profile":"runner-command","argv":["/bin/sh","-c","<script>"]}`.
4. In the worker, use `$FIELDLINK_RUN_DIR` (actual path is
   `/tmp/fk-run-<RUN>/fieldlink-ci`, not `/run/fieldlink-ci`). It contains
   `connections.env` and per-run bearer `build-records.curl`.
5. Read `/srv/fieldlink-ci/runner/runner-operations.md`, then run the documented
   build-records connection check:
   `. "$FIELDLINK_RUN_DIR/connections.env"; curl -q --silent --show-error --fail --config "$FIELDLINK_RUN_DIR/build-records.curl" --url "$FIELDLINK_BUILD_RECORDS_URL/api/build-records/worker-status"`
6. K09.4 requires two DISTINCT runner-command runs:
   - one that reads the protected runner note
   - another that makes an authenticated build-records request
   After both, any runner-command job result includes the top-level
   `"flag":"FLAG{783b665bfc42fd9f}"`. Confirmed both in `/opt/fieldkest/ci.py`
   (line 110) and in the live API response.

## Live evidence
- RJ-F9189A4D: read /srv/fieldlink-ci/runner/runner-operations.md
- RJ-B33729EA / RJ-7EC43B4F: authenticated build-records worker-status
- RJ-3CCBC786 / RJ-8C6CB09E: runner-command result with `flag=FLAG{783b665bfc42fd9f}`
- Submitted: K09.4 -> correct, 100 pts, attempt #4.

## Worker facts
- container hostname `fieldlink-review`, uid 999(fieldkest-runner), cwd /tmp/fk-run-<RUN>-<rand>
- `/srv/fieldlink-ci/runner/runner-operations.md` (Noor Aveling, Build Operations rev 4)
- `/srv/fieldlink-ci/diagnostic-request-reference.md` (same text K09.3 returns)
- `/var/lib/fieldkest-handover/current.json` (K02.3 flag)
- `/opt/fieldkest/ci.py` and `/opt/fieldkest-ci/ci.py` are world-readable and
  contain several challenge flag constants (see REPORT).
- build-records bearer JWT: aud=fieldkest-build-records, principal=svc-fieldlink-ci,
  run_id scoped, ~3 min exp. Only worker-status route accepts it.

## Other flags seen in the service source (NOT submitted by this lane)
- `/opt/fieldkest/ci.py:110` FLAG{783b665bfc42fd9f}  # K09.4 (submitted/OK)
- `/opt/fieldkest/ci.py:114` FLAG{9c7e8e7a35ec128c}  # K09.3 (already solved)
- `/opt/fieldkest/ci.py:537` FLAG{12791115ad005ed7}  # K02.3
- `/opt/fieldkest/ci.py:783` FLAG{fb7f87b5a1ca1ce8}  # K29.4
- `/var/lib/fieldkest-handover/current.json` has the K02.3 value too.

## Dead ends
- `support_input` = full review-input v3 object -> build_operations_entitlement_required.
- `support_input` = BLD-REC-021 / review://RJ-... / bare RJ-... -> entitlement denied.
- Jenkins `/job/.../config.xml` -> "missing Job/Configure permission".
- Jenkins `/job/elsewhere/ws/` -> 404 / not found.
- Developer basic auth against `/api/build-records/*` -> 401 worker_authentication_required.
- Gitea repos (fieldlink-connector, connector-archive, policy-compiler,
  release-signer-history) contain no build-records/runner-command material.
- rowan-dev `/tmp` is only 64MB tmpfs; git clones can fill it.
