#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
ls -l /tmp/arwc_key; md5sum /tmp/arwc_key
for u in fieldlink arwc connector maintenance; do echo "--- $u"; timeout 12 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=8 -i /tmp/arwc_key $u@connector.arwc.test 'id; hostname; echo OK' 2>&1 | tail -4; done
echo "--- via 10.77.60.20"; timeout 12 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=8 -i /tmp/arwc_key fieldlink@10.77.60.20 'id; hostname' 2>&1 | tail -4
INNER
