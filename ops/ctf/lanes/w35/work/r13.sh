#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== /tmp/arwc_key ====="
$S 'cat /tmp/arwc_key; echo; echo ---; find /tmp/arwcpkg -type f | head -50; echo ---; for f in $(find /tmp/arwcpkg -type f | head -30); do echo "##### $f"; head -c 800 "$f"; echo; done'
echo "===== /tmp scripts mentioning arwc/supply ====="
$S 'grep -rilE "arwc|supply|district|procurement|quote" /tmp --include="*.sh" --include="*.py" --include="*.json" --include="*.html" 2>/dev/null | head -40'
echo "===== chrome history ====="
$S 'which sqlite3; for db in /tmp/History /tmp/Hist /home/rowan/.config/chromium/Default/History; do echo "### $db"; cp "$db" /tmp/hcopy 2>/dev/null && (sqlite3 /tmp/hcopy "select datetime(last_visit_time/1000000-11644473600,\"unixepoch\"),url,title from urls order by last_visit_time desc limit 60" 2>&1 | head -80); done'
