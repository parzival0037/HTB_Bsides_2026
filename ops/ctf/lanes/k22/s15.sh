set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
W=https://staff.keplerops.test
cd /tmp; rm -f wb.txt
curl -sS -m 20 --cacert $CA -c wb.txt -b wb.txt -o /tmp/wl.html "$W/login"
TOK=$(grep -o 'name="_token" value="[^"]*"' /tmp/wl.html | head -1 | sed 's/.*value="//;s/"//')
echo "token found: ${#TOK}"
curl -sS -m 20 --cacert $CA -c wb.txt -b wb.txt -L -o /tmp/wpost.html -w 'loginpost %{http_code} %{url_effective} %{size_download}\n' \
  --data-urlencode "_token=$TOK" --data-urlencode 'username=maya.ranscombe' --data-urlencode 'password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk' "$W/login"
grep -oE '<title>[^<]*' /tmp/wpost.html | head -2
python3 - <<'PY'
import re,html
t=open('/tmp/wpost.html',encoding='utf8',errors='replace').read()
txt=re.sub(r'<script.*?</script>','',t,flags=re.S); txt=re.sub(r'<style.*?</style>','',txt,flags=re.S)
txt=html.unescape(re.sub(r'<[^>]+>',' ',txt)); print(re.sub(r'\s+',' ',txt)[:1500])
PY
echo "===== pages ====="
for p in / /hardware /licenses /assets /reviews /api/v1/hardware /api/v1/licenses; do echo "## $p"; curl -sS -m 15 --cacert $CA -b wb.txt -o /tmp/x.out -w '%{http_code} %{content_type} %{size_download}\n' "$W$p"; head -c 400 /tmp/x.out; echo; done
INNER
