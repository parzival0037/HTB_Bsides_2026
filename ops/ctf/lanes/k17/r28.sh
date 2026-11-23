set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
H=workboard; J=/tmp/jwb2.txt; rm -f $J
curl -sS -m 8 --cacert $CA -c $J "https://$H.keplerops.test/login" -o /tmp/lg.html
C=$(grep -oE 'name="csrf_token" value="[^"]+"' /tmp/lg.html | sed -E 's/.*value="([^"]+)".*/\1/')
curl -sS -m 8 --cacert $CA -b $J -c $J -X POST "https://$H.keplerops.test/login/check" \
  --data-urlencode "csrf_token=$C" --data-urlencode "username=rowan.ito" \
  --data-urlencode "password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" --data-urlencode "remember_me=1" -o /dev/null
for id in 1 2 3 4; do
 echo "######################## TASK $id"
 curl -sS -m 8 --cacert $CA -b $J -c $J "https://$H.keplerops.test/task/$id" -o /tmp/task.html -w 'HTTP %{http_code}\n'
 python3 - <<'PY'
import re,html
d=open('/tmp/task.html',errors='ignore').read()
d=re.sub(r'<script.*?</script>','',d,flags=re.S); d=re.sub(r'<style.*?</style>','',d,flags=re.S)
t=re.sub(r'<[^>]+>','\n',d); t=html.unescape(t)
t=re.sub(r'\n\s*\n+','\n',t)
print(t[:6000])
PY
done
INNER
