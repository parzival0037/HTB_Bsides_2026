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
  echo "=== links ticket $id"
  grep -oE 'href="[^"]*"' /tmp/tk$id.html | grep -iE 'file|attach|download' | sort -u | head -20
  grep -oiE '(file\.php|view\.php\?id=[0-9]+&[^"]*)[^"<> ]*' /tmp/tk$id.html | sort -u | head -20
done
RSH
