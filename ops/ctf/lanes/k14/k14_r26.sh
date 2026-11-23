set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_PAGER=""
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
RC="fk_maintenance_runtime_3gIP3j8w6fhkBSqv7J5xllOrDVa2Kzig"
WC="fk_ci_maintenance_nU7V3DOnq7kpyAwp46cV50mO8fqtxHSJ"
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1800; echo; }
echo "########## EXPORT JWT policy probes"
for p in fieldlink-maintenance maintenance policy-fieldlink-maintenance support-export support fieldkest-support support-export-reader export-access role-export-access; do
 g "EJ /api/policies/$p" -H "Authorization: Bearer $EJ" "$B/api/policies/$p"
done
echo "########## EXPORT JWT chained exchange"
for r in fieldkest-support-export support-export fieldkest-support support-reader fieldkest-support-reader fieldkest-archive archive-editor fieldkest-maintenance maintenance fieldkest-export-access fieldkest-export-reader; do
 g "EJ->$r" -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/$r"
done
echo "########## MAINTENANCE CREDS on cloud-api"
for T in "$RC" "$WC"; do
 echo "===== token ${T:0:24}"
 for p in api/maintenance api/policies/fieldlink-maintenance api/policies/default api/exports/EXP-2841 api/exports/EXP-2841/definition api/exports/EXP-2841/runs api/trust-records/TRUST-FLX-04 api/build-records/BLD-1842; do
  g "$p" -H "Authorization: Bearer $T" "$B/$p"
 done
done
echo "########## MAINTENANCE CREDS on support :8443"
for T in "$RC" "$WC"; do
 echo "===== token ${T:0:24}"
 for p in api/handovers/current api/maintenance api/exports/EXP-2841 api/archive/handovers/CRR-OG2 api/archive/handovers/rowan.ito api/customers/TEN-ARWC-047/diagnostics api/diagnostics/DIAG-CRR-MIXED-19; do
  g "$p" -H "Authorization: Bearer $T" "https://support.keplerops.test:8443/$p"
 done
done
echo "########## MAINTENANCE CREDS on staff"
for T in "$RC" "$WC"; do
 echo "===== token ${T:0:24}"
 for p in api/service-directory api/archive/handovers/CRR-OG2 api/archive/handovers/rowan.ito api/notes/NOTE-SUP-2841-7; do
  g "$p" -H "Authorization: Bearer $T" "https://staff.keplerops.test/$p"
 done
done
echo DONE_R26
RSH
echo FINISHED
