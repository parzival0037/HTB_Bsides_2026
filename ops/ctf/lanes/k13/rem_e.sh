set +e
TOK='FLAG{6bb66074f2325405}'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
echo "########## cloud-api root / api"
curl -sSk -m 8 -i "$B/" | head -20
curl -sSk -m 8 -i "$B/api" | head -20
echo "########## data/workloads well-known"
curl -sSk -m 8 "https://data.keplerops.test/.well-known/fieldkest-client" | head -c 3000; echo
echo; curl -sSk -m 8 "https://workloads.keplerops.test/.well-known/fieldkest-client" | head -c 3000; echo
echo "########## exchange GET no auth"
curl -sSk -m 8 -i "$B/api/workspaces/current/token-exchange" | head -20
echo "########## exchange GET bearer"
curl -sSk -m 8 -i -H "Authorization: Bearer $TOK" "$B/api/workspaces/current/token-exchange" | head -20
echo "########## exchange GET x-workspace-token"
curl -sSk -m 8 -i -H "X-Workspace-Token: $TOK" "$B/api/workspaces/current/token-exchange" | head -20
echo "########## exchange GET basic oauth"
curl -sSk -m 8 -i -u "$TOK:" "$B/api/workspaces/current/token-exchange" | head -20
echo "########## exchange POST bearer empty json"
curl -sSk -m 8 -i -X POST -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | head -20
echo "########## exchange POST with token field"
curl -sSk -m 8 -i -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$TOK\"}" "$B/api/workspaces/current/token-exchange" | head -30
echo "########## exchange POST token-exchange/rowan-workspace"
curl -sSk -m 8 -i -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/rowan-workspace" | head -20
