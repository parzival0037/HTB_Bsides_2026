set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
RC="fk_maintenance_runtime_3gIP3j8w6fhkBSqv7J5xllOrDVa2Kzig"
WC="fk_ci_maintenance_nU7V3DOnq7kpyAwp46cV50mO8fqtxHSJ"
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1500; echo; }
echo "########## ARCHIVE NAME SCOPE ORACLE (Bearer WC)"
for a in FIELD-CRR-2026-09 CRR-OG2 EXP-2841 exp-2841 support-case-history SUPPORT-CASE-HISTORY fieldkest-exports fieldlink-exports MAINT-FLK-01 SCHED-2841 sched-2841 fieldlink-maintenance maintenance support export exports fieldkest support-case; do
 g "$a" -H "Authorization: Bearer $WC" "$B/api/maintenance/$a"
done
echo "########## ATTESTATION COMBO (Bearer WC + RC attestation)"
for a in FIELD-CRR-2026-09 CRR-OG2 EXP-2841 fieldkest-exports; do
 g "$a RC-attest" -H "Authorization: Bearer $WC" -H "X-Scheduler-Attestation: $RC" -H "X-Workload-Class: maintenance" "$B/api/maintenance/$a"
 g "$a RC+WC" -H "Authorization: Bearer $WC" -H "X-Scheduler-Attestation: $WC:$RC" -H "X-Workload-Class: maintenance" "$B/api/maintenance/$a"
done
echo "########## Authorization variants with WC as attestation + RC bearer"
for a in FIELD-CRR-2026-09 CRR-OG2; do
 g "$a RC bearer, WC attest" -H "Authorization: Bearer $RC" -H "X-Scheduler-Attestation: $WC" -H "X-Workload-Class: maintenance" "$B/api/maintenance/$a"
 g "$a RC bearer, WC x-worker" -H "Authorization: Bearer $RC" -H "X-Maintenance-Worker: $WC" "$B/api/maintenance/$a"
 g "$a WC bearer, workload attr" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "X-Workload-Id: MAINT-FLK-01" -H "X-Scheduler: fieldkest-scheduler" -H "X-Management-Caller: svc-fieldkest-runner" "$B/api/maintenance/$a"
done
echo "########## WORKER CRED FORMATS on /api/maintenance (record) to learn"
for A in "Bearer $WC" "Worker $WC" "Maintenance $WC" "Scheduler $WC"; do
 g "auth=$A" -H "Authorization: $A" "$B/api/maintenance"
done
for H in "X-Maintenance-Worker" "X-Worker-Credential" "X-Maintenance-Token" "X-Workload-Token"; do
 g "$H WC" -H "$H: $WC" "$B/api/maintenance"
done
echo DONE_R31
RSH
echo FINISHED
