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
M="$B/api/maintenance/MAINT-FLK-01"
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 2500; echo; }
echo "########## MAINT-FLK-01 query"
for q in "archive=FIELD-CRR-2026-09" "asset=CRR-OG2" "command=maintenance-summary" "command=maintenance-summary&archive=FIELD-CRR-2026-09" "action=maintenance-summary&archive=FIELD-CRR-2026-09" "summary=1" "run=1"; do
 g "GET ?$q" -H "Authorization: Bearer $WC" "$M?$q"
done
echo "########## MAINT-FLK-01 subpaths"
for p in "archive" "archive/FIELD-CRR-2026-09" "archives/FIELD-CRR-2026-09" "assets/CRR-OG2" "summary" "run" "runs" "maintenance-summary" "FIELD-CRR-2026-09"; do
 g "GET /$p" -H "Authorization: Bearer $WC" "$M/$p"
done
echo "########## MAINT-FLK-01 POST"
for body in '{}' '{"archive":"FIELD-CRR-2026-09"}' '{"asset":"CRR-OG2"}' '{"command":"maintenance-summary","archive":"FIELD-CRR-2026-09"}' '{"command":["maintenance-summary","--archive","FIELD-CRR-2026-09"]}' '{"action":"archive","archive":"FIELD-CRR-2026-09"}'; do
 g "POST $body" -X POST -H "Authorization: Bearer $WC" -H 'Content-Type: application/json' -d "$body" "$M"
done
echo "########## WITH scheduler attestation variants"
for A in "$WC" "$RC" "$EJ" "fieldkest-scheduler" "svc-fieldkest-runner"; do
 g "GET ?archive WL AT=${A:0:12}" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $A" "$M?archive=FIELD-CRR-2026-09"
 g "POST archive AT=${A:0:12}" -X POST -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $A" -H 'Content-Type: application/json' -d '{"archive":"FIELD-CRR-2026-09","asset":"CRR-OG2","command":"maintenance-summary"}' "$M"
done
echo "########## header name variants"
for H in "X-Scheduler-Attestation" "X-Scheduler-Attestation-Token" "X-Attestation" "X-Maintenance-Attestation" "Scheduler-Attestation"; do
 g "POST H=$H" -X POST -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "$H: $WC" -H 'Content-Type: application/json' -d '{"archive":"FIELD-CRR-2026-09"}' "$M"
done
echo DONE_R32
RSH
echo FINISHED
