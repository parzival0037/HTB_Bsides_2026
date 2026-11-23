#!/bin/bash
echo "=== ports ==="
for p in 22 80 443 8080 8081 8082 8083 8084 8085 9090 502 102 4840 47808 44818 20000; do
  timeout 2 bash -c "echo > /dev/tcp/10.77.40.50/$p" 2>/dev/null && echo "open $p"
done
echo "=== root ==="
curl -sS -i --max-time 10 http://10.77.40.50:8080/ | head -60
echo
echo "=== headers on / ==="
curl -sS -D - -o /dev/null --max-time 10 http://10.77.40.50:8080/
echo "=== robots ==="
curl -sS --max-time 5 http://10.77.40.50:8080/robots.txt
echo "=== sitemap ==="
curl -sS --max-time 5 http://10.77.40.50:8080/sitemap.xml
