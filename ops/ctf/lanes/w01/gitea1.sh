#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://source.keplerops.test
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "### version"; curl -sS $P -k --max-time 15 $B/api/v1/version; echo
echo "### search anon"; curl -sS $P -k --max-time 15 "$B/api/v1/repos/search?limit=50" | head -c 2000; echo
echo "### basic auth user"; curl -sS $P -k --max-time 15 -u "rowan.ito:$T" $B/api/v1/user; echo
echo "### issue list anon"; curl -sS $P -k --max-time 15 "$B/api/v1/repos/fieldkest/fieldlink-connector/issues?state=all&limit=50" | head -c 4000; echo
