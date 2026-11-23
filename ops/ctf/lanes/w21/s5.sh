#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo == grep arwc in home
timeout 60 grep -ril "arwc" ~ --include="*.json" --include="*.conf" --include="*.md" --include="*.txt" --include="*.env" 2>/dev/null | head -20
echo == support client cfg; cat ~/.config/fieldlink/support-client.json 2>/dev/null
echo == files listing; ls -la ~/.config/fieldlink/ 2>/dev/null
echo == test integration gateway
ST=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
DT=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for h in hmi.arwc.test fuxa.arwc.test plant.arwc.test historian.arwc.test scada.arwc.test opcua.arwc.test cairn.arwc.test; do
 for hdr in "" "Authorization: Bearer $ST" "Authorization: Bearer $DT" "X-Integration-Token: $ST"; do
  if [ -z "$hdr" ]; then a=(); else a=(-H "$hdr"); fi
  printf "%s [%s] -> " "$h" "${hdr:0:25}"
  curl -sS -m 8 -k -o /tmp/o -w "%{http_code} " -H "Host: $h" "${a[@]}" https://10.77.50.11:8443/
  head -c 120 /tmp/o; echo
 done
done
' 2>&1
