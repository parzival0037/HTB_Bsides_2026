S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
echo "=== ~/.config/fieldlink"
ls -la ~/.config/fieldlink 2>/dev/null
for f in ~/.config/fieldlink/*; do echo "##### $f"; cat "$f"; echo; done
echo "=== other config dirs"
ls -la ~/.config 2>/dev/null | head -30
echo "=== home files"
ls -la ~ | head -40
echo "=== grep reconcile tokens in home (skip .cache)"
grep -rilE "reconcile|integration.token|dossier" ~ --include='*.json' --include='*.md' --include='*.txt' --include='*.js' --include='*.env' 2>/dev/null | head -20
echo "=== npmrc"
cat ~/.npmrc 2>/dev/null
RSH
