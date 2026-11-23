#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
for f in ~/README.md ~/work/service-notes.md ~/work/platform-access.md ~/work/build-operations/connector-archive-review.md ~/work/build-operations/release-lineage-review.md ~/work/build-operations/policy-compiler-handoff.md ~/work/fieldlink-connector/README.md ~/work/fieldlink-connector/docs/report-provider.md ~/work/fieldlink-connector/review/FLK-7.4.2.md ~/work/registry/README.md ~/work/registry/consumer-request.json ~/work/local-helper.md ~/work/identity-access.md; do echo "############ $f"; cat "$f" 2>/dev/null; echo; done
' 2>&1
