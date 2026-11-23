set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "for J in RJ-F19BB9AD RJ-F0188775 RJ-918FB142 RJ-25566054; do echo \"### \$J\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://review.keplerops.test/api/review-jobs/\$J\"; echo; done"
