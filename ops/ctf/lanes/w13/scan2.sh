#!/bin/bash
# port scan via socks using curl
gen(){ for net in 10.77.60. 10.77.61.; do for i in $(seq 1 254); do for p in 22 80 443 3000 8000 8080 8081 8082 8083 8443 9090 5000; do echo "$net$i $p"; done; done; done; }
gen | xargs -P 80 -n 2 bash -c '
  ip=$0; p=$1
  out=$(curl -sS -m 3 --socks5-hostname 127.0.0.1:1080 -o /dev/null -w "%{http_code}" "http://$ip:$p/" 2>/dev/null)
  if [ -n "$out" ] && [ "$out" != "000" ]; then echo "OPEN $ip:$p http=$out"; fi
'
echo scan-http-done
