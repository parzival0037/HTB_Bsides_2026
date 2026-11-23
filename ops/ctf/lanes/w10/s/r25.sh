#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== proxy env"
env | grep -i proxy
echo "===== curlrc/wgetrc"
cat /home/rowan/.curlrc 2>&1; cat /etc/wgetrc 2>&1 | grep -i proxy
echo "===== no_proxy/proxy in profile"
grep -rniI "proxy\|arwc" /home/rowan/.bashrc /home/rowan/.profile /etc/profile /etc/environment /etc/profile.d 2>/dev/null | head -30
echo "===== resolve connector"
getent hosts connector.arwc.test
python3 -c "import socket;print(socket.getaddrinfo('connector.arwc.test',443))"
echo "===== verbose curl"
curl -sS -m 15 --cacert /home/rowan/.local/share/keplerops/ca.crt -v https://connector.arwc.test/ 2>&1 | head -40
echo "===== listening"
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null
echo "===== routes?"
ip route 2>/dev/null | head
echo "===== arwc via 10.77.60.20 ports 443/8443 quick"
for p in 80 443 8080 8443 8000 3000; do timeout 2 bash -c "echo > /dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "open $p" || echo "closed $p"; done
INNER
