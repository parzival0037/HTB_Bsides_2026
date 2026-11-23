set +e
B=https://cloud-api.keplerops.test
JWT=$(python3 -c 'import json;print(json.load(open("/home/rowan/.kube/config"))["users"][0]["user"]["token"])')
echo "JWT head: ${JWT:0:24}... len ${#JWT}"
p(){ echo "=== $1"; shift; curl -sSk -m 10 -w '\n[HTTP %{http_code}]\n' "$@" 2>&1 | head -60; }
echo "===== RESOURCES with real JWT ====="
p "GET exports" -H "Authorization: Bearer $JWT" "$B/api/exports/EXP-2841"
p "GET exports definition" -H "Authorization: Bearer $JWT" "$B/api/exports/EXP-2841/definition"
p "GET schedules" -H "Authorization: Bearer $JWT" "$B/api/schedules/SCHED-2841"
p "GET trust TR-2841" -H "Authorization: Bearer $JWT" "$B/api/trust-records/TR-2841"
p "GET maintenance" -H "Authorization: Bearer $JWT" "$B/api/maintenance"
p "GET build BLD-REL-742" -H "Authorization: Bearer $JWT" "$B/api/build-records/BLD-REL-742"
echo "===== ROLE EXCHANGE real JWT ====="
for r in export exports export-reader export-writer data-export workload workloads workload-reader fieldlink report-runner reader rowan-workspace; do
  echo "--- role $r"
  curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$JWT\"}" "$B/api/token-exchange/$r" | head -20
done
echo "===== K8S RAW (non-resource URL /api/*) ====="
for u in /api/v1/namespaces/fieldlink/secrets /api/v1/namespaces/fieldlink/configmaps /api/v1/namespaces/fieldlink/pods /api/v1/namespaces/fieldlink/serviceaccounts; do
 echo "--- $u"; kubectl get --raw "$u" 2>&1 | head -c 2500; echo
done
