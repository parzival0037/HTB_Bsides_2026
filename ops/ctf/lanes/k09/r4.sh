set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
for J in fieldlink-runner-operations fieldlink-package-check fieldlink-report-review; do
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/$J/api/json?tree=builds[number,result,url]'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/$J/api/json'; echo"
done
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-report/1842/consoleText'"
run "for f in REVNOTE-1842.json integration-review-input-v3.json ordinary-support-input-v1.json; do echo \"---\$f---\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://ci.keplerops.test/job/fieldlink-report/1842/artifact/reports/\$f\"; echo; done"
