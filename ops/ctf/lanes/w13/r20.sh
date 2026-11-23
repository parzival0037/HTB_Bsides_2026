#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'bash -s' <<'RSH'
echo "=== identity-access.md ==="; cat /home/rowan/work/identity-access.md
echo "=== service-notes.md ==="; cat /home/rowan/work/service-notes.md
echo "=== kube cache hit ==="; cat /home/rowan/.kube/cache/http/d43ad12d5ad391a7150d7bc67dea06e85d13e2b51e4143efd1693155c6f7fb0e | head -c 3000
echo; echo "=== local-helper.md ==="; cat /home/rowan/work/local-helper.md
RSH
