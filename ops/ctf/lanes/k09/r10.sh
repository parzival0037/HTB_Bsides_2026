set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
for A in integration-review-input-v3.json REVNOTE-1842.json ordinary-support-input-v1.json junit.xml; do
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://review.keplerops.test/api/runs/BLD-1842/artifacts/$A'; echo"
done
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://review.keplerops.test/api/runs/BLD-REL-742/artifacts/release-dossier.json'; echo"
run "curl -sS -m 10 -g --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/repos/fieldkest/release-signer-history/contents/?ref=be1f58577829a77f999813b24a8fdeabb8a0298f'; echo"
