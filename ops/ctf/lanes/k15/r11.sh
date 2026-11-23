set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "=== work tree"
find /home/rowan/work -maxdepth 3 -type f | head -60
echo "=== grep export in home (md/json/txt/conf)"
grep -rIn --include=*.md --include=*.json --include=*.txt --include=*.conf --include=*.sh -i "export" /home/rowan 2>/dev/null | grep -v node_modules | grep -v '\.npm' | head -40
echo "=== samples dir"
ls -la /home/rowan/samples 2>/dev/null | head
echo "=== support-export notes"
grep -rIn -i "support export\|support-export\|export job\|job revision\|dataset" /home/rowan 2>/dev/null | grep -v node_modules | head -30
RSH
