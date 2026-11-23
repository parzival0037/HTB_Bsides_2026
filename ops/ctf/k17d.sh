set +e
R=/home/rowan/.local/share/keplerops/ca.crt
C="/tmp/evan.calderoux.crt"
K="/tmp/evan.calderoux.key"
U=https://staff.keplerops.test/api/archive/delegation/probe
echo "--- empty body"
ssh -o BatchMode=yes rowan-dev "curl -sS -m 12 --cacert $R --cert $C --key $K -X POST -H 'Content-Type: application/json' -d '{}' -w ' [%{http_code}] ' $U" | head -c 300; echo
for body in '{"subject":"DIAG-CRR-MIXED-19","reviewer":"talia.mornac-review"}' '{"handover":"DIAG-CRR-MIXED-19","reviewer":"cedar-run-diagnostic-session"}' '{"diagnostic":"DIAG-CRR-MIXED-19","delegate":"talia.mornac-review"}' '{"case":"SUP-2841","reviewer":"talia.mornac-review"}'; do
  echo "--- $body"
  ssh -o BatchMode=yes rowan-dev "curl -sS -m 12 --cacert $R --cert $C --key $K -X POST -H 'Content-Type: application/json' -d '$body' -w ' [%{http_code}] ' $U" | head -c 400; echo
done
