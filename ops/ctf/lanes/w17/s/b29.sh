#!/bin/bash
for ip in 10.77.40.20 10.77.40.30 10.77.40.40 10.77.40.50; do
 for port in 8080 8081 8082 8083 8084; do
  out=$(curl -sS -m 5 -o /tmp/o -w "%{http_code}" "http://$ip:$port/" 2>/dev/null)
  [ "$out" = "000" ] && continue
  echo "===== $ip:$port [$out]"
  head -c 500 /tmp/o | tr -d '\n'; echo
 done
done
