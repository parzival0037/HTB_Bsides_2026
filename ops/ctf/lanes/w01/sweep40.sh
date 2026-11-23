#!/bin/bash
echo "### box routes"; ip route 2>/dev/null; ip -4 a 2>/dev/null | head -20
for net in 40; do
 for i in $(seq 1 254); do
  ip=10.77.$net.$i
  for p in 22 80 443 8080 8081 8082 8083 8443; do
   ( timeout 1 bash -c "echo >/dev/tcp/$ip/$p" 2>/dev/null && echo "$ip:$p" ) &
   while [ $(jobs -r | wc -l) -ge 128 ]; do wait -n; done
  done
 done
done
wait
