S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
echo "=== service-notes tail"; sed -n '/FieldLink support integration/,$p' ~/work/service-notes.md
echo "=== previews/index.html"; head -80 ~/work/previews/index.html
echo "=== analysis notes"; ls -la ~/work/analysis; cat ~/work/analysis/staging-decoder.ps1 | head -40
echo "=== results dir"; ls -la ~/results
RSH
