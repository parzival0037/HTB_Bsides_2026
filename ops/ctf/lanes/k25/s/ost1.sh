CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
J=/tmp/k25-ost.jar; rm -f $J
curl -sS $P --cacert $CA -m 25 -c $J -b $J -o /tmp/k25-login.html -w 'loginpage:%{http_code}\n' "$B/scp/login.php"
grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/k25-login.html | head -3
grep -oE '<form[^>]*>' /tmp/k25-login.html | head -3
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/k25-login.html | head -1 | sed 's/.*value="//;s/"//')
echo "TOK=$TOK"
curl -sS $P --cacert $CA -m 25 -c $J -b $J -o /tmp/k25-loginpost.html -w 'loginpost:%{http_code} redirect:%{redirect_url}\n' \
  --data-urlencode "username=maya.ranscombe" \
  --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "do=sign-in" \
  --data-urlencode "__CSRFToken__=$TOK" \
  --data-urlencode "dst=$B/scp/tickets.php" \
  -L "$B/scp/login.php"
echo "--- try SESSION cookie check"
curl -sS $P --cacert $CA -m 25 -b $J -o /tmp/k25-tk.html -w 'tickets:%{http_code}\n' "$B/scp/tickets.php"
head -c 500 /tmp/k25-tk.html
