#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 30"
B=https://support.keplerops.test
U="maya.ranscombe"; PW="sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"
J=/tmp/ostjar
rm -f $J
UA="Mozilla/5.0"
# login
curl -sS $P -A "$UA" -c $J -o /tmp/lg.html "$B/scp/login.php"
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/lg.html | head -1)
echo "csrf=$TOK"
curl -sS $P -A "$UA" -b $J -c $J -o /tmp/lr.html -w 'login %{http_code} %{redirect_url}\n' \
  -d "do=signin&__CSRFToken__=$TOK&username=$U&password=$PW&remember=1" "$B/scp/login.php"
echo "===== kb.php"
curl -sS $P -A "$UA" -b $J -w '\n[%{http_code}]\n' "$B/scp/kb.php" -o /tmp/kb.html
grep -oiP '<title>[^<]*|href="[^"]*kb[^"]*"' /tmp/kb.html | head -30
echo "===== kb categories"
curl -sS $P -A "$UA" -b $J -o /tmp/kbb.html "$B/scp/kb.php?cid=1"
grep -oiP '<title>[^<]*' /tmp/kbb.html
grep -oiP 'faq.php[^"]*|articles/[^"]*|Vale|Mira|starter|roster|activation|temporary' /tmp/kbb.html | sort -u | head -30
echo "===== dashboard"
curl -sS $P -A "$UA" -b $J -o /tmp/db.html "$B/scp/index.php"
grep -oiP '<title>[^<]*|Vale|Mira|starter|roster|activation|temporary' /tmp/db.html | sort -u | head -30
echo "===== admin kb"
curl -sS $P -A "$UA" -b $J -o /tmp/akb.html "$B/scp/kb.php?a=search&keywords=Vale"
grep -oiP '<title>[^<]*|Nothing found|Vale|Mira|starter' /tmp/akb.html | sort -u | head
