set +e
R(){ ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev "$1" 2>&1; }
echo "===== service-notes full ====="
R 'cat work/service-notes.md'
echo "===== config/fieldlink ====="
R 'ls -la .config/fieldlink/ 2>&1; for f in .config/fieldlink/*; do echo "--- $f"; head -c 2000 "$f"; echo; done'
echo "===== aws config ====="
R 'cat .aws/config; echo ---; cat .aws/credentials'
echo "===== s3 ls buckets ====="
R 'aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1'
echo "===== s3 ls fieldlink-exports ====="
R 'aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1'
echo "===== s3 ls recursive ====="
R 'aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports 2>&1 | head -100'
echo "===== kube ====="
R 'cat .kube/config | head -60; echo ---; kubectl config current-context 2>&1; kubectl get ns 2>&1 | head; kubectl get all 2>&1 | head -40'
echo "===== workspace notes grep ====="
R 'grep -rilE "export|bucket|object" work/ 2>/dev/null; echo ---; grep -rniE "support.?export|export" work/*.md 2>/dev/null | head -40'
echo DONE_K13_R2
