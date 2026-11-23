set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "=== WELLKNOWN ALL ==="
for h in cloud-api workloads data identity ca cert tickets support workboard staff assistant; do
 echo "##### $h"
 curl -sSk -m 8 "https://$h.keplerops.test/.well-known/fieldkest-client"; echo
done
echo "=== ROOTS ==="
for h in workloads workload; do echo "--- $h"; curl -sSk -m 8 -i "https://$h.keplerops.test/" | head -c 800; echo; done
echo "=== README / helper ==="
cat ~/README.md; echo; cat ~/work/local-helper.md
echo "=== CLUSTERTRUSTBUNDLES ==="
kubectl get clustertrustbundles -o yaml 2>&1 | head -80
echo "=== OIDC DISCOVERY RAW ==="
kubectl get --raw /.well-known/openid-configuration 2>&1 | head -c 3000; echo
echo "=== JWKS ==="
kubectl get --raw /openid/v1/jwks 2>&1 | head -c 1500; echo
echo "=== EXCHANGE VARIANTS ==="
C=https://cloud-api.keplerops.test
p(){ echo "--- $1"; shift; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -c 600; echo; }
p "GET bearer exchange" -H "Authorization: Bearer $JWT" "$C/api/workspaces/current/token-exchange"
p "POST bearer exchange" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
p "POST bearer exchange audience" -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{"audience":"workloads"}' "$C/api/workspaces/current/token-exchange"
p "X-Workload-Token exchange" -H "X-Workload-Token: $JWT" "$C/api/workspaces/current/token-exchange"
p "X-Workspace-Token exchange" -H "X-Workspace-Token: $JWT" "$C/api/workspaces/current/token-exchange"
p "X-Kubernetes-Token exchange" -H "X-Kubernetes-Token: $JWT" "$C/api/workspaces/current/token-exchange"
p "workload_token body" -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$JWT\",\"audience\":\"workloads\"}" "$C/api/workspaces/current/token-exchange"
p "token body" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$JWT\",\"audience\":\"workloads\"}" "$C/api/workspaces/current/token-exchange"
p "GET bearer trust TR-1" -H "Authorization: Bearer $JWT" "$C/api/trust-records/TR-1"
p "X-Workload-Token trust TR-1" -H "X-Workload-Token: $JWT" "$C/api/trust-records/TR-1"
p "Bearer empty trust TR-1" -H "Authorization: Bearer " "$C/api/trust-records/TR-1"
RSH
echo DONE_K14_R2
