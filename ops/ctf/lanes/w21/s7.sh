#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'ST=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
echo == support well-known
for p in /.well-known/fieldkest-client /.well-known/support-client /.well-known/arwc-client; do echo "-- $p"; curl -sS -m 10 -k "https://support.keplerops.test:8443$p"; echo; done
echo == support root/api
for p in / /api /api/ /api/tickets /api/connectors /api/integrations /api/arwc; do printf "%s -> " $p; curl -sS -m 8 -k -o /tmp/o -w "%{http_code} " -H "Authorization: Bearer $ST" "https://support.keplerops.test:8443$p"; head -c 200 /tmp/o; echo; done
echo == connector well-known variants
for p in /.well-known/fieldkest-client /.well-known/arwc-client /.well-known/connector-client /api/connector /api/integration /api/health; do printf "%s -> " $p; curl -sS -m 8 -k -o /tmp/o -w "%{http_code} " "https://connector.arwc.test$p"; head -c 200 /tmp/o; echo; done
echo == connector with support token
for p in / /api /api/integration /api/status /api/connector; do printf "%s -> " $p; curl -sS -m 8 -k -o /tmp/o -w "%{http_code} " -H "Authorization: Bearer $ST" "https://connector.arwc.test$p"; head -c 200 /tmp/o; echo; done
' 2>&1
