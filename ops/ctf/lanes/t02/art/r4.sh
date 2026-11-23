#!/bin/bash
H=accounts.training
echo "===== /api/directory/staff ====="
curl -s --max-time 15 "http://$H:8080/api/directory/staff" | python3 -m json.tool
echo
echo "===== lookup probes ====="
for a in mina.cho rhea.moss owen.pike nobody.xyz; do
  echo "--- $a"
  curl -s -i --max-time 15 -X POST -H 'Content-Type: application/json' -d "{\"account\":\"$a\"}" "http://$H:8080/api/recovery/lookup"
  echo
done
