#!/bin/bash
echo "== hosts file on box"; cat /etc/hosts
echo "== ssh rowan hosts"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat /etc/hosts; echo ---; ls ~; echo ---; cat ~/.ssh/config 2>/dev/null' 2>&1 | tail -60
