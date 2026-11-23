#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 25"
for u in \
 "https://delivery.keplerops.test:8443/.well-known/fieldkest-client" \
 "https://support.keplerops.test/.well-known/fieldkest-client" \
 "https://delivery.keplerops.test:8443/" \
 "https://delivery.keplerops.test/" ; do
 echo "===== $u"; curl $P "$u" -w '\n[%{http_code}]\n' | head -c 3000; echo
done
echo "== DNS for delivery"
getent hosts delivery.keplerops.test
echo "== try port 8443 on candidates"
for h in delivery.keplerops.test connector.arwc.test 10.77.60.20; do
 for p in 8443 443 80 8080 8090; do
  timeout 4 bash -c "echo > /dev/tcp/$h/$p" 2>/dev/null && echo "open $h:$p"
 done
done
