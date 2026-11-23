#!/bin/bash
echo "===== cinder bash_history"; cat ~/.bash_history 2>/dev/null
echo "===== .config dirs"; ls -la ~/.config 2>/dev/null
echo "===== Desktop/Documents/Downloads"; ls -laR ~/Desktop ~/Documents ~/Downloads 2>/dev/null | head -60
echo "===== .mozilla"; ls -laR ~/.mozilla 2>/dev/null | head -40
echo "===== ff profiles prefs"; for f in ~/.mozilla/firefox/*/prefs.js; do echo "## $f"; grep -Ei 'proxy|network|arwc|fuxa|cairn|kepler' "$f" 2>/dev/null | head -40; done
echo "===== places/history arwc"; for db in ~/.mozilla/firefox/*/places.sqlite; do echo "## $db"; cp "$db" /tmp/places.db 2>/dev/null && python3 - <<'PY'
import sqlite3
try:
    c=sqlite3.connect('/tmp/places.db')
    for r in c.execute("select url,title from moz_places where url like '%arwc%' or url like '%fuxa%' or url like '%cairn%' or url like '%kepler%' limit 50"):
        print(r)
except Exception as e: print('ERR',e)
PY
done
echo "===== cookies db"; for db in ~/.mozilla/firefox/*/cookies.sqlite; do echo "## $db"; cp "$db" /tmp/cookies.db 2>/dev/null && python3 - <<'PY'
import sqlite3
try:
    c=sqlite3.connect('/tmp/cookies.db')
    for r in c.execute("select host,name,value from moz_cookies where host like '%arwc%' or host like '%kepler%' or host like '%fuxa%' limit 40"):
        print(r)
except Exception as e: print('ERR',e)
PY
done
echo "===== login/logins.json"; ls ~/.mozilla/firefox/*/logins.json 2>/dev/null
echo "===== .java"; find ~/.java -maxdepth 4 2>/dev/null | head -30
echo "===== grep arwc/fuxa in home"; timeout 60 grep -rilE 'arwc|fuxa|cairn|opc\.tcp' ~/.config ~/.local ~/Desktop ~/Documents ~/Downloads 2>/dev/null | head -30
echo "===== route"; cat /proc/net/route
echo "===== hosts"; cat /etc/hosts
echo "===== resolv"; cat /etc/resolv.conf
