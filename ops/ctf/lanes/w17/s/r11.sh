#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'for p in / /health /healthz /api /api/ /status /version /docs /openapi.json /.well-known/fieldkest-client /.well-known/arwc-client /robots.txt; do
code=$(curl -sS -m 6 -k -o /tmp/o -w "%{http_code}" "https://connector.arwc.test$p"); echo "$p -> $code $(head -c 200 /tmp/o | tr -d "\n")"; done
echo ===
ssh -i ~/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 rowan@10.77.60.20 "hostname; id" 2>&1 | tail -3
echo ===
ls ~/.config/chromium/Default 2>/dev/null | head; echo ---
grep -a -io "arwc[^\"]\{0,60\}" ~/.config/chromium/Default/History 2>/dev/null | head -20
echo ---
sqlite3 ~/.config/chromium/Default/History "select url,title from urls" 2>/dev/null | head -20' 2>&1
