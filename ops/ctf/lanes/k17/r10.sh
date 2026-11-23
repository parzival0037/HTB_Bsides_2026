set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
TOKEN=k17-talia-mornac-review-token-2841
for U in "talia.mornac" "talia.mornac@keplerops.test" "talia.mornac-review@keplerops.test" "talia.mornac-review" "talia" "reviewer" "talia.mornac-review@support.keplerops.test"; do
 J=/tmp/c_$RANDOM.txt; rm -f $J
 curl -sS -m 10 --cacert $CA -c $J -b $J "$B/scp/pwreset.php?token=$TOKEN" -o /tmp/x1.html
 T=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/x1.html | sed -E 's/.*value="([^"]+)".*/\1/')
 code=$(curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/pwreset.php" \
   --data-urlencode "__CSRFToken__=$T" --data-urlencode "do=newpasswd" --data-urlencode "token=$TOKEN" \
   --data-urlencode "userid=$U" --data-urlencode "submit=Login" -o /tmp/x2.html -w '%{http_code}')
 pwin=$(grep -c 'type="password"' /tmp/x2.html)
 h3=$(grep -oE '<h3>[^<]*' /tmp/x2.html | head -1)
 echo "USER=$U code=$code pwdinputs=$pwin h3=$h3"
 grep -oE '<input[^>]*name="[^"]*"' /tmp/x2.html | sed -E 's/.*name="([^"]*)".*/  field: \1/' | sort -u
done
INNER
