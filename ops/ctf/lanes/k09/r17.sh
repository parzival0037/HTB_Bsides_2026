set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/search?limit=50' | head -c 10000; echo"
run "for P in openapi.json api/templates api/jobs api/schema api/inputs api/runs api/artifacts; do echo \"### /\$P\"; curl -sS -m 8 -g --cacert $CA -u '$CRED' -o /dev/null -w '%{http_code} ' \"https://review.keplerops.test/\$P\"; curl -sS -m 8 -g --cacert $CA -u '$CRED' \"https://review.keplerops.test/\$P\" | head -c 500; echo; done"
