set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test:8443
AUTH='Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
echo "===== support wellknown ====="
curl -sSk -m 8 "$B/.well-known/fieldkest-client"; echo
echo "===== handovers/current ====="
curl -sSk -m 8 -i -H "$AUTH" "$B/api/handovers/current"; echo
echo "===== customers/arwc diagnostics probe ====="
curl -sSk -m 8 -i -H "$AUTH" "$B/api/customers/arwc/diagnostics"; echo
echo "===== diagnostics guesses ====="
for p in /api/diagnostics/DIAG-CRR-MIXED-19 /api/diagnostics/DIAG-CRR-MIXED-19/handover /api/customers/arwc /api/customers/arwc/handovers /api/exports/EXP-2841; do
  echo "--- $p"
  curl -sSk -m 8 -i -H "$AUTH" "$B$p" | head -20
done
echo "===== STAFF basic auth probes ====="
S2=https://staff.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "--- directory"
curl -sSk -m 8 -u "$U" "$S2/api/service-directory"; echo
echo "--- notes list"
for p in /api/notes /api/notes/ /api/notes/NOTE-SUP-2841-7 /api/notes/NOTE-SUP-2841-7/raw /api/notes/CINDER /api/notes/cinder /api/notes/NOTE-CINDER-1 /api/notes/CASE-CINDER; do
  echo "--- $p"
  curl -sSk -m 8 -u "$U" -w '\n[%{http_code}]\n' "$S2$p" | head -c 1200; echo
done
echo "--- delegation probe variants"
for body in '{}' '{"probe":true}' '{"subject":"ARWC"}' '{"case":"SUP-2841"}' '{"note":"NOTE-SUP-2841-7"}' '{"handover":"DIAG-CRR-MIXED-19"}'; do
  echo "--- body=$body"
  curl -sSk -m 8 -u "$U" -X POST -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$S2/api/archive/delegation/probe" | head -c 1500; echo
done
echo "--- archive handovers basic"
curl -sSk -m 8 -u "$U" -w '\n[%{http_code}]\n' "$S2/api/archive/handovers/support" | head -c 800; echo
echo "--- note-preview with restricted content"
curl -sSk -m 8 -u "$U" -X POST -H 'Content-Type: application/json' -d '{"consumer":"staff-note-preview","content":"RESTRICTED SUPPORT-NOTE DRAFT"}' -w '\n[%{http_code}]\n' "$S2/api/note-preview" | head -c 1500; echo
INNER
echo DONE_R29
