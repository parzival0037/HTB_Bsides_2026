#!/bin/bash
echo "== pivot check =="
tmux ls 2>/dev/null
curl -sS -m 20 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'connector.arwc.test -> %{http_code}\n' https://connector.arwc.test/ 2>&1
echo "== rowan-dev hosts =="
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat /etc/hosts; echo ---; cat /etc/resolv.conf' 2>&1 | head -60
echo "== connector root =="
curl -sS -m 20 --socks5-hostname 127.0.0.1:1080 -k -D- https://connector.arwc.test/ 2>&1 | head -40
echo "== dns =="
for h in arwc.test connector.arwc.test outlet.arwc.test gate.arwc.test checkin.arwc.test access.arwc.test inspection.arwc.test; do
  getent hosts $h || echo "no $h"
done
