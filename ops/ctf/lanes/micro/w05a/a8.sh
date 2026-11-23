#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 15"
DEV="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "== full package-meta"
curl -sS $P $DEV https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector | python3 -c "import sys,json;d=json.load(sys.stdin);print(json.dumps({k:v for k,v in d.items() if k in ('readme','description','versions','dist-tags')},indent=1)[:4000])"
echo "== delivery GETs"
for p in /api/inspections /api/releases /api/consumer-checks /api/reconcile/tenant-package; do
 printf "%-36s " "$p"; curl -sS $P $DEV -o /tmp/dg -w '%{http_code} ' "https://delivery.keplerops.test:8443$p"; head -c 400 /tmp/dg|tr -d '\n'; echo
done
echo "== inspections POST empty"
curl -sS $P $DEV -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' https://delivery.keplerops.test:8443/api/inspections | head -c 800; echo
