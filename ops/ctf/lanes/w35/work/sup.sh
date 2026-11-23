#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== support-client.json ==="; R 'cat ~/.config/fieldlink/support-client.json'
echo "=== support well-known ==="; curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 15 'https://support.keplerops.test/.well-known/fieldkest-client'
echo
echo "=== support root ==="; curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 15 -D- 'https://support.keplerops.test/scp/' -o /tmp/scp.html; head -c 300 /tmp/scp.html
echo "=== osTicket api? ==="; curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 15 -o /dev/null -w '%{http_code}\n' 'https://support.keplerops.test/api/tickets.json'
