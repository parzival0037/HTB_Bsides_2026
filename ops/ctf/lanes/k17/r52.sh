set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
for h in portal support cases case ticket tickets helpdesk mail intranet engineering water scada ops relay api www files docs notes archive workbench review staff connector \
         portal.arwc.test support.arwc.test cases.arwc.test case.arwc.test tickets.arwc.test docs.arwc.test files.arwc.test api.arwc.test www.arwc.test engineering.arwc.test ops.arwc.test; do
  ip=$(getent hosts $h 2>/dev/null | awk '{print $1}' | head -1)
  [ -n "$ip" ] && echo "$h -> $ip"
done
echo "=== try full arwc names ==="
for s in portal case cases support ticket tickets docs files api www engineering ops intranet helpdesk mail notes archive review relay; do
  ip=$(getent hosts $s.arwc.test 2>/dev/null | awk '{print $1}' | head -1)
  [ -n "$ip" ] && echo "$s.arwc.test -> $ip"
done
echo "=== try keplerops names ==="
for s in case cases portal ticket docs files api notes archive delegation identity cert support staff workboard tickets k-dev source-tools; do
  ip=$(getent hosts $s.keplerops.test 2>/dev/null | awk '{print $1}' | head -1)
  [ -n "$ip" ] && echo "$s.keplerops.test -> $ip"
done
echo "=== keplerops range hosts? 10.77.60.0 sweep 80/443/8443 ==="
for ip in 10.77.60.20 10.77.60.21 10.77.60.22 10.77.60.10; do
  for p in 80 443 8443; do
    echo -n "$ip:$p "; timeout 3 bash -c "</dev/tcp/$ip/$p" 2>/dev/null && echo open || echo closed
  done
done
INNER
echo DONE_R52
