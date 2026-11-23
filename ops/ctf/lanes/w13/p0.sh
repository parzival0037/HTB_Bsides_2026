#!/bin/bash
echo "== identity =="; hostname; id
echo "== ip =="; ip -4 addr show 2>/dev/null | grep -E 'inet |^[0-9]'
echo "== route =="; ip route 2>/dev/null
echo "== hosts =="; cat /etc/hosts
echo "== resolv =="; cat /etc/resolv.conf
echo "== pivot =="; tmux ls 2>/dev/null
echo "== pivot http test =="
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source=%{http_code}\n' https://source.keplerops.test/ 2>&1
curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'connector=%{http_code}\n' https://connector.arwc.test/ 2>&1
echo "== direct test 10.77.40.20 =="
curl -sS -m 5 -o /dev/null -w 'wb=%{http_code}\n' http://workbench.training:8080/ 2>&1
echo "== direct test 10.77.60.20 =="
timeout 5 bash -c 'echo > /dev/tcp/10.77.60.20/443' 2>&1 && echo DIRECT-443-OK || echo DIRECT-443-FAIL
echo "== rowan reachable =="
timeout 5 bash -c 'echo > /dev/tcp/10.50.13.180/2222' 2>&1 && echo ROWAN-OK || echo ROWAN-FAIL
echo "== getent arwc =="
for h in arwc.test connector.arwc.test appointment.arwc.test gate.arwc.test checkin.arwc.test visits.arwc.test; do printf '%s ' "$h"; getent hosts $h || echo NO; done
