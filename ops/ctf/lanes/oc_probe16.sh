set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
O=https://objects.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== cloud-api collection route probes"
for P in "api/exports/EXP-2841/collection" "api/exports/EXP-2841/collection/PART-ARWC-01-rev10.json" "api/exports/EXP-2841/collections/PART-ARWC-01-rev10.json" "api/exports/EXP-2841/objects/PART-ARWC-01-rev10.json" "api/exports/EXP-2841/runs" "api/collections/PART-ARWC-01-rev10.json" "api/collections?export=EXP-2841"; do
 echo "--- $P"; $C -m 10 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$B/$P" | head -c 600; echo
done
echo "===== fieldlink-exports bucket probes"
for P in "fieldlink-exports?list-type=2" "fieldlink-exports/EXP-2841-rowan/PART-ARWC-01-rev10.json" "fieldlink-exports/PART-ARWC-01-rev10.json" "fieldlink-exports/EXP-2841-maya/PART-ARWC-01-rev10.json"; do
 echo "--- $P (anon)"; $C -m 10 -w ' [%{http_code}]\n' "$O/$P" | head -c 700; echo
 echo "--- $P (EJ)"; $C -m 10 -H "Authorization: Bearer $EJ" -w ' [%{http_code}]\n' "$O/$P" | head -c 700; echo
done
echo "===== rowan-dev aws s3 listing"
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev "aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 ls s3://fieldlink-exports/ 2>&1 | head -30; echo ---; aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 ls s3://fieldlink-exports/EXP-2841-rowan/ 2>&1 | head -20" 2>&1 | head -50
