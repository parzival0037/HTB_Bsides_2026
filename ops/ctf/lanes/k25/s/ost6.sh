CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
CK=/tmp/k25-ck.txt; rm -f $CK
curl -sS $P --cacert $CA -m 25 -c $CK -o /tmp/k25-login.html "$B/scp/login.php"
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/k25-login.html | head -1 | sed 's/.*value="//;s/"//')
curl -sS $P --cacert $CA -m 25 -c $CK -b $CK -o /tmp/k25-loginpost.html -D /tmp/k25-loginhdr.txt \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=scplogin" \
  --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=$B/scp/tickets.php" "$B/scp/login.php"
grep -iE 'HTTP/|location|set-cookie' /tmp/k25-loginhdr.txt
grep -oE '<title>[^<]*</title>|Authentication Required|Invalid|incorrect|banner' /tmp/k25-loginpost.html | head
echo "--- tickets"
curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/k25-tk.html -w 'tickets:%{http_code}\n' "$B/scp/tickets.php"
grep -oE '<title>[^<]*</title>' /tmp/k25-tk.html
grep -oE 'SUP-[0-9]+|ESC-[0-9]+|REV-[0-9]+' /tmp/k25-tk.html | sort -u | head -30
