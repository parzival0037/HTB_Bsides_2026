#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
A=https://assistant.keplerops.test
DEV="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "===== config"
curl -sS $P -k -m 15 "$A/api/config" | head -c 1500; echo
echo "===== contexts"
curl -sS $P -k -m 15 -w '\n[%{http_code}]\n' "$A/api/contexts" | head -c 3000
echo "===== contexts w/ dev"
curl -sS $P -k -m 15 $DEV -w '\n[%{http_code}]\n' "$A/api/contexts" | head -c 3000
echo "===== app.js tail (routes/ids)"
curl -sS $P -k -m 20 "$A/static/app.js" -o /tmp/app.js -w '%{http_code} %{size_download}\n'
grep -oP "api/[a-zA-Z0-9_./{}$-]+" /tmp/app.js | sort -u | head -60
echo "===== grep seed ids in app.js"
grep -oP "[A-Z]{2,6}-[0-9A-Z]{2,}(-[0-9A-Z]+)?" /tmp/app.js | sort -u | head -40
grep -oin "context\|workspace\|selection\|starter\|roster\|vale\|mira" /tmp/app.js | head -20
echo "===== index html"
curl -sS $P -k -m 15 "$A/" -o /tmp/as.html -w '%{http_code} %{size_download}\n'
grep -oP "src=\"[^\"]+\"|href=\"[^\"]+\"" /tmp/as.html | head -20
