set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== PATCH schedule assignment -> field-operator-b"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{"assignment":"field-operator-b"}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841" | head -c 1200; echo
echo "===== GET schedule after"
$C -m 12 -H "Authorization: Bearer $EJ" "$B/api/schedules/SCHED-2841" | head -c 900; echo
echo "===== run after schedule assignment patch"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841/runs" | head -c 1500; echo
echo "===== run with explicit assignment body"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{"assignment":"field-operator-b"}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841/runs" | head -c 1500; echo
