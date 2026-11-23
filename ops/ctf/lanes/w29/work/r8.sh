#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S bash -s <<'REMOTE'
set +e
echo "== service-notes.md"; cat ~/work/service-notes.md
echo "== identity-access.md"; cat ~/work/identity-access.md
echo "== registry README"; cat ~/work/registry/README.md
echo "== chromium urls"; python3 - <<'PY'
import sqlite3,glob
for p in glob.glob('/home/rowan/.config/chromium/*/History'):
    print('##',p)
    try:
        c=sqlite3.connect(p)
        for u,t,n in c.execute("select url,title,last_visit_time from urls order by last_visit_time desc limit 80"):
            print(u,'|',t)
    except Exception as e: print(e)
PY
echo DONE_R8
REMOTE
