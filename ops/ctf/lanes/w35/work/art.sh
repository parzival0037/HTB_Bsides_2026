#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
echo "=== archive README ==="; R 'cat ~/repos/connector-archive/connector-archive/README.md'
echo "=== notes ==="; R 'cat ~/repos/connector-archive/connector-archive/notes/*.md'
echo "=== configs ==="; R 'cat ~/repos/connector-archive/connector-archive/config/*.conf'
echo "=== bin ==="; R 'file ~/repos/connector-archive/connector-archive/bin/fieldlink-connector; head -c 500 ~/repos/connector-archive/connector-archive/bin/fieldlink-connector | strings'
echo "=== chromium history arwc ==="; R 'python3 - <<PYEOF
import sqlite3,shutil
shutil.copy("/home/rowan/.config/chromium/Default/History","/tmp/Hist")
c=sqlite3.connect("/tmp/Hist")
for u,t in c.execute("select url,title from urls where url like \"%arwc%\" or title like \"%ARWC%\" order by last_visit_time desc limit 100"):
    print(t,"|",u)
PYEOF'
echo "=== zip files ==="; R 'for z in ~/repos/*.zip; do echo "-- $z"; unzip -l "$z" | head -20; done'
