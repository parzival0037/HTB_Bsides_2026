#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== home tree shallow"
find /home/rowan/repos /home/rowan/k05arch /home/rowan/.config -maxdepth 3 2>/dev/null | sort | head -120
echo "===== grep arwc/connector/report/district across rowan home (excluding cache)"
grep -rniI "arwc\|district\|connector\.arwc\|read.contract\|relay" /home/rowan --exclude-dir=.cache --exclude-dir=.npm --exclude-dir=.local 2>/dev/null | grep -v -E 'Binary|\.js:' | head -80
echo "===== any downloaded json/md in repos"
find /home/rowan/repos /home/rowan/k05arch -type f 2>/dev/null | head -80
INNER
