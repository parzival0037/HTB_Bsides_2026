#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== tools/resolv/route ==="
R 'which nmap nc dig host curl python3; cat /etc/resolv.conf; ip route'
echo "=== dns tests ==="
R 'for h in supply.arwc.test portal.arwc.test arwc.test hmi.arwc.test plc.arwc.test data.arwc.test; do echo -n "$h "; getent hosts $h || echo NO; done; dig +short supply.arwc.test 2>/dev/null'
echo "=== scan 10.77.60.0/24 top ports ==="
R 'sudo -n nmap -sT -Pn -n --open -p 22,80,443,3000,4000,4840,502,5432,8000,8001,8080,8081,8082,8083,8088,8443,8888,9000,9090,1880,102,20000 10.77.60.0/24 2>/dev/null || echo NMAP_FAIL'
