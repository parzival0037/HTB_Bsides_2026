#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://source.keplerops.test
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
A="-u rowan.ito:$T"
for i in 1 2 3; do
  echo "### attempt $i repos"; curl -sS $P -k --max-time 20 $A "$B/api/v1/user/repos?limit=50" -o /tmp/gr.json -w '%{http_code}\n'; head -c 3000 /tmp/gr.json; echo; sleep 2
done
echo "### issue"; sleep 2; curl -sS $P -k --max-time 20 $A "$B/api/v1/repos/fieldkest/fieldlink-connector/issues?state=all&limit=50" -o /tmp/gi.json -w '%{http_code}\n'; head -c 3000 /tmp/gi.json; echo
