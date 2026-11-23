set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
for B in 1842 1843; do
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-runner-operations/$B/api/json'; echo; echo ---CONSOLE---; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-runner-operations/$B/consoleText'; echo"
done
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-package-check/611/api/json'; echo; echo ---CONSOLE---; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-package-check/611/consoleText'; echo"
