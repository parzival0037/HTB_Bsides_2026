#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== work docs ====="
$S 'for f in ~/work/*.md ~/work/*/*.md; do echo "##### $f"; cat "$f"; echo; done 2>/dev/null | head -300'
echo "===== kube cache grep ====="
$S 'f=/home/rowan/.kube/cache/http/d43ad12d5ad391a7150d7bc67dea06e85d13e2b51e4143efd1693155c6f7fb0e; ls -la $f; grep -aoiE ".{60}(supply|procurement|district|quote|catalog|arwc).{80}" $f | head -20'
echo "===== home listing ====="
$S 'ls -la ~; echo ===; ls -la ~/work ~/repos ~/w09 2>/dev/null'
