set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
P=https://packages.keplerops.test
echo "===== npmrc ====="; cat /home/rowan/.npmrc 2>/dev/null
echo "===== registry root ====="
curl -sSk -m 8 --cacert $CA "$P/" | head -c 500; echo
echo "===== search fieldkest ====="
curl -sSk -m 8 --cacert $CA "$P/-/v1/search?text=fieldkest&size=50" | head -c 2000; echo
echo "===== search connector ====="
curl -sSk -m 8 --cacert $CA "$P/-/v1/search?text=connector&size=50" | head -c 1500; echo
echo "===== all packages (couch list) ====="
curl -sSk -m 8 --cacert $CA "$P/-/all" | head -c 1200; echo
echo "===== npm ping / whoami ====="
cd /home/rowan && npm ping 2>&1 | tail -3; npm whoami 2>&1 | tail -2
echo "===== npm search ====="
npm search fieldkest --json 2>&1 | head -c 1500; echo
echo "===== workload hosts ====="
for h in workload.keplerops.test workloads.keplerops.test id.keplerops.test ca.keplerops.test cert.keplerops.test; do
 echo "--- $h"
 curl -sSk -m 6 --cacert $CA -i "https://$h/" 2>&1 | head -10
done
INNER
echo DONE_R54
