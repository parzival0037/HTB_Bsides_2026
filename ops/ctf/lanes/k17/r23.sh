set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckref.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$T" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
for u in "/scp/ajax.php/tickets/5/referrals" "/scp/ajax.php/tickets/5/referrals?do=manage"; do
 echo "########## $u"
 curl -sS -m 10 --cacert $CA -b $J -c $J "$B$u" -o /tmp/ref.html -i | head -8
 sed -n '1,160p' /tmp/ref.html
done
INNER
