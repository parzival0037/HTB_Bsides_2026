#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "###### gitea anon explore"
curl -sS $P -k -m 20 -o /tmp/ge -w '%{http_code}\n' "https://source.keplerops.test/explore/repos"
python3 - <<'PY'
import re,html
try:
 s=open('/tmp/ge',errors='replace').read()
except: s=''
for m in re.finditer(r'href="/([^"/]+/[^"/]+)"',s):
    print(m.group(1))
PY
echo "###### gitea search api anon"
curl -sS $P -k -m 20 -w ' [%{http_code}]' "https://source.keplerops.test/api/v1/repos/search?limit=100" | head -c 1500; echo
echo "###### gitea with basic"
curl -sS $P -k -m 20 -u "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" -w ' [%{http_code}]' "https://source.keplerops.test/api/v1/repos/search?limit=100" | head -c 800; echo
