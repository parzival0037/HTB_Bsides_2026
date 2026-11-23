#!/bin/bash
echo "== mozilla profiles"; ls -la ~/.mozilla/firefox/ 2>/dev/null; find ~/.mozilla -name places.sqlite 2>/dev/null
DB=$(find ~/.mozilla -name places.sqlite 2>/dev/null | head -1)
echo "DB=$DB"
if [ -n "$DB" ]; then
 python3 - "$DB" <<'PY'
import sqlite3,sys,shutil
shutil.copy(sys.argv[1],'/tmp/places.sqlite')
c=sqlite3.connect('/tmp/places.sqlite')
try:
    for u,t in c.execute("select url,title from moz_places order by last_visit_date desc limit 100"):
        print(u,'|',t)
except Exception as e: print('ERR',e)
PY
fi
echo "== downloads"; ls -la ~/Downloads ~/Desktop ~/Documents 2>/dev/null
echo "== desktop files"; find ~/Desktop ~/.local/share/applications -name "*.desktop" 2>/dev/null | head
echo "== firefox prefs hosts"; grep -rih "arwc\|cairn\|hmi\|fuxa" ~/.mozilla 2>/dev/null | head -20
echo "== chromium?"; ls ~/.config/chromium 2>/dev/null
