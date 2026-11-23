#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== tools"
which nmap nc python3 masscan 2>&1
echo "===== connector-archive tree"
find /home/rowan/repos/connector-archive -type f | sort
echo "===== connector-archive README"
cat /home/rowan/repos/connector-archive/connector-archive/README.md
echo "===== notes"
for f in /home/rowan/repos/connector-archive/connector-archive/notes/*; do echo "--- $f"; cat "$f"; done
echo "===== grep relay/district/assistant in repos"
grep -rniI "district\|relay\|assistant\|retrieval\|linked" /home/rowan/repos --exclude-dir=.git 2>/dev/null | head -60
echo "===== fieldlink-connector repo tree"
find /home/rowan/repos/fieldlink-connector -type f | sort | head -80
INNER
