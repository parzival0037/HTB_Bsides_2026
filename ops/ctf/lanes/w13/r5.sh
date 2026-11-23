#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
for f in ~/work/fieldlink-connector/README.md ~/work/fieldlink-connector/docs/report-provider.md ~/work/fieldlink-connector/review/FLK-7.4.2.md ~/work/fieldlink-connector/tests/test_crr_og2_report.py; do echo "##### $f"; cat "$f"; done
echo "##### git log"; cd ~/work/fieldlink-connector && git log --oneline -20 2>&1; git branch -a 2>&1
INNER
