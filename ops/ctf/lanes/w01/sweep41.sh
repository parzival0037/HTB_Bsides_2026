#!/bin/bash
for i in $(seq 1 254); do
 ip=10.77.41.$i
 for p in 22 80 443 8080 8081 8082 8083 8084 8085 8443 3000 5000 8000 9000 9200; do
  ( timeout 1 bash -c "echo >/dev/tcp/$ip/$p" 2>/dev/null && echo "$ip:$p" ) &
  while [ $(jobs -r|wc -l) -ge 200 ]; do wait -n; done
 done
done
wait
