#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== acmd.sh full ====="
$S 'cat /tmp/acmd.sh'
echo "===== sw/res.txt ====="
$S 'ls -la /tmp/sw 2>/dev/null; cat /tmp/sw/res.txt 2>/dev/null; find /tmp/sw -type f 2>/dev/null | head'
echo "===== CA bundle + token origin ====="
$S 'ls -la /tmp/arwc-ca-bundle.pem; head -3 /tmp/arwc-ca-bundle.pem; grep -rl "6855eedb9d3dbcf022789ce0fa918daaca8c9f6fa071200850d05fba5a73acc1" /tmp /home/rowan 2>/dev/null | head'
