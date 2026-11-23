CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test; CK=/tmp/k25-ck.txt
# re-login fresh to be safe
rm -f $CK
curl -sS $P --cacert $CA -m 25 -c $CK -o /tmp/l.html "$B/scp/login.php"
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | head -1 | sed 's/.*value="//;s/"//')
curl -sS $P --cacert $CA -m 25 -c $CK -b $CK -o /dev/null -w 'login:%{http_code}\n' \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=scplogin" \
  --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=$B/scp/tickets.php" "$B/scp/login.php"
curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/t1.html "$B/scp/tickets.php?id=1"
echo "=== file/attachment refs"
grep -oiE '(href|src|data-[a-z-]+)="[^"]{0,200}(file|attach|upload|download)[^"]{0,200}"' /tmp/t1.html | sort -u | head -40
echo "=== any file.php"
grep -oiE '[^"'"'"' ]*file\.php[^"'"'"' ]*' /tmp/t1.html | sort -u | head -20
echo "=== 'attachment' words"
grep -oiE '.{80}attach.{120}' /tmp/t1.html | head -20
echo "=== thread raw around attachments section"
python3 - <<'PY'
h=open('/tmp/t1.html',errors='replace').read()
i=h.find('Thread + Internal Notes + Attachments')
print(h[i-200:i+800] if i>0 else 'no attachments tab')
PY
