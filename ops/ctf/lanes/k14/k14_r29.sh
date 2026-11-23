set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
RC="fk_maintenance_runtime_3gIP3j8w6fhkBSqv7J5xllOrDVa2Kzig"
WC="fk_ci_maintenance_nU7V3DOnq7kpyAwp46cV50mO8fqtxHSJ"
U1="$B/api/maintenance/FIELD-CRR-2026-09"
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 2500; echo; }
echo "########## HEADER COMBOS"
g "Bearer EJ + WL + AT=WC" -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" "$U1"
g "Bearer EJ + WL + AT=RC" -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $RC" "$U1"
g "Bearer WC" -H "Authorization: Bearer $WC" "$U1"
g "Bearer RC" -H "Authorization: Bearer $RC" "$U1"
g "X-Maintenance-Worker WC" -H "Authorization: Bearer $EJ" -H "X-Maintenance-Worker: $WC" "$U1"
g "X-Maintenance-Worker RC" -H "Authorization: Bearer $EJ" -H "X-Maintenance-Worker: $RC" "$U1"
g "X-Worker-Credential WC" -H "Authorization: Bearer $EJ" -H "X-Worker-Credential: $WC" "$U1"
g "X-Maintenance-Credential WC" -H "Authorization: Bearer $EJ" -H "X-Maintenance-Credential: $WC" "$U1"
g "Auth Worker WC" -H "Authorization: Worker $WC" "$U1"
g "Auth Maintenance WC" -H "Authorization: Maintenance $WC" "$U1"
g "Auth Scheduler WC" -H "Authorization: Scheduler $WC" "$U1"
g "X-Scheduler-Attestation WC only" -H "X-Scheduler-Attestation: $WC" "$U1"
g "X-Workload-Class maintenance + Auth Bearer WC" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" "$U1"
g "Basic WC user" -u "maintenance:$WC" "$U1"
g "Basic worker" -u "svc-fieldkest-runner:$WC" "$U1"
g "Basic runtime" -u "svc-fieldlink-maintenance:$RC" "$U1"
g "Basic rowan WC" -u "rowan.ito:$WC" "$U1"
echo "########## ARCHIVE VARIANTS"
for p in "api/maintenance/FIELD-CRR-2026-09/summary" "api/maintenance/FIELD-CRR-2026-09/CRR-OG2" "api/maintenance/CRR-OG2" "api/maintenance/archive/FIELD-CRR-2026-09/CRR-OG2" "api/maintenance/FIELD-CRR-2026-09?asset=CRR-OG2" "api/maintenance/summary/FIELD-CRR-2026-09"; do
 g "GET $p" -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" "$B/$p"
done
echo "########## POST with headers"
g "POST archive" -X POST -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" -H 'Content-Type: application/json' -d '{"archive":"FIELD-CRR-2026-09","command":["maintenance-summary","--archive","FIELD-CRR-2026-09"]}' "$U1"
echo DONE_R29
RSH
echo FINISHED
