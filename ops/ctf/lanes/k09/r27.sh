set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "for P in README.md internal internal/fieldlink internal/fieldlink/legacy-diagnostics internal/fieldlink/legacy-diagnostics/CRR-OG2 internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md; do echo \"### \$P\"; curl -sS -m 10 -g --cacert $CA -u '$CRED' \"https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/contents/\$P?ref=main\" | head -c 5000; echo; done"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://delivery.keplerops.test:8443/api/compatibility/entitlements/ENT-ARWC-DIAG-0698'; echo"
