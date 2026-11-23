set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/commits?limit=20' | head -c 8000; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/fixtures?ref=80560bcf8381c36ef82be771e58fc164a349ea07'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/fixtures/report-crr-og2.json?ref=80560bcf8381c36ef82be771e58fc164a349ea07'; echo"
