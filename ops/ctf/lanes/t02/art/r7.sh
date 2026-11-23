#!/bin/bash
H=accounts.training
J=/tmp/cj.txt
echo "===== redeem ====="
curl -s -i -c $J --max-time 20 -X POST -H 'Content-Type: application/json' \
  -d '{"account":"rhea.moss","case_fragment":"CASE-7Q4M","staff_detail":"Blue cabinet 17"}' \
  "http://$H:8080/api/recovery/redeem"
echo; echo "===== cookies ====="; cat $J
echo "===== handover ====="
curl -s -i -b $J --max-time 20 "http://$H:8080/api/handover"
echo; echo "===== assignments ====="
curl -s -i -b $J --max-time 20 "http://$H:8080/api/assignments"
echo
