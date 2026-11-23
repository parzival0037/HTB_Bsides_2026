set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cat work/service-notes.md; echo "=== IDENT ==="; cat work/identity-access.md; echo "=== PLATFORM ==="; cat work/platform-access.md; echo "=== HELPER ==="; cat work/local-helper.md'
run 'ls -la .config/chromium/Default/ | head -60; echo "=== HISTORY ==="; which sqlite3 || sudo -n apt-get install -y sqlite3 >/dev/null 2>&1; sqlite3 .config/chromium/Default/History "select datetime(last_visit_time/1000000-11644473600,\"unixepoch\"),title,url from urls order by last_visit_time desc limit 60;" 2>&1'
run 'sqlite3 .config/chromium/Default/Cookies ".schema cookies" 2>&1; echo "=== COOKIES ==="; sqlite3 .config/chromium/Default/Cookies "select host_key,name,length(encrypted_value),hex(encrypted_value),path,expires_utc from cookies;" 2>&1'
run 'ls -la .config/chromium/Default/Local\ State 2>&1; cat .config/chromium/Default/Local\ State 2>/dev/null | head -c 2000; echo; echo "=== support portal dns/tls ==="; getent hosts support.keplerops.test; curl -sS -m 8 -k -i https://support.keplerops.test/ 2>&1 | head -40'
