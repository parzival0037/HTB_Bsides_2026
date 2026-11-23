#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
cp /tmp/arwc_key /tmp/w10_key 2>/dev/null; chmod 600 /tmp/w10_key
echo "===== ssh as fieldlink"
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i /tmp/w10_key fieldlink@connector.arwc.test 'id; hostname; uname -a; echo HOME=$HOME; ls -la /; cat /etc/hosts; echo ---; (ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null) | head -40; echo ---; ps aux | head -40; echo ---; ls -la $HOME; find $HOME -maxdepth 3 2>/dev/null | head -60' 2>&1 | head -200
INNER
