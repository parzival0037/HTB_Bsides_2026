set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== workloads well-known"
$C -m 12 "https://workloads.keplerops.test/.well-known/fieldkest-client" | head -c 4000; echo
echo "===== data well-known"
$C -m 12 "https://data.keplerops.test/.well-known/fieldkest-client" | head -c 4000; echo
echo "===== SSRR export identity"
$C -m 12 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"apiVersion":"authorization.k8s.io/v1","kind":"SelfSubjectRulesReview","spec":{"namespace":"fieldlink"}}' \
 "https://cloud-api.keplerops.test:6443/apis/authorization.k8s.io/v1/selfsubjectrulesreviews" | head -c 3000; echo
echo "===== PATCH schedule empty (validation probe)"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841" | head -c 1200; echo
echo "===== PATCH schedule marker candidate"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"startup_hook":{"argv":["fk-support-export","--export","EXP-2841","--marker","cinder"]}}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841" | head -c 1500; echo
echo "===== OPTIONS schedule"
$C -m 12 -X OPTIONS -i -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841" | head -20
