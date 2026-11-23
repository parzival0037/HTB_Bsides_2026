set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'for f in work/build-operations/*.md; do echo ">>> $f"; cat "$f"; echo; done; echo "=== service-notes.md ==="; cat work/service-notes.md'
run 'ls -la ~/work/build-operations ~/work/analysis; echo ===; cat work/local-helper.md; echo ===; cat README.md'
run 'cat .bash_history; echo ===; find work -maxdepth 2 -type f -newermt 2026-09-18 | head; echo ===; ls -la results'
