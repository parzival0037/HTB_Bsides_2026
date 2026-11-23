#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
python3 - <<'PY'
import re
s=open('/tmp/al/index.js',encoding='utf-8',errors='replace').read()
for pat in ['new WebSocket','websocketUUID','/api/agent','ws://','wss://','agent/']:
    print('=====',pat)
    for m in list(re.finditer(re.escape(pat), s))[:6]:
        a=max(0,m.start()-400); b=min(len(s),m.end()+400)
        print(repr(s[a:b])); print('---')
PY
INNER
