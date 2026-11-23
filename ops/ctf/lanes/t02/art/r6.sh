#!/bin/bash
H=accounts.training
echo "=== revisions ==="
for r in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 20; do
  printf 'rev=%s: ' "$r"; curl -s --max-time 10 "http://$H:8080/api/directory/staff?revision=$r"; echo
done
echo "=== path guesses ==="
for p in /api/directory /api/directory/staff/all /api/directory/staff/hidden /api/directory/rehearsals /api/directory/assignments /api/directory/staff/STF-204/detail /api/directory/staff/STF-317/detail /api/directory/staff/STF-205/assignment /api/directory/staff/STF-1/assignment /api/directory/staff/STF-318/assignment /api/v1/directory/staff; do
  printf '%-50s ' "$p"; curl -s -o /tmp/o -w '%{http_code} %{size_download} ' --max-time 10 "http://$H:8080$p"; head -c 200 /tmp/o; echo
done
