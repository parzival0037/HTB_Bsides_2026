set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/git/trees/main?recursive=1' | python3 -c 'import sys,json; d=json.load(sys.stdin); print(\"\\n\".join(x[\"path\"] for x in d.get(\"tree\",[])))'"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/user/rowan.ito/credentials/' | sed -n 's/.*<a href=\"\([^\"]*\)\".*/\1/p' | sort -u | head -50; echo ---; curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/credentials/' | grep -oE 'credential|store/[^\"]*|/credentials/[^\"]*' | sort -u | head -30"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://ci.keplerops.test/asynchPeople/api/json' | head -c 3000; echo"
run "for U in /api/json /user/ci-automation/api/json /user/fieldlink-ci/api/json /me/api/json; do echo \"### \$U\"; curl -sS -m 8 -g --cacert $CA -u '$CRED' \"https://ci.keplerops.test\$U\" | head -c 1000; echo; done"
