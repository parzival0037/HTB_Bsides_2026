set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'B=https://ci.keplerops.test/job/fieldlink-runner-operations; for U in $B/1842/api/json $B/1842/consoleText $B/1842/artifact/reports/integration-review-input-v3.json $B/1842/artifact/reports/runner-log.txt $B/1842/; do echo "##### $U"; curl -sS -m 20 -g --cacert '"$CA"' -u '"$CRED"' "$U" | head -c 8000; echo; echo; done'
run 'for J in 1842 1843; do echo "##### job $J api"; curl -sS -m 20 -g --cacert '"$CA"' -u '"$CRED"' "https://ci.keplerops.test/job/fieldlink-runner-operations/$J/api/json"; echo; done'
