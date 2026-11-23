set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -i 'https://delivery.keplerops.test:8443/.well-known/fieldkest-client'; echo"
run "for R in release-signer-history connector-archive; do echo \"### \$R\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://source.keplerops.test/api/v1/repos/fieldkest/\$R/contents/?ref=main\"; echo; done"
run "for R in release-signer-history connector-archive; do echo \"### \$R commits\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://source.keplerops.test/api/v1/repos/fieldkest/\$R/commits?limit=20\"; echo; done"
