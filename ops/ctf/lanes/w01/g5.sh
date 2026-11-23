#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/g5.sh' <<'EOS'
#!/bin/bash
echo "### repos tree"
find ~/repos ~/repos_k05 ~/work -maxdepth 3 2>/dev/null | head -80
echo "### grep cairn/planning/procure/handback"
grep -ril -E "cairn|handback|procurement|supplementary" ~/repos ~/work ~/.config/fieldlink 2>/dev/null | head -30
echo "### analysis files"
ls -la ~/work/analysis ~/work/build-operations 2>/dev/null
for f in ~/work/analysis/* ~/work/build-operations/*; do echo "--- $f"; head -60 "$f"; done 2>/dev/null
EOS
chmod +x /tmp/g5.sh
$S 'bash /tmp/g5.sh' 2>&1 | head -220
