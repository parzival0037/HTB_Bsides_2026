set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
G=https://source.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "===== ALL repos ====="
curl -sSk -m 10 --cacert $CA -u "$U" "$G/api/v1/repos/search?limit=100&exclusive=false" | python3 -c '
import json,sys
d=json.load(sys.stdin)
print("count",len(d.get("data",[])))
for r in d.get("data",[]): print(r["full_name"],"|",r.get("description"))
' 2>&1 | head -50
echo "===== archive query params ====="
E=/home/rowan/work/certificates/evan.calderoux
for q in "" "?note=1" "?include=note" "?include=notes" "?case=SUP-2841" "?case=CINDER" "?reviewer=talia.mornac-review" "?detail=full" "?include=case-note" "?view=notes"; do
 echo "--- GET$q"
 curl -sSk -m 8 --cacert $CA --cert $E.crt --key $E.key -w '\n[%{http_code}]\n' "https://staff.keplerops.test/api/archive/handovers/evan.calderoux@keplerops.test$q" | head -c 900; echo
done
echo "===== archive POST/DELETE ====="
for m in POST DELETE PUT; do
 echo "--- $m"
 curl -sSk -m 8 --cacert $CA --cert $E.crt --key $E.key -X $m -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "https://staff.keplerops.test/api/archive/handovers/evan.calderoux@keplerops.test" | head -c 500; echo
done
echo "===== delegation nested bodies ====="
D="https://staff.keplerops.test/api/archive/delegation/probe"
for b in \
 '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","delegation":{"reviewer":"talia.mornac-review","handover":"DIAG-CRR-MIXED-19"}}' \
 '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","route":{"to":"talia.mornac-review","copy":"DIAG-CRR-MIXED-19"}}' \
 '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","handover":"DIAG-CRR-MIXED-19","reviewer":"talia.mornac-review","action":"route","copy":true}' \
 '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","route_to":"talia.mornac-review"}' \
 '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","reviewer":"cedar-run-diagnostic-session"}' ; do
 echo "--- $b"
 curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d "$b" "$D" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin); d.pop("credential_cache",None); print(d)
except Exception as e: print("ERR",e)'
done
INNER
echo DONE_R59
