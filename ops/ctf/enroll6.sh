set +e
P="curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k"
W="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
U="https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests"
echo "=== full response keys for a plain upn request ==="
$P -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{"upn":"rowan.ito@keplerops.test"}' "$U" -o /tmp/enr.json
python3 -c "
import json;d=json.load(open('/tmp/enr.json'));print('keys:',list(d));print({k:(str(v)[:60]+'...') for k,v in d.items()})"
echo "=== CSR-based request ==="
ssh -o BatchMode=yes rowan-dev 'cd /tmp && rm -f k.key k.csr k.crt && openssl ecparam -name prime256v1 -genkey -noout -out k.key 2>/dev/null && openssl req -new -key k.key -subj "/CN=rowan.ito@keplerops.test" -out k.csr 2>/dev/null && echo CSR_OK && wc -c k.csr' 
ssh -o BatchMode=yes rowan-dev 'cd /tmp && python3 - <<PY
import json,urllib.request,ssl
csr=open("/tmp/k.csr").read()
body=json.dumps({"upn":"rowan.ito@keplerops.test","csr_pem":csr}).encode()
req=urllib.request.Request("https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests",body,
  {"Authorization":"Bearer fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9","Content-Type":"application/json"})
ctx=ssl.create_default_context(cafile="/home/rowan/.local/share/keplerops/ca.crt")
try:
    r=urllib.request.urlopen(req,context=ctx,timeout=20); d=json.load(r)
    print("keys:",list(d))
    for k in d:
        if k.endswith("_pem"): open("/tmp/k.out."+k,"w").write(d[k])
except Exception as e:
    print("ERR",e, getattr(e,"read",lambda:b"")()[:200])
PY'
