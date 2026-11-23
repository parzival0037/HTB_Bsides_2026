set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "for U in 'job/fieldlink-report/1842/' 'job/fieldlink-runner-operations/1842/' 'job/fieldlink-runner-operations/1843/'; do echo \"### \$U\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://ci.keplerops.test/\$U\" | grep -oE '(artifact/[^\"]+|href=\"[^\"]*artifact[^\"]*\"|reports/[A-Za-z0-9._-]+)' | sort -u; echo; done"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/artifact/reports/ordinary-support-input-v1.json'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/artifact/reports/integration-review-input-v3.json'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-runner-operations/1843/artifact/reports/runner-log.txt'; echo"
