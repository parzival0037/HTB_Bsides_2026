#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
for f in ~/work/service-notes.md ~/work/platform-access.md ~/work/identity-access.md ~/work/local-helper.md ~/work/build-operations/connector-archive-review.md ~/work/registry/README.md ~/work/registry/consumer-request.json ~/repos/connector-archive/connector-archive/README.md ~/repos/connector-archive/connector-archive/notes/retained-diagnostic.md ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json; do
 echo "########## $f"; cat "$f" 2>/dev/null
done
INNER
