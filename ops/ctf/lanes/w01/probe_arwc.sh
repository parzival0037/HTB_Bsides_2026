#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "### pivot check"
curl -sS $P -k --max-time 10 -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/ 2>&1
echo "### connector.arwc.test:80 root"
curl -sS $P -k --max-time 15 -i http://connector.arwc.test/ 2>&1 | head -c 1200; echo
echo "### connector.arwc.test:443 root"
curl -sS $P -k --max-time 15 -i https://connector.arwc.test/ 2>&1 | head -c 1200; echo
echo "### .well-known"
for p in .well-known/fieldkest-client api/ health version status; do
  echo "--- /$p"
  curl -sS $P -k --max-time 10 -i "https://connector.arwc.test/$p" 2>&1 | head -c 600; echo
done
echo "### nmap-ish ports"
for port in 80 443 8080 8443 3000 8000 5000 9200; do
  timeout 3 bash -c "</dev/tcp/10.77.60.20/$port" 2>/dev/null && echo "open $port"
done
