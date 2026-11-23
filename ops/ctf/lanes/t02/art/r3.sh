#!/bin/bash
H=accounts.training
echo "===== app.js ====="
curl -s -i --max-time 15 "http://$H:8080/directory/app.js"
echo
echo "===== other assets ====="
for p in /app.js /directory/index.html /directory/data.json /directory/api /api/staff/directory /api/directory/staff; do
  echo "--- $p"; curl -s -o /dev/null -w '%{http_code} %{size_download} %{content_type}\n' "http://$H:8080$p"
done
