#!/bin/bash
ssh -i ~/.ssh/keplerops-foothold -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@10.50.13.180 '
for f in ~/work/previews/index.html ~/work/previews/review.css ~/work/registry/README.md ~/work/registry/consumer-request.json ~/work/registry/inspection-normal.json ~/work/registry/inspection-compat.fki ~/work/samples/FK-SAMPLE-017.json ~/work/local-helper.md ~/work/identity-access.md ~/work/reproducers/indexer-client.json ~/README.md; do
  echo "===== $f ====="; cat "$f"; echo; done
echo "===== support-client.json ====="; cat ~/.config/fieldlink/support-client.json
echo; echo "===== git log ====="; git -C ~/work/fieldlink-connector log --oneline --all | head -20
echo "===== git show fixture ====="; git -C ~/work/fieldlink-connector show 80560bcf8381c36ef82be771e58fc164a349ea07:fixtures/report-crr-og2.json | sha256sum
git -C ~/work/fieldlink-connector show 80560bcf8381c36ef82be771e58fc164a349ea07:fixtures/report-crr-og2.json | od -c | tail -5
' 2>&1 | head -250
