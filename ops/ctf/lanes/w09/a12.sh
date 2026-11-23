#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set +e
echo "## tcp"
timeout 5 bash -c "exec 3<>/dev/tcp/10.77.60.21/8080 && echo TCP_OK" 2>&1
echo "## curl http"
curl -sS -m 8 -i http://10.77.60.21:8080/ 2>&1 | head -30
echo "## curl with Host connector"
curl -sS -m 8 -i -H "Host: connector.arwc.test" http://10.77.60.21:8080/ 2>&1 | head -30
echo "## curl https 8080"
curl -skS -m 8 -i https://10.77.60.21:8080/ 2>&1 | head -20
echo "## curl 80/443"
curl -sS -m 8 -i http://10.77.60.21/ 2>&1 | head -20
curl -skS -m 8 -i https://10.77.60.21/ 2>&1 | head -20
echo "## nmap-ish banners 10.77.60.21"
for p in 8080 80 443 8443 3000 8000 8888 5000; do echo -n "$p: "; timeout 3 bash -c "exec 3<>/dev/tcp/10.77.60.21/$p" 2>/dev/null && echo OPEN || echo closed; done
echo DONE_A12
' 2>&1
