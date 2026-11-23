set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
echo "=== resolve arwc hosts from rowan-dev ==="
$S 'for h in hmi.arwc.test ot.arwc.test plc arwc.test connector.arwc.test historian.arwc.test db.arwc.test; do printf "%-26s " $h; getent hosts $h || echo NO; done'
echo "=== ping sweep 10.77.60.0/24 ==="
$S 'for i in $(seq 1 30); do (ping -c1 -W1 10.77.60.$i >/dev/null 2>&1 && echo "10.77.60.$i up") & done; wait' 
echo "=== connector routes ==="
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k https://connector.arwc.test/ 2>&1 | head -3
$S 'curl -sS -m 8 -k https://connector.arwc.test/ | head -20'
