set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -i 'https://review.keplerops.test/.well-known/fieldkest-client'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' -i 'https://review.keplerops.test/'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://review.keplerops.test/health'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://review.keplerops.test/api/jobs'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-package-check/611/artifact/package-workspace/support-rehearsal.json'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-package-check/611/artifact/package-workspace/package-manifest.json'; echo; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-package-check/611/artifact/package-workspace/fieldlink-connector.json'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/job/fieldlink-package-check/611/api/xml' | head -c 5000; echo"
