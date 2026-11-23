#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
for f in /home/rowan/work/fieldlink-connector/README.md /home/rowan/work/fieldlink-connector/docs/report-provider.md /home/rowan/work/fieldlink-connector/review/FLK-7.4.2.md /home/rowan/work/fieldlink-connector/tests/test_crr_og2_report.py /home/rowan/work/registry/README.md /home/rowan/work/registry/consumer-request.json /home/rowan/work/previews/index.html; do
  echo; echo "==================== $f"; cat "$f"
done
INNER
