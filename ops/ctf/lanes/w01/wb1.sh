#!/bin/bash
for u in http://workbench.training:8080/ http://workbench.training:8080/handover http://workbench.training:8080/git/handover.git/ http://workbench.training:8083/ ; do
echo "########## $u"
curl -sS --max-time 15 -i "$u" | head -c 3000; echo
done
echo "=== bare clone attempt ==="
cd /tmp && rm -rf handover.git && git clone --bare http://workbench.training:8080/git/handover.git handover.git 2>&1 | tail -5
git -C /tmp/handover.git log --all --oneline 2>&1 | head -20
git -C /tmp/handover.git ls-tree -r --name-only HEAD 2>&1 | head -60
