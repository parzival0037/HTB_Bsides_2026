#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== company-history.dump ====="
$S 'cat ~/w09/company-history.dump'
echo "===== README/sj/analysis/reproducers ====="
$S 'cat ~/README.md; echo ---SJ; cat ~/sj.txt; echo ---ANALYSIS; ls -la ~/work/analysis ~/work/reproducers; for f in ~/work/analysis/* ~/work/reproducers/*; do echo "##### $f"; head -c 2000 "$f"; echo; done'
echo "===== identity-access/platform-access/local-helper ====="
$S 'cat ~/work/identity-access.md ~/work/platform-access.md ~/work/local-helper.md'
echo "===== grep core ====="
$S 'timeout 150 grep -aoE "[A-Za-z0-9._/-]{0,40}(arwc|supply|district|quote|procurement|replacement)[A-Za-z0-9._/-]{0,40}" ~/core 2>/dev/null | sort -u | head -120'
