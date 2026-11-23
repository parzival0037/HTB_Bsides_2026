#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
J=/tmp/ost; rm -f $J
C="curl -sS $P -k -m 25 -c $J -b $J -L"
$C -o /tmp/l.html "$B/scp/login.php"
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/l.html | head -1)
echo "token=$TOK"
$C -o /tmp/dash.html -w 'POST login final=%{url_effective} code=%{http_code} size=%{size_download}\n' \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=signin" \
  --data-urlencode "username=maya.ranscombe" \
  --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "remember=1" "$B/scp/login.php"
echo "--- dash title/errors"
grep -oiP '<title>[^<]*|invalid|incorrect|access denied|dashboard' /tmp/dash.html | sort -u | head
echo "--- cookie jar"; cat $J | grep -v '^#'
echo "--- scp index"
$C -o /tmp/idx.html -w 'index final=%{url_effective} code=%{http_code} size=%{size_download}\n' "$B/scp/index.php"
grep -oiP '<title>[^<]*|invalid|access denied|welcome|Signed in' /tmp/idx.html | sort -u | head
echo "--- tickets"
$C -o /tmp/tt.html -w 'tickets final=%{url_effective} code=%{http_code} size=%{size_download}\n' "$B/scp/tickets.php"
grep -oiP '<title>[^<]*' /tmp/tt.html | head
grep -oP 'tickets\.php\?id=\d+' /tmp/tt.html | sort -u | head -30
