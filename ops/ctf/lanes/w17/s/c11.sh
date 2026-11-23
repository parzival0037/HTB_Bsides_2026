#!/bin/bash
set +e
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'set +e
cd ~/repos/connector-archive/connector-archive 2>/dev/null || cd ~/repos/connector-archive
pwd
echo "== tree"; find . -type f | head -80
echo "== grep keywords"
grep -rInE "hmi\.arwc|opc\.tcp|4840|channel|identity|historian|ot_history|fuxa|openplc|CairnReach|Cairn Reach|process_samples" . 2>/dev/null | grep -v "Binary" | head -60
echo "== notes files"
for f in $(find . -name "*.md" -o -name "*.json" -o -name "*.conf" | head -30); do echo "### $f"; head -c 1200 "$f"; echo; done
' 2>&1 | tail -200
