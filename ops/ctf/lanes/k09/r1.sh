set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cat work/service-notes.md'
run 'cat work/build-operations/*.md'
run 'curl -sS -m 8 -i http://ci.keplerops.test/ | head -40'
run 'curl -sS -m 8 http://ci.keplerops.test/api/json 2>&1 | head -c 2000'
run 'curl -sS -m 8 -i https://ci.keplerops.test/ 2>&1 | head -40'
