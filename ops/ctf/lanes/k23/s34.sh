#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
U="$H/api/conversations/CONV-SUP-2841-19"
T(){ echo "-- $1"; shift; curl $K $P "$@" "$U" -w " [%{http_code}]\n" | head -c 600; }
T "bearer support" -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
T "bearer anythingllm" -H "Authorization: Bearer $TOK"
T "cookie support" -H "Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
T "basic rowan" -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
T "x-session" -H "X-Session-Id: CONV-SUP-2841-19"
T "x-api-key" -H "X-Api-Key: fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
T "query sid" "$U?session=SEL-SUP-2841-12"
echo "== osTicket session test"
CJ=/tmp/cj2.txt; rm -f $CJ
curl $K $P -c $CJ https://support.keplerops.test/scp/login.php -o /tmp/l.html
CT=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/l.html | sed 's/.*value="//;s/"$//')
curl $K $P -b $CJ -c $CJ -X POST https://support.keplerops.test/scp/login.php --data-urlencode "__CSRFToken__=$CT" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "do=scplogin" -o /dev/null
SID=$(grep OSTSESSID $CJ | awk '{print $7}')
echo "SID=$SID"
T "cookie osticket" -H "Cookie: OSTSESSID=$SID"
T "cookie both" -H "Cookie: OSTSESSID=$SID; fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
