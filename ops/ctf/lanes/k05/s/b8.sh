set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "=== handover current"; curl -sS -m 15 -H "$B" "https://support.keplerops.test:8443/api/handovers/current" --cacert $CA; echo
echo "=== osTicket login"
rm -f /tmp/cj; 
curl -sS -m 15 -c /tmp/cj "https://support.keplerops.test/scp/login.php" --cacert $CA -o /tmp/lp.html
grep -o "name=\"[a-z_]*\"" /tmp/lp.html | sort -u | head
curl -sS -m 15 -b /tmp/cj -c /tmp/cj -X POST "https://support.keplerops.test/scp/login.php" --cacert $CA \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "pass=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data "submit=Log+In" -o /tmp/lr.html -w "code=%{http_code} url=%{url_effective}\n"
head -c 400 /tmp/lr.html; echo
echo "=== tickets list"
curl -sS -m 15 -b /tmp/cj "https://support.keplerops.test/scp/tickets.php" --cacert $CA -o /tmp/t.html -w "code=%{http_code}\n"
grep -o "tickets.php?id=[0-9]*" /tmp/t.html | sort -u | head -20
grep -io "6\.9\.8[^<]\{0,80\}" /tmp/t.html | head
' 2>&1 | tail -60
