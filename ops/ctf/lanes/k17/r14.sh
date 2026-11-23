set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ckp2.txt; rm -f $J
TOKEN=k17-talia-mornac-review-token-2841
curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
  --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
  --data-urlencode "userid=talia.mornac" --data-urlencode "submit=Login" -o /dev/null
echo "=== AJAX CHANGE PW DIALOG ==="
curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/ajax.php/staff/4/change-password" -o /tmp/cp.html -i | head -8
cat /tmp/cp.html | head -120
INNER
