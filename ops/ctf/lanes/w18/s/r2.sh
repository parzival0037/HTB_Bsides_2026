#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
echo "=== rowan-dev hosts"
ssh $KO rowan@10.50.13.180 'cat /etc/hosts; echo ---; ls ~/work; echo ---; cat ~/work/registry/README.md 2>/dev/null | head -80' 2>&1
