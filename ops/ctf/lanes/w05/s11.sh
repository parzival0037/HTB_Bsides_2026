#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
UA="Mozilla/5.0"
SID=$(cat /tmp/ostsid)
C="curl -sS $P -k -m 25 -A $UA -H Cookie:OSTSESSID=$SID"
for id in 1 2 3 4 5; do
  $C -o /tmp/tk$id.html "$B/scp/tickets.php?id=$id"
done
python3 - <<'PY'
import re,html,glob
for id in "12345":
    fn=f"/tmp/tk{id}.html"
    try: s=open(fn,errors="replace").read()
    except: continue
    t=re.search(r'<title>(.*?)</title>',s,re.S)
    print("="*70); print("TICKET",id,html.unescape(t.group(1)).strip() if t else "?")
    # subject/header info
    for m in re.finditer(r'<div class="header"[^>]*>(.*?)</div>',s,re.S):
        x=re.sub(r'<[^>]+>',' ',m.group(1)); x=re.sub(r'\s+',' ',html.unescape(x)).strip()
        if x: print("HDR:",x[:200])
    # message bodies
    for m in re.finditer(r'<div class="thread-body"[^>]*>(.*?)</div>\s*</div>',s,re.S):
        x=re.sub(r'<[^>]+>',' ',m.group(1)); x=re.sub(r'\s+',' ',html.unescape(x)).strip()
        print("BODY:",x[:1500])
    # any text with keywords
    txt=re.sub(r'<script.*?</script>','',s,flags=re.S)
    txt=re.sub(r'<style.*?</style>','',txt,flags=re.S)
    txt=re.sub(r'<[^>]+>',' ',txt); txt=re.sub(r'\s+',' ',html.unescape(txt))
    for kw in ("Vale","starter","roster","onboard","temporary","Mira","activation","account","assignment"):
        i=txt.lower().find(kw.lower())
        if i>=0: print(f"  [{kw}] ...{txt[max(0,i-150):i+250]}...")
    print("ATTACH LINKS:")
    for m in re.finditer(r'(?:href|src)="([^"]*(?:file\.php|get\.php|attachment)[^"]*)"',s):
        print("  ",m.group(1)[:160])
PY
echo "=== list users?"
$C -o /tmp/u.html -w 'users %{http_code} %{size_download}\n' "$B/scp/staff.php"
grep -oiP '<title>[^<]*' /tmp/u.html
