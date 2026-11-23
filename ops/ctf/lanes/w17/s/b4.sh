#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
for ip in 10.77.50.11 10.77.60.20; do
 for port in 443 8443 80; do
  for h in hmi.arwc.test fuxa.arwc.test arwc.test ca.keplerops.test; do
   out=$(curl -sS $P -m 8 -k -H "Host: $h" -o /tmp/v -w "%{http_code}" "https://$ip:$port/" 2>/dev/null)
   echo "$h $ip:$port -> $out $(head -c 120 /tmp/v 2>/dev/null|tr -d '\n')"
  done
 done
done
echo "== direct via socks to hostname"
for h in hmi.arwc.test fuxa.arwc.test; do
 out=$(curl -sS $P -m 8 -k -o /tmp/v -w "%{http_code}" "https://$h/" 2>/dev/null); echo "$h => $out $(head -c 200 /tmp/v|tr -d '\n')"
done
