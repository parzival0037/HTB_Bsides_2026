CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
CK=$(mktemp)
curl -sS $P --cacert $CA -m 25 -c $CK -o /tmp/k25-login.html "$B/scp/login.php"
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/k25-login.html | head -1 | sed 's/.*value="//;s/"//')
grep -oE '<input[^>]*name="[^"]*"[^>]*>' /tmp/k25-login.html | sed -E 's/.*name="([^"]+)".*/\1/' | sort -u
echo "--- login"
curl -sS $P --cacert $CA -m 25 -c $CK -b $CK -o /tmp/k25-loginpost.html -D /tmp/k25-loginhdr.txt \
  --data-urlencode "__CSRFToken__=$TOK" \
  --data-urlencode "do=scplogin" \
  --data-urlencode "username=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=$B/scp/tickets.php" \
  "$B/scp/login.php"
head -12 /tmp/k25-loginhdr.txt
echo "--- ticket page"
curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/k25-tk.html -w 'tickets:%{http_code}\n' "$B/scp/tickets.php"
grep -oE '<title>[^<]*</title>' /tmp/k25-tk.html
grep -oE 'tickets\.php\?id=[0-9]+' /tmp/k25-tk.html | sort -u | head -20
echo "$CK" > /tmp/k25-ck.path
