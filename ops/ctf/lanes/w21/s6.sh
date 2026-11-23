#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo == support client json; cat ~/.config/fieldlink/support-client.json
ST=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
paths="/ /api /api/ /api/health /health /status /api/status /api/v1 /api/project /api/projects /api/project/current /api/plant /api/plant/state /api/outlets /api/outlet /api/historian /api/history /api/series /api/points /api/opcua /api/runtime /api/controller /api/program /api/programs /api/devices /api/settings /api/users /api/auth/login /api/integration /api/integration/status /api/v1/status /api/state /api/observation /api/observations /api/measurements /api/tags /api/nodes /api/hmi /api/hmi/state /api/summary /api/overview /api/snapshot /i18n /api/app"
for h in hmi.arwc.test plant.arwc.test fuxa.arwc.test cairn.arwc.test historian.arwc.test scada.arwc.test opcua.arwc.test; do
 echo "########## $h"
 for p in $paths; do
  code=$(curl -sS -m 6 -k -o /tmp/o -w "%{http_code}" -H "Host: $h" -H "Authorization: Bearer $ST" "https://10.77.50.11:8443$p" 2>/dev/null)
  if [ "$code" != "404" ]; then echo "$p -> $code $(head -c 220 /tmp/o | tr -d "\n")"; fi
 done
done
' 2>&1
