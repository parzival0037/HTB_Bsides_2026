#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'which python3 nc socat; echo ===
for n in fuxa hmi scada opcua opc ua plc historian history db postgres postgresql grafana api web portal gateway edge controller rtudb plant reservoir outlet pump station arwc connector source; do
  for d in arwc.test keplerops.test; do
    r=$(getent hosts $n.$d 2>/dev/null | head -1); [ -n "$r" ] && echo "$n.$d -> $r"
  done
done
echo ===
for ip in 10.77.60.1 10.77.60.10 10.77.60.11 10.77.60.20 10.77.60.21 10.77.60.22 10.77.60.30 10.77.60.40 10.77.60.50; do
  for p in 22 80 443 3000 4840 1881 5432 8080 8443; do
    (exec 3<>/dev/tcp/$ip/$p) 2>/dev/null && echo "OPEN $ip:$p" && exec 3<&- 
  done
done' 2>&1
