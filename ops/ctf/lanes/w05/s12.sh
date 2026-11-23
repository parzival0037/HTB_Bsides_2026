#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
UA="Mozilla/5.0"; SID=$(cat /tmp/ostsid)
C="curl -sS $P -k -m 25 -A $UA -H Cookie:OSTSESSID=$SID"
for id in 1 5; do $C -o /tmp/full$id.html "$B/scp/tickets.php?id=$id"; done
python3 - <<'PY'
import re,html
for id in ("1","5"):
    s=open(f"/tmp/full{id}.html",errors="replace").read()
    s=re.sub(r'<script.*?</script>','',s,flags=re.S)
    s=re.sub(r'<style.*?</style>','',s,flags=re.S)
    s=re.sub(r'<(br|/p|/div|/td|/tr|/li)[^>]*>','\n',s)
    s=re.sub(r'<[^>]+>',' ',s)
    s=html.unescape(s)
    lines=[re.sub(r'[ \t]+',' ',l).strip() for l in s.splitlines()]
    out=[]; prev=""
    for l in lines:
        if l and l!=prev and not l.startswith(("Create Ticket","Edit","Post Reply","Post Internal Note","Create Task")):
            out.append(l); prev=l
    # filter nav noise
    txt="\n".join(out)
    i=txt.find("posted")
    print("="*70); print("TICKET",id); print(txt[max(0,i-800):i+4000])
PY
