#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== service-notes.md"
$SSH 'cat /home/rowan/work/service-notes.md'
echo "===== platform-access.md"
$SSH 'cat /home/rowan/work/platform-access.md'
echo "===== identity-access.md"
$SSH 'cat /home/rowan/work/identity-access.md'
echo "===== local-helper.md"
$SSH 'cat /home/rowan/work/local-helper.md'
echo "===== README.md home"
$SSH 'cat /home/rowan/README.md'
echo "===== analysis"
$SSH 'head -c 2000 /home/rowan/work/analysis/field-notes-2026-08.odt; echo; echo ---; head -c 1000 /home/rowan/work/analysis/staging-decoder.ps1'
echo "===== reproducers"
$SSH 'ls -la /home/rowan/work/reproducers/fieldkest-bundle-indexer; cat /home/rowan/work/reproducers/indexer-client.json; echo; for f in /home/rowan/work/reproducers/fieldkest-bundle-indexer/*; do echo "--- $f"; head -c 3000 "$f"; echo; done'
echo "===== samples"
$SSH 'cat /home/rowan/work/samples/FK-SAMPLE-017.json'
