CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
echo "=== gitea repos"
curl -sS $P --cacert $CA -m 25 -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' 'https://source.keplerops.test/api/v1/user/repos?limit=50' | jq -r '.[] | [.full_name,.description,.default_branch] | @tsv' 2>&1 | head -40
echo "=== chromium cookie"
ssh rowan-dev 'sqlite3 /tmp/chr/Cookies "select host_key,name,value,hex(encrypted_value),expires_utc from cookies;" 2>&1'
