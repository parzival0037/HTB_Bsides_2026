#!/bin/bash
echo "== box ssh-keyscan"
timeout 20 ssh-keyscan -T 4 10.77.41.1 2>/dev/null | sed 's/^/BOX /'
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== rowan ssh-keyscan"; for ip in 10.77.50.11 10.77.50.20 10.77.53.1 10.77.54.1 10.77.55.1 10.77.55.2 10.77.56.1 10.77.51.20; do echo "-- $ip"; timeout 8 ssh-keyscan -T 4 $ip 2>/dev/null; done' 2>&1 | tail -60
