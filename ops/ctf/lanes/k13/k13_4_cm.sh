set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin)["access_token"])')
echo "WT len ${#WT}"
for CM in bld-1842 trust-flx-04; do
 echo "########## CONFIGMAP $CM"
 $C -m 10 -H "Authorization: Bearer $WT" -w '\n[HTTP %{http_code}]\n' "$K/api/v1/namespaces/fieldlink/configmaps/$CM"
done
echo "########## CLOUD-API build-record BLD-1842 with workload token"
for ID in BLD-1842 bld-1842 BLD-REL-742; do
 echo "--- $ID"
 $C -m 10 -H "Authorization: Bearer $WT" -w '\n[HTTP %{http_code}]\n' "$B/api/build-records/$ID"
done
