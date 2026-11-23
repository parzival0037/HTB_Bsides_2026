set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
for CM in role-export-access exp-2841-definition; do
  echo "===== $CM data"
  $C -m 12 -H "Authorization: Bearer $EJ" "$K/api/v1/namespaces/fieldlink/configmaps/$CM" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(json.dumps(d.get("data"),indent=1)); print("LABELS",json.dumps(d.get("metadata",{}).get("labels")))'
done
