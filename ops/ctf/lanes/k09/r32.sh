set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'for B in fieldlink-report/1842 fieldlink-runner-operations/1842 fieldlink-runner-operations/1843 fieldlink-package-check/611; do echo "##### $B ws"; curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' "https://ci.keplerops.test/job/$B/ws/" | grep -oE "(href=\"[^\"]+\"|alt=\"[^\"]+\")" | head -80; echo; done'
run 'for P in "job/fieldlink-runner-operations/1842/ws/reports/" "job/fieldlink-runner-operations/1842/ws/../" "job/fieldlink-runner-operations/lastSuccessfulBuild/ws/" "job/fieldlink-runner-operations/ws/"; do echo "##### $P"; curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' "https://ci.keplerops.test/$P" | grep -oE "(href=\"[^\"]+\"|alt=\"[^\"]+\")" | head -60; echo; done'
run 'curl -sS -m 15 -g --cacert '"$CA"' -u '"$CRED"' "https://ci.keplerops.test/job/fieldlink-runner-operations/1842/ws/" | head -c 6000'
