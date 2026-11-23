#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== rowan ssh config/known_hosts ==="
R 'ls -la ~/.ssh; cat ~/.ssh/config 2>/dev/null; cat ~/.ssh/known_hosts 2>/dev/null | cut -c1-120'
echo "=== banners ==="
for ip in 10.77.53.1 10.77.54.1 10.77.56.1 10.77.55.2; do
R "timeout 5 bash -c 'exec 3<>/dev/tcp/$ip/22; head -1 <&3' 2>/dev/null | sed 's/^/$ip /'"
done
echo "=== try rowan key auth on candidates ==="
for ip in 10.77.60.20 10.77.53.1 10.77.54.1 10.77.56.1; do
  for u in rowan rowan.ito arwc fieldlink; do
    echo "-- $u@$ip"
    timeout 8 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -i ~/.ssh/keplerops-foothold "$u@$ip" 'id; hostname' 2>&1 | tail -2
  done
done
