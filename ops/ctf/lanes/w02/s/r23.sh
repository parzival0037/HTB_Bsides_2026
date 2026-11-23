P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
B=https://cloud-api.keplerops.test
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "### exchange GET"; curl $P $A "$B/api/workspaces/current/token-exchange"; echo
echo "### exchange POST"; RESP=$(curl $P $A -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange"); echo "$RESP"
TOK=$(echo "$RESP" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))' 2>/dev/null)
echo "TOKLEN=${#TOK}"
H="Authorization: Bearer $TOK"
for p in /api/maintenance /api/trust-records/TRUST-FLX-04 /api/build-records/BLD-1842 /api/exports/EXP-2841 /api/schedules/SCHED-2841 /api/policies/MAINT-1 /api/workspaces/current; do
 echo "##### $p"; curl $P -H "$H" -i "$B$p" | head -c 1600; echo; done
echo "### role exchange export"
RESP2=$(curl $P -H "$H" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access"); echo "$RESP2"
TOK2=$(echo "$RESP2" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))' 2>/dev/null)
echo "TOK2LEN=${#TOK2}"
echo "### maintenance with export token"; curl $P -H "Authorization: Bearer $TOK2" -i "$B/api/maintenance" | head -c 3000; echo
