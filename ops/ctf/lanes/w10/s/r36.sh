#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== ssh banner"
timeout 5 bash -c "exec 3<>/dev/tcp/10.77.60.20/22; head -1 <&3" 2>&1
echo "===== ssh try users"
for u in rowan arwc fieldlink connector relay; do echo "--- $u"; timeout 8 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -i ~/.ssh/keplerops-foothold $u@connector.arwc.test 'id; hostname' 2>&1 | tail -2; done
echo "===== common ports quick"
for p in 443 8443 8080 8000 3000 5000 9000; do timeout 4 bash -c "echo >/dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "open $p" || echo "closed $p"; done
INNER
