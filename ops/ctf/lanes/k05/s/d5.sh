set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
rm -f /tmp/cj
curl -sS -m 15 -c /tmp/cj "https://support.keplerops.test/scp/login.php" --cacert $CA -o /tmp/lp.html
curl -sS -m 15 -b /tmp/cj -c /tmp/cj -L -X POST "https://support.keplerops.test/scp/login.php" --cacert $CA \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data "submit=Sign+In" --data "do=login" -o /tmp/lr.html -w "code=%{http_code} url=%{url_effective}\n"
grep -io "invalid\|incorrect\|welcome\|dashboard\|tickets.php\|error[^<]*" /tmp/lr.html | sort -u | head
echo "=== dashboard"
curl -sS -m 15 -b /tmp/cj -c /tmp/cj "https://support.keplerops.test/scp/index.php" --cacert $CA -o /tmp/dash.html -w "code=%{http_code}\n"
grep -o "tickets.php?id=[0-9]*" /tmp/dash.html | sort -u | head
grep -io "[0-9]\{6\}" /tmp/dash.html | head
echo "=== open tickets"
curl -sS -m 15 -b /tmp/cj "https://support.keplerops.test/scp/tickets.php?status=open" --cacert $CA -o /tmp/t.html -w "code=%{http_code}\n"
grep -o "tickets.php?id=[0-9]*" /tmp/t.html | sort -u
grep -io "6\.9\.8[^<]\{0,100\}" /tmp/t.html | head' 2>&1 | tail -50
