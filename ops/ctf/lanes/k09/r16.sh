set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://review.keplerops.test/api/jobs/JOB-215D690E28A8'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' -i 'https://review.keplerops.test/api/jobs/JOB-215D690E28A8/log'; echo"
