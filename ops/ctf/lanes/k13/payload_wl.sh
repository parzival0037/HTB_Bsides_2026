set +e
B=https://cloud-api.keplerops.test
echo "===== KUBECONFIG ====="
kubectl config current-context 2>&1; kubectl config view --minify 2>&1 | head -40
JWT=$(kubectl config view -o jsonpath='{.users[0].user.token}' 2>/dev/null)
echo "JWT len ${#JWT}"
echo "===== SA PERMS ====="
kubectl auth can-i --list 2>&1 | head -30
echo "===== GET exports with JWT ====="
p(){ echo "=== $1"; shift; curl -sSk -m 10 -w '\n[HTTP %{http_code}]\n' "$@" 2>&1 | head -40; }
p "GET /api/exports/EXP-2841 bearer JWT" -H "Authorization: Bearer $JWT" "$B/api/exports/EXP-2841"
p "GET /api/schedules/SCHED-2841 bearer JWT" -H "Authorization: Bearer $JWT" "$B/api/schedules/SCHED-2841"
p "GET /api/trust-records/TR-2841 bearer JWT" -H "Authorization: Bearer $JWT" "$B/api/trust-records/TR-2841"
p "GET /api/build-records/BLD-REL-742 bearer JWT" -H "Authorization: Bearer $JWT" "$B/api/build-records/BLD-REL-742"
p "GET /api/maintenance bearer JWT" -H "Authorization: Bearer $JWT" "$B/api/maintenance"
echo "===== ROLE EXCHANGE ====="
for r in export exports export-reader export-writer data-export workload workloads workload-reader fieldlink report-runner reader; do
  echo "--- role $r"
  curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$JWT\"}" "$B/api/token-exchange/$r" | head -20
done
echo "===== K8S OBJECTS ====="
kubectl get ns 2>&1 | head
kubectl get sa,secrets,cm,deploy,pods 2>&1 | head -60
kubectl get sa -o yaml 2>&1 | head -60
