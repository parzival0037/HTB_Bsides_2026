#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 15"
SUP="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
probe(){ echo "### $1 | $2 | $3 | $4"; curl $P -o /tmp/o -w '[%{http_code}] ' -X "$1" ${2:+-H "Host: $2"} ${3:+-H "$3"} ${4:+-H "$4"} "https://$5$6"; head -c 400 /tmp/o; echo; }
for port in 8443; do
for H in hmi.arwc.test fuxa.arwc.test arwc.test connector.arwc.test; do
  probe GET $H "" "" 10.77.50.11:$port /
  probe GET $H "Authorization: Bearer $SUP" "" 10.77.50.11:$port /
  probe GET $H "X-Integration-Token: $SUP" "" 10.77.50.11:$port /
  probe GET $H "X-FieldKest-Integration: $SUP" "" 10.77.50.11:$port /
done; done
echo "===== 10.77.51.60:8443"
for H in hmi.arwc.test fuxa.arwc.test edge.keplerops.test; do
  probe GET $H "" "" 10.77.51.60:8443 /
  probe GET $H "Authorization: Bearer $SUP" "" 10.77.51.60:8443 /
  probe GET $H "X-Integration-Token: $SUP" "" 10.77.51.60:8443 /
done
echo "===== well-known on 51.60"
curl $P -o /tmp/o -w '[%{http_code}] ' --resolve x:8443:10.77.51.60 https://x:8443/.well-known/fieldkest-client 2>&1; head -c 300 /tmp/o; echo
