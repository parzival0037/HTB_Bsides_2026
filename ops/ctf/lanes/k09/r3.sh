set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/whoAmI/api/json' ; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/api/json?tree=jobs[name,url,color]' | head -c 6000; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/api/json' | head -c 6000; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/consoleText' | head -c 3000; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/api/json?tree=builds[number,result,url]' | head -c 4000; echo"
