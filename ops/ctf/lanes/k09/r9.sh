set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "for R in BLD-1842 BLD-REC-021 BLD-REL-742 1842 BLD-1843; do echo \"### run \$R\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://review.keplerops.test/api/runs/\$R\"; echo; echo \"--log--\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://review.keplerops.test/api/runs/\$R/log\"; echo; done"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' -i 'https://review.keplerops.test/api/review-jobs'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' -i 'https://review.keplerops.test/api/review-jobs/BLD-1842'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/docs/report-provider.md?ref=main'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/review/FLK-7.4.2.md?ref=main'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/README.md?ref=main'; echo"
