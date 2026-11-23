set +e
echo "== odt =="
cd /tmp && rm -rf odt && mkdir odt && cd odt && unzip -o /home/rowan/work/analysis/field-notes-2026-08.odt >/dev/null 2>&1 && python3 -c "
import re,sys
d=open('content.xml',encoding='utf-8',errors='replace').read()
d=re.sub(r'<[^>]+>',' ',d)
print(re.sub(r'\s+',' ',d))
" 2>&1 | head -40
echo; echo "== grep workload/token in home =="
grep -rliE 'workload|token.exchange|workspace_token' /home/rowan --exclude-dir=.cache --exclude-dir=.kube/cache 2>/dev/null | head -40
echo "== chromium history =="
DB=/home/rowan/.config/chromium/Default
ls -la $DB 2>&1 | head
cp $DB/History /tmp/h.db 2>/dev/null
sqlite3 /tmp/h.db "select datetime(last_visit_time/1000000-11644473600,'unixepoch'),url,title from urls order by last_visit_time desc limit 60;" 2>&1 | head -70
echo "== chromium logins/cookies =="
cp $DB/Login\ Data /tmp/ld.db 2>/dev/null; sqlite3 /tmp/ld.db 'select origin_url,username_value,length(password_value) from logins;' 2>&1 | head -20
sqlite3 $DB/Cookies 'select host_key,name,length(encrypted_value),path from cookies;' 2>&1 | head -20
