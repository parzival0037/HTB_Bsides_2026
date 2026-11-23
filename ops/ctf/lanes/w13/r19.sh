#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'bash -s' <<'RSH'
echo "=== grep home for keywords ==="
grep -rniIl 'appointment\|inspection crew\|roster\|check-in\|checkin\|gate pass\|site access\|assignments' /home/rowan 2>/dev/null | grep -v -E '\.(git|mozilla|cache)/' | head -40
echo "=== files mentioning edge ==="
grep -rniIl 'edge.keplerops\|ASMT-\|assignment_id\|pending_reviewer' /home/rowan 2>/dev/null | head -20
echo "=== work tree ==="
find /home/rowan/work -maxdepth 2 -type f 2>/dev/null | head -60
echo "=== docs/retained ==="
find /home/rowan -maxdepth 3 -iname '*arwc*' -o -maxdepth 3 -iname '*inspect*' -o -maxdepth 3 -iname '*access*' -o -maxdepth 3 -iname '*gate*' 2>/dev/null | head -40
RSH
