set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'ls -laR .config/fieldlink .config 2>&1 | head -80; echo "=== SUPPORT CLIENT ==="; for f in .config/fieldlink/*; do echo "--- $f"; cat "$f"; echo; done'
run 'ls -la .local/share/keplerops; echo ===; cat .config/chromium/Default/Preferences; echo; echo "=== hist dirs ==="; find .config -type f | head -40'
run 'ls -la .config/fieldlink; stat .config/fieldlink/support-client.json 2>/dev/null'
run 'cat .config/git/credentials; echo ===; cat .kube/config | head -60; echo ===; cat .aws/config'
