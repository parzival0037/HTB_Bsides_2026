set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
E=/home/rowan/work/certificates/evan.calderoux
B=https://staff.keplerops.test
echo "===== managed-identities POST session variants ====="
for sid in svc-fieldlink-staff-evan svc-fieldlink-staff StaffArchiveUser fieldlink-staff-evan evan.calderoux evan.calderoux@keplerops.test support-runner; do
 echo "--- $sid"
 curl -sSk -m 8 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/managed-identities/$sid/session" | head -c 600; echo
done
echo "===== managed-identities GET ====="
for sid in svc-fieldlink-staff-evan; do
 echo "--- GET $sid"
 curl -sSk -m 8 --cacert $CA --cert $E.crt --key $E.key -w '\n[%{http_code}]\n' "$B/api/managed-identities/$sid" | head -c 600; echo
done
echo "===== with body session request ====="
for b in '{"duration":3600}' '{"scope":"handover"}' '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}'; do
 echo "--- $b"
 curl -sSk -m 8 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d "$b" -w '\n[%{http_code}]\n' "$B/api/managed-identities/svc-fieldlink-staff-evan/session" | head -c 600; echo
done
echo "===== staff root/api list endpoints quick probe with cert ====="
for p in /api/managed-identities/svc-fieldlink-staff-evan/session/route /api/managed-identities/svc-fieldlink-staff-evan/route /api/sessions /api/session /api/managed-session; do
 echo "--- $p"
 curl -sSk -m 6 --cacert $CA --cert $E.crt --key $E.key -w '\n[%{http_code}]\n' "$B$p" | head -c 300; echo
done
INNER
echo DONE_R66
