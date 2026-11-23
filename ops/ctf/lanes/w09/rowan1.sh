#!/bin/bash
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set -x
cat /etc/hosts
echo "===== HOME TREE"
ls -la ~
echo "===== WORK"
find ~/work -maxdepth 3 -type f -printf "%10s %p\n" 2>/dev/null | sort -k2 | head -200
echo "===== REPOS"
ls -la ~/repos 2>/dev/null
find ~/repos -maxdepth 3 -type d 2>/dev/null | head -60
echo "===== Service notes"
cat ~/work/service-notes.md 2>/dev/null
echo "===== platform access"
cat ~/work/platform-access.md 2>/dev/null
' 2>&1 | tail -300
