#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/ot1.sh' <<'EOS'
#!/bin/bash
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://support.keplerops.test
J=/tmp/ck.txt; rm -f $J
curl -sS -m 10 --cacert $CA -c $J "$B/scp/login.php" -o /tmp/login.html
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/login.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 10 --cacert $CA -b $J -c $J -X POST "$B/scp/login.php" \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=/scp/tickets.php" --data-urlencode "submit=Sign In" -o /dev/null
for a in open closed all; do
 echo "##### ticket list $a"
 curl -sS -m 15 --cacert $CA -b $J -c $J "$B/scp/tickets.php?a=$a" -o /tmp/tl.html
 python3 - <<'PY'
import re,html
d=open('/tmp/tl.html',errors='ignore').read()
for m in re.finditer(r'tickets\.php\?id=(\d+)[^"]*"[^>]*>([^<]*)<',d):
    print(m.group(1), html.unescape(m.group(2)).strip()[:80])
ids=sorted(set(re.findall(r'tickets\.php\?id=(\d+)',d)))
print('IDS', ids)
PY
done
echo "##### kb"
curl -sS -m 15 --cacert $CA -b $J -c $J "$B/scp/kb.php" -o /tmp/kb.html -w '%{http_code}\n'
python3 - <<'PY'
import re,html
d=open('/tmp/kb.html',errors='ignore').read()
t=re.sub(r'<script.*?</script>|<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>',' ',t); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print(t[:2000])
print('KB links', sorted(set(re.findall(r'kb\.php\?id=(\d+)',d))))
PY
EOS
chmod +x /tmp/ot1.sh
$S 'bash /tmp/ot1.sh' 2>&1 | sed -n '/#####/,$p' | head -120
