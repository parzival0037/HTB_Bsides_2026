#!/bin/bash
H=accounts.training
for p in /api/directory/staff/STF-204 /api/directory/staff/STF-317 /api/directory/staff/STF-204/assignment /api/directory/staff/STF-317/assignment; do
  echo "===== $p ====="
  curl -s -i --max-time 15 "http://$H:8080$p"; echo
done
echo "===== query variants on staff ====="
for q in '?revision=12' '?include=all' '?all=1' '?team=Receiving' '?limit=100' '?include_hidden=true' '?role=coordinator'; do
  echo "--- $q"; curl -s -w ' [%{http_code} %{size_download}]\n' --max-time 15 "http://$H:8080/api/directory/staff$q"
done
