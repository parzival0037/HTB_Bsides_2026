set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/login.html
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/login.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
for id in 1 2 3 4 5; do
  echo "########## TICKET $id ##########"
  curl -sS -m 10 --cacert $CA -b $J -c $J "$B/scp/tickets.php?id=$id" -o /tmp/t$id.html
  echo "--- links/attachments ---"
  grep -oE 'href="[^"]*(file|attach|download)[^"]*"' /tmp/t$id.html | sort -u
  echo "--- text ---"
  python3 - "$id" <<'PY'
import re,html,sys
d=open('/tmp/t%s.html'%sys.argv[1],errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S)
d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:5000])
PY
  echo
done
INNER
