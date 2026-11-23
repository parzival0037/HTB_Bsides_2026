#!/bin/bash
set -x
cp /dev/null /tmp/w35.log
# pivot check
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k https://connector.arwc.test/ -o /tmp/con.html -w '%{http_code}\n'
head -c 2000 /tmp/con.html
echo "=== hosts from rowan-dev /etc/hosts ==="
ssh -o StrictHostKeyChecking=no -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat /etc/hosts'
