#!/bin/bash
echo "### banner"
timeout 6 bash -c 'exec 3<>/dev/tcp/10.77.60.20/22; head -c 200 <&3' 2>&1
echo
echo "### ssh probes from rowan-dev"
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'for u in rowan cinder arwc fieldlink relay customer admin root; do echo "--- $u"; timeout 8 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o PreferredAuthentications=publickey,password -o ConnectTimeout=5 $u@connector.arwc.test "id" 2>&1 | head -3; done'
