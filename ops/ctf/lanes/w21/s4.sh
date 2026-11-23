#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'B=https://source-tools.keplerops.test:8443
echo == root; curl -sS -m 15 -k -i "$B/" | head -60
echo == well-known; curl -sS -m 15 -k -i "$B/.well-known/fieldkest-client" | head -80
echo == api; for p in /api /api/ /api/packages /api/v1 /api/v1/packages /api/exercises /health; do printf "%s -> " $p; curl -sS -m 10 -k -o /tmp/o -w "%{http_code} " "$B$p"; head -c 300 /tmp/o; echo; done
' 2>&1
