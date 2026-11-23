set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cat .config/git/credentials'
run "C=\$(cat /home/rowan/.config/git/credentials | sed -n 's#https://\([^:]*\):\([^@]*\)@.*#\1:\2#p' | head -1); echo CRED=\$C; curl -sS -m 10 --cacert $CA -u \"\$C\" 'https://ci.keplerops.test/api/json?tree=jobs[name,url,color]' | head -c 4000; echo"
run "curl -sS -m 10 --cacert $CA -i 'https://ci.keplerops.test/' | head -30"
