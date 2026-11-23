#!/bin/bash
H=accounts.training
S=VfVypNdOCy9v3nxKTpivD0xJWsyKfkEfWE2o3uOdC-c
for a in ASG-204 ASG-317; do
  echo "===== brief $a ====="
  curl -s -i --max-time 20 -H "Cookie: CINDER_REHEARSAL_SESSION=$S" "http://$H:8080/api/assignments/$a/brief"
  echo
done
