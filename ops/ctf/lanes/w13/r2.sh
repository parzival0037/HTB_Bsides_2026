#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
echo "=== repos tree ==="
find ~/repos -maxdepth 4 -type f 2>/dev/null | head -100
echo "=== work ==="
find ~/work -maxdepth 3 2>/dev/null | head -60
echo "=== grep cinder/appointment/roster/checkin ==="
grep -ril -E 'cinder|appointment|roster|check-in|checkin' ~/repos ~/work ~/.config 2>/dev/null | grep -v node_modules | head -40
echo "=== chromium history ==="
cp ~/.config/chromium/Default/History /tmp/h.db 2>/dev/null
sqlite3 /tmp/h.db "select datetime(last_visit_time/1000000-11644473600,'unixepoch'),url,title from urls order by last_visit_time desc limit 80;" 2>/dev/null
echo "=== archive zip ==="
ls -la ~/repos/connector-archive.zip 2>/dev/null
unzip -l ~/repos/connector-archive.zip 2>/dev/null | head -40
INNER
