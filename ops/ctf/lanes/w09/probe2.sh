#!/bin/bash
echo "=== other /tmp scripts ==="
for f in /tmp/w09a.sh /tmp/w01_scan.sh /tmp/w01_scan2.sh /tmp/w02a.sh /tmp/w14r5.sh /tmp/w14r7.sh; do echo "--- $f"; cat "$f" 2>/dev/null; done
echo "=== connector well-known / openapi ==="
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 15"
B="https://connector.arwc.test"
for p in /.well-known/fieldkest-client /openapi.json /api /api/ /health /healthz /api/health /v1 /api/v1 /.well-known/fieldkest-connector; do
  echo "--- $p"
  curl $P "$B$p" -w '\n[HTTP %{http_code}]\n' | head -c 1200
done
echo "=== Gitea repos ==="
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
curl $P -H "Authorization: token $TOK" "https://source.keplerops.test/api/v1/user/repos?limit=50" | python3 -c 'import sys,json;d=json.load(sys.stdin);print("\n".join(f"{r[\"full_name\"]}" for r in d))' 2>/dev/null || echo gitea-fail
