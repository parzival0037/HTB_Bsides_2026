set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
for H in staff workboard; do
 echo "########## $H login page"
 curl -sS -m 8 --cacert $CA -c /tmp/$H.ck "https://$H.keplerops.test/login" -o /tmp/$H.html -i | head -12
 grep -oE '<form[^>]*>|<input[^>]*>' /tmp/$H.html | head -20
 grep -oiE '<title>[^<]*|Powered by[^<]*|HESK[^<]*' /tmp/$H.html | head -5
done
echo "########## identity account"
curl -sS -m 8 --cacert $CA -i https://identity.keplerops.test/realms/keplerops/account/ 2>&1 | head -20
echo "########## assistant"
curl -sS -m 8 --cacert $CA -i https://assistant.keplerops.test/ 2>&1 | head -20
echo "########## support ticket5 referral links"
J=/tmp/ck5x.txt; rm -f $J
B=https://support.keplerops.test
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/l.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
 --data-urlencode "__CSRFToken__=$T" --data-urlencode "userid=maya.ranscombe" \
 --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php?id=5" -o /tmp/t5.html
grep -oiE 'href="[^"]*"[^>]*>[^<]*(refer|delegat|forward|assign)[^<]*' /tmp/t5.html | head -20
grep -oiE '.{0,80}(referral|delegat).{0,120}' /tmp/t5.html | head -20
INNER
