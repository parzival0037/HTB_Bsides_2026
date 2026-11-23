#!/bin/bash
echo "===== id"
id
echo "===== tmux"
tmux ls 2>&1
echo "===== pivot test"
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source %{http_code}\n' https://source.keplerops.test/ 2>&1
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'connector %{http_code}\n' https://connector.arwc.test/ 2>&1
echo "===== CA on box?"
ls -la /tmp/ca.crt /home/kali/ca.crt 2>&1
echo "===== rowan-dev hosts"
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat /etc/hosts; echo ---RESOLV---; cat /etc/resolv.conf' 2>&1 | head -80
echo "===== connector root"
curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -i https://connector.arwc.test/ 2>&1 | head -60
echo "===== connector well-known"
for p in /.well-known/fieldkest-client /api /health /api/health /robots.txt /openapi.json /docs; do
  echo "== $p"
  curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -i "https://connector.arwc.test$p" 2>&1 | head -20
done
