set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
W=https://workloads.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
RC="fk_maintenance_runtime_3gIP3j8w6fhkBSqv7J5xllOrDVa2Kzig"
WC="fk_ci_maintenance_nU7V3DOnq7kpyAwp46cV50mO8fqtxHSJ"
U1="$B/api/maintenance/FIELD-CRR-2026-09"
g(){ n="$1"; shift; echo "##### $n"; curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1600; echo; }
echo "########## WC + workload headers"
g "WC + WLId" -H "Authorization: Bearer $WC" -H "X-Workload-Id: MAINT-FLK-01" "$U1"
g "WC + WLClass" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" "$U1"
g "WC + WLClass+WLId" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "X-Workload-Id: MAINT-FLK-01" "$U1"
g "WC + X-Workload MAINT-FLK-01" -H "Authorization: Bearer $WC" -H "X-Workload: MAINT-FLK-01" "$U1"
g "WC + WLClass+WLId+Sched" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "X-Workload-Id: MAINT-FLK-01" -H "X-Scheduler: fieldkest-scheduler" "$U1"
g "WC + SchedAttestation WC" -H "Authorization: Bearer $WC" -H "X-Scheduler-Attestation: $WC" "$U1"
g "WC + WLClass + SchedAttestation WC" -H "Authorization: Bearer $WC" -H "X-Workload-Class: maintenance" -H "X-Scheduler-Attestation: $WC" "$U1"
g "WC + query workload_id" -H "Authorization: Bearer $WC" "$U1?workload_id=MAINT-FLK-01"
g "WC + query workload_class" -H "Authorization: Bearer $WC" "$U1?workload_class=maintenance"
g "WC + query scope=maintenance" -H "Authorization: Bearer $WC" "$U1?scope=maintenance"
g "WC archive path MAINT-FLK-01/FIELD" -H "Authorization: Bearer $WC" "$B/api/maintenance/MAINT-FLK-01/FIELD-CRR-2026-09"
g "WC workload archive path" -H "Authorization: Bearer $WC" "$B/api/workloads/MAINT-FLK-01/maintenance/FIELD-CRR-2026-09"
g "WC /api/workloads/MAINT-FLK-01" -H "Authorization: Bearer $WC" "$B/api/workloads/MAINT-FLK-01"
echo "########## workloads host"
for p in "" "api/maintenance/FIELD-CRR-2026-09" "api/workloads/MAINT-FLK-01" "api/attestations" "api/scheduler/attest" "api/scheduler/attestation" "api/maintenance/attest"; do
 g "WLHOST /$p WC" -H "Authorization: Bearer $WC" "$W/$p"
 g "WLHOST /$p EJ" -H "Authorization: Bearer $WT" "$W/$p"
done
echo "########## identity / attest endpoints on cloud-api"
for p in "api/attestations" "api/attest" "api/scheduler/attest" "api/scheduler/attestation" "api/workloads" "api/workloads/MAINT-FLK-01" "api/maintenance/attest" "api/earned-identities" "api/identities/earned"; do
 g "GET $p WC" -H "Authorization: Bearer $WC" "$B/$p"
done
echo "########## k8s SSAR export: serviceaccounts/token, pods, jobs/logs"
K=https://cloud-api.keplerops.test:6443
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
for R in "create|serviceaccounts/token|" "get|pods|" "list|pods|" "get|pods/log|" "get|serviceaccounts|" "get|configmaps|"; do
 IFS='|' read -r V R G <<EOF
$R
EOF
 if [ -z "$G" ]; then GA='"group":""'; else GA="\"group\":\"$G\""; fi
 echo "-- $V $R"
 curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -X POST \
  -d "{\"apiVersion\":\"authorization.k8s.io/v1\",\"kind\":\"SelfSubjectAccessReview\",\"spec\":{\"resourceAttributes\":{\"namespace\":\"fieldlink\",\"verb\":\"$V\",\"resource\":\"$R\",$GA}}}" \
  "$K/apis/authorization.k8s.io/v1/selfsubjectaccessreviews" | python3 -c 'import sys,json
try: print(json.load(sys.stdin)["status"].get("allowed"))
except Exception: print("ERR")'
done
echo DONE_R30
RSH
echo FINISHED
