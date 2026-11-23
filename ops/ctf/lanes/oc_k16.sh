set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "WT_LEN ${#WT}"
echo "===== role exchange fieldkest-export-access (bearer workload JWT, {}) ====="
R=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access")
echo "$R" | head -c 2500; echo
EJ=$(echo "$R" | python3 -c 'import sys,json
try: print(json.load(sys.stdin).get("access_token",""))
except Exception: print("")' 2>/dev/null)
if [ -z "$EJ" ]; then
  echo "===== retry with workload_token body ====="
  R=$($C -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$WT\"}" "$B/api/token-exchange/fieldkest-export-access")
  echo "$R" | head -c 1500; echo
  EJ=$(echo "$R" | python3 -c 'import sys,json
try: print(json.load(sys.stdin).get("access_token",""))
except Exception: print("")' 2>/dev/null)
fi
echo "EJ_LEN ${#EJ}"
for P in api/exports/EXP-2841 api/exports/EXP-2841/definition api/schedules/SCHED-2841 api/trust-records/TRUST-FLX-04 api/roles/fieldkest-export-access api/role-records/fieldkest-export-access; do
  echo "===== $P"
  $C -m 12 -H "Authorization: Bearer $EJ" -w '\n[HTTP %{http_code}]\n' "$B/$P" | head -c 1200; echo
done
