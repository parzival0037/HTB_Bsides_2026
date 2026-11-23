set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
T="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "===== handover.current ====="
curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $T" -o /tmp/h.json -w '%{http_code} %{content_type}\n' "https://support.keplerops.test:8443/api/handovers/current"
head -c 3000 /tmp/h.json; echo
echo "===== setup-complete ====="
curl -sS -m 10 --cacert $CA -o /tmp/sc.json -w '%{http_code}\n' https://assistant.keplerops.test/api/setup-complete
python3 -c "
import json;d=json.load(open('/tmp/sc.json'))
r=d.get('results',d)
for k,v in r.items():
  s=json.dumps(v) if not isinstance(v,str) else v
  if len(s)<200: print(k,'=',s)
" 2>&1 | head -80
echo "===== osticket login ====="
python3 - <<'PY'
import requests, re, sys
requests.packages.urllib3.disable_warnings()
s=requests.Session(); s.verify=False
base='https://support.keplerops.test'
r=s.get(base+'/scp/login.php',timeout=15)
print('login page',r.status_code,r.url)
m=re.search(r'name="__CSRFToken__" value="([^"]+)"',r.text)
print('csrf',bool(m))
data={'__CSRFToken__':m.group(1) if m else '','do':'scplogin','userid':'maya.ranscombe','passwd':'sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'}
r=s.post(base+'/scp/login.php',data=data,timeout=15,allow_redirects=True)
print('post',r.status_code,r.url,len(r.text))
open('/tmp/login.html','w').write(r.text)
print(r.text[:600])
PY
INNER
