set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "for B in 1842 1843; do echo \"### build \$B runner-log\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://ci.keplerops.test/job/fieldlink-runner-operations/\$B/artifact/reports/runner-log.txt\"; echo; done"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-runner-operations/1842/artifact/reports/integration-review-input-v3.json'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/artifact/reports/REVNOTE-1842.json'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/api/json?tree=artifacts[fileName,relativePath]'; echo"
