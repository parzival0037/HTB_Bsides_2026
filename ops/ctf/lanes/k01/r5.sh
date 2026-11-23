set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
run "curl -sS -m 10 --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/issues?state=all&limit=50' | jq -r '.[] | \"#\\(.number) [\\(.state)] \\(.title) :: \\(.body)\"'"
run "curl -sS -m 10 --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/issues/1' | jq ."
run "curl -sS -m 10 --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/issues/1/comments' | jq -r '.[] | .body'"
run "curl -sS -m 10 -k -I 'https://support.keplerops.test/scp/' ; echo ---; curl -sS -m 10 --cacert $CA 'https://support.keplerops.test/scp/' | head -40; echo ---STAFF---; curl -sS -m 10 --cacert $CA 'https://staff.keplerops.test/' | head -40"
