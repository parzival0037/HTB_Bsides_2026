#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
python3 - <<'PY'
import re
s=open('/tmp/al/index.js',encoding='utf-8',errors='replace').read()
for pat in ['WebSocket','websocket','Websocket','socket']:
    print('=====',pat, len(re.findall(pat,s)))
    for m in list(re.finditer(pat, s))[:10]:
        a=max(0,m.start()-350); b=min(len(s),m.end()+350)
        t=s[a:b]
        if 'WebSocket' in t or 'ws' in t.lower():
            print(repr(t)); print('---')
PY
INNER
