set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "WT ${#WT} EJ ${#EJ}"
echo "===== well-known"
$C -m 12 "$B/.well-known/fieldkest-client" | head -c 4000; echo
echo "===== schedules list (EJ)"
$C -m 12 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$B/api/schedules" | head -c 1500; echo
echo "===== role record probes (WT then EJ) ====="
for T in "$WT" "$EJ"; do
 for P in api/roles/support-export-editor api/roles/role/support-export-editor api/role-sessions api/role-records api/trust-records/TRUST-FLX-04 api/trust-records/trust-flx-04 api/token-exchange/fieldkest-export-access; do
  echo "--- $P"
  $C -m 10 -H "Authorization: Bearer $T" -w ' [%{http_code}]\n' "$B/$P" | head -c 500; echo
 done
done
echo "===== k8s role/configmap with WT ====="
for P in /apis/rbac.authorization.k8s.io/v1/namespaces/fieldlink/roles/support-export-editor /api/v1/namespaces/fieldlink/configmaps/role-support-export-editor /api/v1/namespaces/fieldlink/configmaps/trust-flx-04; do
 echo "--- $P"; $C -m 10 -H "Authorization: Bearer $WT" -w ' [%{http_code}]\n' "https://cloud-api.keplerops.test:6443$P" | head -c 800; echo
done
echo "===== exports with WT ====="
for P in api/exports/EXP-2841 api/exports/EXP-2841/definition api/schedules/SCHED-2841; do
 echo "--- $P"; $C -m 10 -H "Authorization: Bearer $WT" -w ' [%{http_code}]\n' "$B/$P" | head -c 900; echo
done
