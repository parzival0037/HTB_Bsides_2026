#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
J=/tmp/ost; rm -f $J
C="curl -sS $P -k -m 20 -c $J -b $J"
USER=maya.ranscombe
PASS=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk
$C -o /tmp/l.html "$B/scp/login.php"
TOK=$(grep -oP 'name="__CSRFToken__" value="\K[^"]+' /tmp/l.html | head -1)
echo "csrf=$TOK"
$C -o /tmp/login_resp.html -L --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=signin" --data-urlencode "username=$USER" --data-urlencode "password=$PASS" --data-urlencode "remember=1" "$B/scp/login.php"
echo "login size $(stat -c%s /tmp/login_resp.html)"; grep -o "Invalid\|Dashboard\|My Profile" /tmp/login_resp.html | head -3
# ticket lists in several states
for q in "" "?status=open" "?status=closed" "?status=all" "?a=search&keywords=" "?a=search&keywords=a"; do
  fn=/tmp/t$(echo "$q" | tr -cd 'a-z').html
  $C -o $fn -w "[$q] %{http_code} %{size_download}\n" "$B/scp/tickets.php$q"
done
echo "=== unique ticket links"
cat /tmp/t*.html | grep -oP 'tickets\.php\?id=\d+' | sort -u
echo "=== task/other links"
cat /tmp/t*.html | grep -oP 'href="[^"]*(tasks|tickets)\.php[^"]*"' | sort -u | head -40
echo "=== ticket pages"
for id in $(cat /tmp/t*.html | grep -oP 'tickets\.php\?id=\K\d+' | sort -u); do
  $C -o /tmp/tk$id.html -w "ticket $id: %{http_code} %{size_download}\n" "$B/scp/tickets.php?id=$id"
  python3 - "$id" <<'PY'
import re,sys,html
id=sys.argv[1]
s=open(f"/tmp/tk{id}.html",errors="replace").read()
t=re.search(r'<title>(.*?)</title>',s,re.S)
print("TITLE:",html.unescape(t.group(1)).strip() if t else "?")
for m in re.finditer(r'href="([^"]*(?:file\.php|attachment)[^"]*)"[^>]*>(.*?)</a>',s,re.S):
    print("  ATT:",m.group(1),"::",re.sub(r'<[^>]+>','',m.group(2))[:80])
for kw in ("Vale","starter","roster","onboard","temporary","Mira"):
    for m in re.finditer(kw,s,re.I):
        print("  KW",kw,":",re.sub(r'<[^>]+>',' ',s[max(0,m.start()-120):m.start()+160]).replace("\n"," ")[:280]); break
PY
done
