#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "=== gitea user ==="
curl -sS $P -k --max-time 20 -H "Authorization: token $TOK" 'https://source.keplerops.test/api/v1/user' ; echo
echo "=== gitea user repos ==="
curl -sS $P -k --max-time 20 -H "Authorization: token $TOK" 'https://source.keplerops.test/api/v1/user/repos?limit=50' | head -c 3000; echo
echo "=== source-tools paths ==="
for p in /.well-known/fieldkest-client /.well-known/ /client /client/ /reference /sdk /docs /api /api/client /api/v1/client /download /releases /dist /fieldkest /fieldkest-client /index.json /manifest.json /package.json; do
  c=$(curl -sS $P -k --max-time 10 -o /tmp/o -w '%{http_code}' "https://source-tools.keplerops.test:8443$p")
  echo "### $p -> $c"; head -c 300 /tmp/o; echo
done
