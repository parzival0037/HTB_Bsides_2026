#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
J=/tmp/kbjar; rm -f $J
C="curl -sS $P -k -m 20 -c $J -b $J"
$C -o /tmp/kbl https://workboard.keplerops.test/login
grep -oiE '<form[^>]*>|<input[^>]*>|<title>[^<]*' /tmp/kbl | head -20
TOK=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1)
echo "tok=$TOK"
$C -o /tmp/kbr -D /tmp/kbh -w 'post:%{http_code}\n' --data-urlencode "username=maya.ranscombe" --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" --data-urlencode "csrf_token=$TOK" "https://workboard.keplerops.test/?controller=AuthController&action=check"
grep -iE 'HTTP/|location:' /tmp/kbh | head
$C -o /tmp/kbd -w 'dash:%{http_code}\n' "https://workboard.keplerops.test/?controller=DashboardController&action=show"
grep -oiE 'href="[^"]{3,90}"' /tmp/kbd | sort -u | head -30
echo "--- projects"
$C -o /tmp/kbp -w 'proj:%{http_code}\n' "https://workboard.keplerops.test/?controller=ProjectController&action=index"
grep -oiE 'project_id=[0-9]+|>[A-Za-z][^<]{1,50}<' /tmp/kbp | sort -u | head -40
