#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo ==resolv; cat /etc/resolv.conf; echo ==routes; ip route; echo ==dig
for h in fuxa.arwc.test plant.arwc.test hmi.arwc.test opcua.arwc.test historian.arwc.test arwc.test reservoir.arwc.test crr.arwc.test cairn.arwc.test cedar.arwc.test connector.arwc.test; do
 r=$(getent hosts $h | head -1); echo "$h => ${r:-NODNS}"
done
echo ==relay probes
H=connector.arwc.test
for p in /api/exercises /api/exercises/ /api/exercises/connector-archive /api/exercises/connector-archive/run /api/connector /api/connector/run /api/run /api/v1/exercises /api/catalog /api/clients /api/arwc /api/arwc/plant /api/process /api/history /api/tags /api/points /api/observations /api/status /api/health; do
  out=$(curl -sS -m 8 -k --resolve $H:443:10.77.60.20 -o /tmp/o -w "%{http_code}" "https://$H$p" 2>/dev/null)
  echo "== GET $p -> $out $(head -c 180 /tmp/o|tr -d "\n")"
done' 2>&1
