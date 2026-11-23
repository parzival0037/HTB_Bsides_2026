#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
python3 - <<'PY'
import re
s=open('/tmp/al/index.js',encoding='utf-8',errors='replace').read()
for m in re.finditer(r'.{300}workspace/search.{500}', s, re.S):
    print(repr(m.group(0))[:1600]); print('-----')
PY
INNER
