#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo == whoami; id; hostname; cat /etc/hosts
echo == tools; which nmap dig curl python3 jq psql kubectl 2>/dev/null
echo == arwc dns; getent hosts connector.arwc.test hmi.arwc.test fuxa.arwc.test 2>/dev/null
echo == portscan 10.77.60.20
for p in 22 80 443 1881 4840 5432 8080 8443 3000 5000 8000 8081 8082 9000 9090 4000 6000 7000; do
  timeout 2 bash -c "</dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "OPEN $p"
done
echo == hosts on 10.77.60.0/24?; ip route
' 2>&1
