#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== cert ==="
R 'echo | timeout 8 openssl s_client -connect 10.77.60.20:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -dates -ext subjectAltName'
echo "=== grep arwc in /etc /home/rowan ==="
R 'grep -ril "arwc" /etc /home/rowan /opt /usr/local 2>/dev/null | grep -v "\.cache\|node_modules" | head -40'
echo "=== rowan git repos / docs listing ==="
R 'ls -la ~/repos; find ~/repos -maxdepth 2 -type f | head -40; cat ~/work/registry/README.md 2>/dev/null'
