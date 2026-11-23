set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "===== /etc/hosts ====="; cat /etc/hosts
echo "===== resolv ====="; cat /etc/resolv.conf
echo "===== probe candidate hosts ====="
for h in tickets.keplerops.test case.keplerops.test cases.keplerops.test archive.keplerops.test cert.keplerops.test connector.arwc.test awrc.test arwc.test; do
 echo "--- $h"
 getent hosts $h || echo "no dns"
 curl -sSk -m 6 --cacert $CA -i "https://$h/" 2>&1 | head -12
done
echo "===== probe well-knowns ====="
for h in tickets.keplerops.test case.keplerops.test cert.keplerops.test connector.arwc.test support.keplerops.test staff.keplerops.test; do
 echo "--- $h/.well-known/fieldkest-client"
 curl -sSk -m 6 --cacert $CA -w '\n[%{http_code}]\n' "https://$h/.well-known/fieldkest-client" | head -c 1500; echo
done
INNER
echo DONE_R44
