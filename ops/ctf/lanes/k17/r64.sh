set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "===== review well-known ====="
curl -sSk -m 8 --cacert $CA "$U" -w '' "https://review.keplerops.test/.well-known/fieldkest-client" 2>/dev/null | head -c 200; echo
curl -sSk -m 8 --cacert $CA "https://review.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool 2>&1 | head -60
echo "===== review root/api ====="
for p in / /health /version /api/jobs /api/jobs?limit=20; do
 echo "--- $p"
 curl -sSk -m 8 --cacert $CA -w '\n[%{http_code}]\n' "https://review.keplerops.test$p" | head -c 600; echo
done
echo "===== indexer well-known/root ====="
for p in /.well-known/fieldkest-client / /health; do
 echo "--- $p"
 curl -sSk -m 8 --cacert $CA -w '\n[%{http_code}]\n' "https://indexer.keplerops.test$p" | head -c 900; echo
done
echo "===== source-tools well-known ====="
curl -sSk -m 8 --cacert $CA -w '\n[%{http_code}]\n' "https://source-tools.keplerops.test/.well-known/fieldkest-client" | head -c 1500; echo
echo "===== jenkins jobs list ====="
curl -sSk -m 10 --cacert $CA -u "$U" "https://ci.keplerops.test/api/json?tree=jobs[name,url,color]" | head -c 1500; echo
echo "===== jenkins review job config ====="
curl -sSk -m 10 --cacert $CA -u "$U" "https://ci.keplerops.test/job/fieldlink-report-review/config.xml" | head -c 2500; echo
INNER
echo DONE_R64
