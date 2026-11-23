#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
python3 - <<'PY'
import re
s=open('/tmp/al/index.js',encoding='utf-8',errors='replace').read()
pats=set()
for m in re.finditer(r'fetch\(`([^`]+)`', s):
    pats.add(m.group(1))
for p in sorted(pats):
    if 'document' in p or 'workspace' in p: print(p)
print('---- url helpers ----')
for m in re.finditer(r'`([^`]*\$\{C\}[^`]*)`', s):
    p=m.group(1)
    if 'document' in p or 'workspace' in p or 'thread' in p: print(p)
print('---- all literal /api routes ----')
for m in sorted(set(re.findall(r'["\'](/api/[A-Za-z0-9_./:${}-]+)["\']', s))): print(m)
PY
INNER
