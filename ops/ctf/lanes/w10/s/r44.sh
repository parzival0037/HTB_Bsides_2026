#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== full /tmp listing"
ls -la /tmp | sed -n '1,200p'
echo "===== arwc_key"; cat /tmp/arwc_key 2>&1
echo "===== at.json"; cat /tmp/at.json 2>&1
echo "===== arwcpkg tree"; find /tmp/arwcpkg -maxdepth 3 -printf "%M %s %p\n" 2>&1 | head -40
echo "===== arch tree"; find /tmp/arch -maxdepth 4 -printf "%M %s %p\n" 2>&1 | head -60
echo "===== al tree"; find /tmp/al -maxdepth 2 -printf "%M %s %p\n" 2>&1 | head
echo "===== grep keywords in /tmp (names)"
grep -rniIl "district\|report.assistant\|source.selection\|linked.document\|planning excerpt\|cedar run\|riverbend\|north quay\|marshgate" /tmp 2>/dev/null | head -60
INNER
