#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k"
A=https://assistant.keplerops.test
echo "===== AI token"
TOK=$(curl -sS $P -m 10 -X POST "$A/api/request-token" -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])' 2>/dev/null)
echo "TOK=${TOK:0:30}..."
g(){ echo; echo "##### GET $1 (auth=$2)"; if [ "$2" = "tok" ]; then curl -sS $P -m 15 -i -H "Authorization: Bearer $TOK" "$A$1" 2>&1 | head -c 1200; else curl -sS $P -m 15 -i "$A$1" 2>&1 | head -c 1200; fi; echo; }
g /api/selections/SEL-SUP-2841-12
g /api/selections/SEL-SUP-2841-12 tok
g /api/conversations/CONV-SUP-2841-19 tok
g /api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442 tok
g /api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442
g /api/contexts?published=true
g /api/contexts/all
g /api/session
g /api/me
echo "===== POST answers variants"
p(){ echo; echo "##### POST /api/answers auth=$1 body=$2"; curl -sS $P -m 30 -i -X POST -H 'Content-Type: application/json' ${1:+-H "Authorization: Bearer $TOK"} -d "$2" "$A/api/answers" 2>&1 | head -c 1500; echo; }
p "" '{"query":"current district report sources","context_id":"ctx-support-private-v4"}'
p tok '{"query":"current district report sources","context_id":"ctx-support-private-v4"}'
p tok '{"message":"current district report sources","context_id":"ctx-support-private-v4","selection_id":"SEL-SUP-2841-12"}'
echo "===== OPTIONS"
curl -sS $P -m 10 -i -X OPTIONS "$A/api/answers" 2>&1 | head -30
echo "===== static"
for f in /static/app.js /static/app.css /static/ /manifest.json; do echo "--- $f"; curl -sS $P -m 10 -o /tmp/st.$$ -w '%{http_code} %{size_download}\n' "$A$f"; head -c 300 /tmp/st.$$; echo; done
rm -f /tmp/st.$$
