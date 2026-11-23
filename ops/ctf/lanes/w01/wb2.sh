#!/bin/bash
cd /tmp && rm -rf handover.git && git clone -q --bare http://workbench.training:8080/git/handover.git handover.git 2>&1
echo "### log"
git -C /tmp/handover.git log --all --stat --format='%H %ci %s'
echo "### HEAD handover.md"
git -C /tmp/handover.git show HEAD:handover.md
echo "### 04176f3 handover.md"
git -C /tmp/handover.git show 04176f3:handover.md
echo "### all refs"
git -C /tmp/handover.git show-ref
echo "### delivery tracker"
curl -sS --max-time 15 http://workbench.training:8080/workspace/delivery-tracker.csv
echo "### retired client"
curl -sS --max-time 15 http://workbench.training:8080/retired-client/profile.json
echo "### diagnostic DL-204"
curl -sS --max-time 15 'http://workbench.training:8083/api/diagnostics/render?delivery_id=DL-204&view=public/DL-204.json'
