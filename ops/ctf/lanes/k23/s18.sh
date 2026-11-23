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
  curl $K $P -b $CJ "$S/scp/tickets.php?id=$i" -o /tmp/t$i.html
done
python3 - <<'EOF'
import re,html,glob
for f in sorted(glob.glob('/tmp/t[0-9].html')):
    s=open(f,encoding='utf-8',errors='replace').read()
    title=re.findall(r'<title>([^<]*)',s)
    print("="*30,f,title)
    links=sorted(set(re.findall(r'[\w./]*file\.php[\w./?=&%#-]*',s)))
    print("LINKS:",links)
    # strip scripts/styles
    s2=re.sub(r'(?is)<(script|style).*?</\1>','',s)
    s2=re.sub(r'(?i)<br\s*/?>|</p>|</div>|</tr>|</h[1-6]>','\n',s2)
    txt=html.unescape(re.sub(r'(?s)<[^>]+>',' ',s2))
    lines=[re.sub(r'\s+',' ',l).strip() for l in txt.split('\n')]
    lines=[l for l in lines if l]
    kw=('FLAG','conversation','reference','assistant','document','ARWC','SUP-','ESC-','REV-','ctx-','tenant','customer','attach','conversation_id','thread','job','RPT-','CRR-')
    for l in lines:
        if any(k.lower() in l.lower() for k in kw):
            print(l[:600])
EOF
