#!/bin/bash
ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
echo "=== /etc/hosts ==="; cat /etc/hosts
echo "=== ip route ==="; ip route 2>/dev/null
echo "=== arp ==="; ip neigh 2>/dev/null
echo "=== listening ==="; (ss -lntup 2>/dev/null || netstat -lntup 2>/dev/null) | head -40
echo "=== resolv ==="; cat /etc/resolv.conf
echo "=== /etc/hosts.d / nsswitch ==="; ls -la /etc/hosts* 2>/dev/null; cat /etc/nsswitch.conf 2>/dev/null | grep hosts
echo "=== all home work files list ==="; find ~ -maxdepth 3 -type f 2>/dev/null | grep -v -E '/\.(cache|mozilla|config|local/share|npm|git)/|node_modules' | head -100
echo "=== cron/systemd ==="; ls /etc/cron.d 2>/dev/null; systemctl list-units --type=service --state=running 2>/dev/null | head -20
INNER
