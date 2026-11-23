set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
E=/home/rowan/work/certificates/evan.calderoux
export KRB5CCNAME=FILE:/home/rowan/work/krb5cc_evan
B=https://staff.keplerops.test
echo "===== cert + negotiate archive ====="
curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key --negotiate -u : -w '\n[%{http_code}]\n' "$B/api/archive/handovers/evan.calderoux@keplerops.test" | head -c 900; echo
echo "===== cert + negotiate delegation probe ====="
curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key --negotiate -u : -X POST -H 'Content-Type: application/json' -d '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}' "$B/api/archive/delegation/probe" | python3 -c 'import json,sys
d=json.load(sys.stdin); d.pop("credential_cache",None); print(d)' 2>&1
echo "===== fuzz delegation routes with cert ====="
for p in /api/archive/delegation /api/archive/delegations /api/archive/delegation/route /api/archive/delegation/routes /api/archive/delegation/route-to /api/archive/delegation/send /api/archive/delegation/deliver /api/archive/delegation/copy /api/archive/delegation/complete /api/archive/delegation/confirm /api/archive/delegation/grant /api/archive/delegation/ticket /api/archive/delegation/session /api/archive/delegation/exchange /api/archive/handover /api/archive/handovers/evan.calderoux@keplerops.test/route /api/archive/handovers/evan.calderoux@keplerops.test/delegation /api/archive/handovers/evan.calderoux@keplerops.test/notes /api/archive/handovers/evan.calderoux@keplerops.test/case-note /api/archive/cases/SUP-2841 /api/archive/cases/SUP-2841/notes /api/archive/notes/NOTE-SUP-2841-7 /api/reviewers /api/reviewers/talia.mornac-review /api/cases /api/case-notes; do
 for m in GET POST; do
  code=$(curl -sSk -m 6 --cacert $CA --cert $E.crt --key $E.key -X $m -H 'Content-Type: application/json' -d '{}' -o /tmp/p.out -w '%{http_code}' "$B$p")
  if [ "$code" != "404" ] && [ "$code" != "501" ]; then echo "=== $m $p [$code]"; head -c 300 /tmp/p.out; echo; fi
 done
done
echo "===== spn variants (constrained delegation targets) ====="
for spn in "HTTP/staff.keplerops.test@KEPLEROPS.TEST" "HTTP/staff.keplerops.test" "cifs/staff.keplerops.test@KEPLEROPS.TEST" "HTTP/tickets.keplerops.test@KEPLEROPS.TEST" "HTTP/support.keplerops.test@KEPLEROPS.TEST" "HTTP/workboard.keplerops.test@KEPLEROPS.TEST" "HTTP/assistant.keplerops.test@KEPLEROPS.TEST"; do
 echo "--- $spn"
 curl -sSk -m 8 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d "{\"spn\":\"$spn\"}" "$B/api/archive/delegation/probe" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin); d.pop("credential_cache",None); print(d)
except Exception as e: print("ERR")'
done
INNER
echo DONE_R61
