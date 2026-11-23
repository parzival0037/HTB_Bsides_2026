#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
C="curl -sS $P -k --max-time 15"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "===== connector POST known routes ====="
for u in /api/fieldlink/packages/poll /api/fieldlink/packages/7.4.2/receipt /api/fieldlink/rehearsals/rollback; do
  for m in GET POST; do
    printf '%s %s -> ' "$m" "$u"
    $C -X $m -H 'Content-Type: application/json' -d '{"connector_revision":"FLK-7.4.2"}' -o /tmp/c.out -w '%{http_code} ' "https://connector.arwc.test$u"; head -c 200 /tmp/c.out; echo
  done
done
echo "===== decode connector-archive tree ====="
$C -u "rowan.ito:$TOK" "https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/git/trees/main?recursive=1" | python3 -c '
import sys,json
d=json.load(sys.stdin)
for t in d.get("tree",[]): print(t["type"],t["size"],t["path"])
'
