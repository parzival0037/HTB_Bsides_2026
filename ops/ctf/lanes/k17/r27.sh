set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
H=workboard; J=/tmp/jwb.txt; rm -f $J
curl -sS -m 8 --cacert $CA -c $J "https://$H.keplerops.test/login" -o /tmp/lg.html
C=$(grep -oE 'name="csrf_token" value="[^"]+"' /tmp/lg.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 8 --cacert $CA -b $J -c $J -X POST "https://$H.keplerops.test/login/check" \
  --data-urlencode "csrf_token=$C" --data-urlencode "username=rowan.ito" \
  --data-urlencode "password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" --data-urlencode "remember_me=1" -o /dev/null
get(){ echo "########## $1"; curl -sS -m 8 --cacert $CA -b $J -c $J "https://$H.keplerops.test$1" -o /tmp/pg.html -w 'HTTP %{http_code}\n'; }
for p in /projects /board/1 /list/1 /project/1/activity /my-activity /users "/search?search=Cinder" "/?controller=SearchController&action=index&search=Cinder" "/?controller=SearchController&action=index&search=reviewer"; do get "$p"; done
echo "=========== TEXT DUMP SELECTED ==========="
for p in /projects /list/1 /project/1/activity /users "/search?search=Cinder"; do echo "##### $p"; curl -sS -m 8 --cacert $CA -b $J -c $J "https://$H.keplerops.test$p" -o /tmp/pg.html; python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
links=[(h,html.unescape(re.sub(r'<[^>]+>','',t)).strip()) for h,t in re.findall(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>',d,flags=re.S)]
print('LINKS:','; '.join(f'{h}={t}' for h,t in links if t)[:2000])
t=re.sub(r'<[^>]+>',' ',d); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print('TEXT:',t[:2500])
PY
done
INNER
