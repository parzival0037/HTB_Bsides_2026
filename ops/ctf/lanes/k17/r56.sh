set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "===== workload well-known FULL ====="
curl -sSk -m 8 --cacert $CA -u "$U" "https://workload.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool
echo "===== data well-known ====="
curl -sSk -m 8 --cacert $CA -u "$U" "https://data.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool
echo "===== workloads plural well-known ====="
curl -sSk -m 8 --cacert $CA -u "$U" "https://workloads.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool
INNER
echo DONE_R56
