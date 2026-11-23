set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "for J in fieldlink-report-review fieldlink-report fieldlink-runner-operations; do echo \"### \$J config\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://ci.keplerops.test/job/\$J/config.xml\"; echo; done"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' -i -X POST -H 'Content-Type: application/json' -d '{}' 'https://review.keplerops.test/api/jobs'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' -i -X POST -H 'Content-Type: application/json' -d '{}' 'https://review.keplerops.test/api/rehearsals/connector'; echo"
