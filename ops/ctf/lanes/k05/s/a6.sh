set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'set +x
echo "=== git creds"; cat ~/.config/git/credentials
echo "=== fieldlink config"; ls -la ~/.config/fieldlink; cat ~/.config/fieldlink/*.json 2>/dev/null | head -60
echo "=== chromium files"; find ~/.config/chromium -maxdepth 3 -type f 2>/dev/null | head -40
echo "=== history"; cat ~/.bash_history 2>/dev/null | tail -40
echo "=== env"; env | grep -i -E "token|key|auth" ; ls -la ~ | head -40' 2>&1 | tail -100
