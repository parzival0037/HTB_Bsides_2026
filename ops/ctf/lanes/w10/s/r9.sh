#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
F=/tmp/al/index.js
echo "=== count /api"; grep -oE '/api/[A-Za-z0-9_./:-]*' $F | sort -u | head -120
echo "=== around workspace chat"
grep -oE '.{120}workspace/.{160}' $F | head -20
echo "=== strings with thread"
grep -oE '.{80}thread.{120}' $F | head -20
echo "=== source maps"
grep -oE 'sourceMappingURL=[^ ]*' $F | head
ls -la /tmp/al
INNER
