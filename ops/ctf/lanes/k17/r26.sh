set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
login(){ H=$1; J=/tmp/j_$H.txt; rm -f $J
  curl -sS -m 8 --cacert $CA -c $J "https://$H.keplerops.test/login" -o /tmp/lg.html
  C=$(grep -oE 'name="csrf_token" value="[^"]+"' /tmp/lg.html | sed -E 's/.*value="([^"]+)".*/\1/')
  curl -sS -m 8 --cacert $CA -b $J -c $J -X POST "https://$H.keplerops.test/login/check" \
    --data-urlencode "csrf_token=$C" --data-urlencode "username=rowan.ito" \
    --data-urlencode "password=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" \
    --data-urlencode "remember_me=1" -o /dev/null
}
dump(){ H=$1; P=$2; J=/tmp/j_$H.txt
 echo "########## $H$P"
 curl -sS -m 8 --cacert $CA -b $J -c $J "https://$H.keplerops.test$P" -o /tmp/pg.html
 python3 - <<'PY'
import re,html
d=open('/tmp/pg.html',errors='ignore').read()
d2=re.sub(r'<script.*?</script>','',d,flags=re.S); d2=re.sub(r'<style.*?</style>','',d2,flags=re.S)
links=[(h,html.unescape(re.sub(r'<[^>]+>','',t)).strip()) for h,t in re.findall(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>',d2,flags=re.S)]
print('LINKS:','; '.join(f'{h}={t}' for h,t in links if t)[:3000])
t=re.sub(r'<[^>]+>',' ',d2); t=html.unescape(t); t=re.sub(r'\s+',' ',t)
print('TEXT:',t[:4000])
PY
}
login staff; login workboard
dump staff /dashboard
dump workboard /dashboard
INNER
