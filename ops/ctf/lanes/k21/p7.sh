set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
for h in assistant.keplerops.test support.keplerops.test tickets.keplerops.test staff.keplerops.test workboard.keplerops.test workloads.keplerops.test workload.keplerops.test id.keplerops.test identity.keplerops.test; do
  echo "===== https://$h/.well-known/fieldkest-client"
  curl -sSk -m 10 --cacert $CA -i "https://$h/.well-known/fieldkest-client" 2>&1 | head -30
done
echo "===== assistant /api/config headers"
curl -sSk -m 10 --cacert $CA -i "https://assistant.keplerops.test/api/config" | head -20
INNER
echo DONE_MARK_$RANDOM
