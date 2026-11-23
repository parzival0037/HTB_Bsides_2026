#!/bin/bash
set +e
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'set +e
for f in ~/work/service-notes.md ~/work/platform-access.md ~/work/local-helper.md ~/work/identity-access.md ~/work/registry/README.md ~/work/fieldlink-connector/review/FLK-7.4.2.md ~/work/fieldlink-connector/tests/test_crr_og2_report.py ~/work/reproducers/indexer-client.json; do echo "##### $f"; cat "$f"; echo; done
echo "##### samples FK-SAMPLE-017"; cat ~/work/samples/FK-SAMPLE-017.json
echo "##### ls repos"; ls -la ~/ ; ls -la ~/repos ~/repos_k05 2>/dev/null | head -40
' 2>&1 | tail -240
