set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
U=https://support.keplerops.test
rm -f /tmp/cj
curl -sS -m 15 -c /tmp/cj "$U/scp/login.php" --cacert "$CA" -o /tmp/lp.html
TOK=$(grep -o '__CSRFToken__" value="[a-f0-9]*' /tmp/lp.html | sed 's/.*value="//')
curl -sS -m 20 -b /tmp/cj -c /tmp/cj -X POST "$U/scp/login.php" --cacert "$CA" \
 -H "Referer: $U/scp/login.php" --data-urlencode "__CSRFToken__=$TOK" --data "do=scplogin" \
 --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
 --data "submit=Log+In" -o /dev/null
for id in 1 5; do
 curl -sS -m 20 -b /tmp/cj "$U/scp/tickets.php?id=$id" --cacert "$CA" -o /tmp/tk$id.html
 echo "=== ALL HREFS ticket $id"
 grep -oE 'href="[^"]+"' /tmp/tk$id.html | sort -u | head -40
 echo "=== any F- ids"
 grep -oE 'F-[A-Za-z0-9_-]{3,}' /tmp/tk$id.html | sort -u | head
 echo "=== img/obj"
 grep -oE '(src|data-file|data-url)="[^"]+"' /tmp/tk$id.html | sort -u | head -20
done
RSH
