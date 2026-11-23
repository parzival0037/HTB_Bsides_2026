set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
O=https://objects.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== bucket listing fieldkest-exports (no auth)"
$C -m 12 -w '\n[%{http_code}]\n' "$O/fieldkest-exports?list-type=2" | head -c 1000; echo
echo "===== bucket listing fieldkest-exports (EJ bearer)"
$C -m 12 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$O/fieldkest-exports?list-type=2" | head -c 1000; echo
for P in "fieldkest-exports/EXP-2841-rowan/PART-ARWC-01-rev10.json" \
         "fieldkest-exports/PART-ARWC-01-rev10.json" \
         "fieldkest-exports/EXP-2841/PART-ARWC-01-rev10.json" \
         "fieldkest-exports/EXP-2841-maya/PART-ARWC-01-rev10.json" \
         "fieldkest-exports/EXP-2841-rowan/PART-ARWC-01-rev6.json" \
         "fieldkest-exports/PART-ARWC-01-rev6.json"; do
  echo "===== GET $P (no auth)"
  $C -m 12 -w '\n[%{http_code}]\n' "$O/$P" | head -c 1200; echo
  echo "===== GET $P (EJ bearer)"
  $C -m 12 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$O/$P" | head -c 1200; echo
done
