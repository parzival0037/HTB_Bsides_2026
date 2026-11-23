set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
SB='Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
export KRB5CCNAME=FILE:/home/rowan/work/krb5cc_evan
echo "===== auhentication variants on workload ====="
for h in workload.keplerops.test workloads.keplerops.test; do
 for p in "/" "/.well-known/fieldkest-client" "/api" "/api/workloads" "/api/jobs" "/api/cases" "/api/handovers"; do
  echo "--- $h$p basic"
  curl -sSk -m 6 --cacert $CA -u "$U" -w '\n[%{http_code}]\n' "https://$h$p" | head -c 500; echo
 done
 break
done
echo "===== bearer support token ====="
for p in / /api /api/workloads /api/cases; do
 echo "--- $p"
 curl -sSk -m 6 --cacert $CA -H "$SB" -w '\n[%{http_code}]\n' "https://workload.keplerops.test$p" | head -c 600; echo
done
echo "===== SPNEGO ====="
for p in / /api /api/workloads; do
 echo "--- $p"
 curl -sSk -m 10 --cacert $CA --negotiate -u : -w '\n[%{http_code}]\n' "https://workload.keplerops.test$p" | head -c 600; echo
done
echo "===== well-known variants ====="
for p in /.well-known/fieldkest-client /.well-known/fieldkest-workload /.well-known/workload; do
 echo "--- $p"
 curl -sSk -m 6 --cacert $CA -w '\n[%{http_code}]\n' "https://workload.keplerops.test$p" | head -c 1200; echo
done
echo "===== auth headers probe ====="
for H in "X-Workload-Token: x" "Authorization: Workload x" "Authorization: Negotiate x" "X-Client-Cert: x"; do
 echo "--- $H"
 curl -sSk -m 6 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "https://workload.keplerops.test/api/workloads" | head -c 300; echo
done
INNER
echo DONE_R55
