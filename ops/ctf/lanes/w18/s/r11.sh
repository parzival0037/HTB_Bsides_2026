#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "=== /api/v1/user"
curl $P -w '\n[%{http_code}]\n' -H "Authorization: token $TOK" https://source.keplerops.test/api/v1/user
echo "=== repo search raw"
curl $P -w '\n[%{http_code}]\n' -H "Authorization: token $TOK" 'https://source.keplerops.test/api/v1/repos/search?limit=50' | head -c 1500
echo
echo "=== orgs"
curl $P -w '\n[%{http_code}]\n' -H "Authorization: token $TOK" 'https://source.keplerops.test/api/v1/orgs?limit=50' | head -c 1000
echo
