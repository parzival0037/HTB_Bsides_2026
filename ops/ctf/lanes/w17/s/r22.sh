#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'for h in connector.arwc.test fuxa.arwc.test hmi.arwc.test plant.arwc.test scada.arwc.test opcua.arwc.test arwc.test reservoir.arwc.test crr.arwc.test cedar.arwc.test cairn.arwc.test; do
  code=$(curl -sS -m 6 -k --resolve $h:443:10.77.60.20 -o /tmp/o -w "%{http_code}" "https://$h/" 2>/dev/null)
  echo "$h -> $code $(head -c 120 /tmp/o | tr -d "\n")"
done
echo === ; for p in /api/plant /plant /v1 /v1/status /arwc /connector /api/connector /api/v1 /health/live /metrics /status/plant; do
  code=$(curl -sS -m 6 -k -o /tmp/o -w "%{http_code}" "https://connector.arwc.test$p"); echo "$p -> $code $(head -c 100 /tmp/o|tr -d "\n")"
done' 2>&1
