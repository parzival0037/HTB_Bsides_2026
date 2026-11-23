#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'EOS'
echo "=== identity-access.md ==="; cat ~/work/identity-access.md
echo "=== local-helper.md ==="; cat ~/work/local-helper.md
echo "=== service-notes.md ==="; cat ~/work/service-notes.md
echo "=== platform-access.md ==="; cat ~/work/platform-access.md
echo "=== chromium history arwc ==="
python3 - <<'PY'
import sqlite3,shutil,os
p=os.path.expanduser('~/.config/chromium/Default/History')
shutil.copy(p,'/tmp/h')
c=sqlite3.connect('/tmp/h')
for r in c.execute("select datetime(last_visit_time/1000000-11644473600,'unixepoch'),url,title,visit_count from urls where url like '%arwc%' or title like '%ARWC%' or title like '%nspect%' or url like '%appoint%' or url like '%checkin%' or url like '%roster%' order by last_visit_time desc limit 80"):
    print(r)
PY
echo "=== connector-archive tree ==="
find ~/repos/connector-archive -maxdepth 4 | head -80
EOS
