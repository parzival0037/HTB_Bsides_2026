set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'ls -la .config; echo ===; ls -la .config/fieldlink 2>&1; echo ===; cat .config/fieldlink/*.json 2>&1'
run 'ls -la .mozilla 2>&1; find .mozilla -maxdepth 4 -type f 2>/dev/null | head -80'
run 'ls -la .config/chromium 2>&1; find .config/chromium -maxdepth 3 -type f 2>/dev/null | head -80'
run 'curl -sS -m 5 -i http://127.0.0.1:8701/ 2>&1 | head -30; echo ===; curl -sS -m 5 http://127.0.0.1:8701/api/inspection-summary 2>&1 | head -20; echo ===; ss -tlnp 2>/dev/null'
