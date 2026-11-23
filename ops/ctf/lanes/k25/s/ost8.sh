CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test; CK=/tmp/k25-ck.txt
for i in 1 2 3 4 5; do
  curl -sS $P --cacert $CA -m 25 -b $CK -o /tmp/k25-t$i.html "$B/scp/tickets.php?id=$i"
done
python3 - <<'PY'
import re,glob
for i in range(1,6):
    h=open(f'/tmp/k25-t{i}.html',errors='replace').read()
    # ticket header/number
    num=re.search(r'(SUP|ESC|REV)-\d+',h)
    print('='*30, i, num.group(0) if num else '?')
    # attachments / file links
    for m in re.finditer(r'(?:href|src)="([^"]*(?:file|attach|download)[^"]*)"',h,re.I):
        print(' LINK:',m.group(1)[:200])
    # thread entries text
    body=re.sub(r'<script.*?</script>',' ',h,flags=re.S)
    body=re.sub(r'<style.*?</style>',' ',body,flags=re.S)
    # only inner thread area
    txt=re.sub(r'<[^>]+>','\n',body)
    txt=re.sub(r'\n\s*\n+','\n',txt)
    lines=[l.strip() for l in txt.split('\n') if l.strip()]
    print('\n'.join(lines[:120]))
PY
