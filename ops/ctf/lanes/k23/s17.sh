#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 40"
S=https://support.keplerops.test
CJ=/tmp/cj.txt; rm -f $CJ
curl $K $P -c $CJ $S/scp/login.php -o /tmp/login.html
TOKEN=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/login.html | sed 's/.*value="//;s/"$//')
curl $K $P -b $CJ -c $CJ -X POST $S/scp/login.php --data-urlencode "__CSRFToken__=$TOKEN" \
  --data-urlencode "userid=maya.ranscombe" --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "do=scplogin" -o /dev/null
for i in 1 2 3 4 5; do
  echo "############ TICKET $i"
  curl $K $P -b $CJ "$S/scp/tickets.php?id=$i" -o /tmp/t$i.html -w "http %{http_code} size %{size_download}\n"
  python3 - "$i" <<'EOF'
import sys,re,html
i=sys.argv[1]
s=open(f'/tmp/t{i}.html',encoding='utf-8',errors='replace').read()
def clean(t): return html.unescape(re.sub(r'<[^>]+>',' ',t))
print("TITLE:", re.findall(r'<title>([^<]*)',s)[:1])
for m in re.finditer(r'(?:<h3[^>]*>|<div class="subject"[^>]*>)(.*?)</(?:h3|div)>',s,re.S):
    print("SUBJ:", clean(m.group(1)).strip()[:200])
print("ATTACH:", sorted(set(re.findall(r'(?:file|attachment)\.php[^"\'<> ]*',s)))[:10])
body=re.sub(r'<script.*?</script>','',s,flags=re.S)
body=re.sub(r'<style.*?</style>','',body,flags=re.S)
txt=clean(body)
txt=re.sub(r'\s+',' ',txt)
print("TEXT:", txt[:3000])
EOF
done
