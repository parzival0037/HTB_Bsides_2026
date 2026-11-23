set +e
ssh -o BatchMode=yes rowan-dev 'cd /tmp && python3 - <<PY
import json,urllib.request,ssl,subprocess
W="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
U="https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests"
ctx=ssl.create_default_context(cafile="/home/rowan/.local/share/keplerops/ca.crt")
def enroll(upn):
    body=json.dumps({"upn":upn}).encode()
    req=urllib.request.Request(U,body,{"Authorization":"Bearer "+W,"Content-Type":"application/json"})
    d=json.load(urllib.request.urlopen(req,context=ctx,timeout=20))
    open("/tmp/%s.crt"%upn.split("@")[0],"w").write(d["certificate_pem"])
    open("/tmp/%s.key"%upn.split("@")[0],"w").write(d["private_key_pem"])
    return d
for upn in ("maya.ranscombe@keplerops.test","evan.calderoux@keplerops.test","talia.mornac-review@keplerops.test"):
    d=enroll(upn); print(upn,"-> enrolled, flag:",d.get("flag"))
PY'
echo "=== archive handovers with maya cert ==="
ssh -o BatchMode=yes rowan-dev 'R=/home/rowan/.local/share/keplerops/ca.crt; for subj in maya.ranscombe evan.calderoux talia.mornac-review; do
  printf "%-22s " "$subj"
  curl -sS -m 12 --cacert $R --cert /tmp/$subj.crt --key /tmp/$subj.key -w " [%{http_code}] " \
    "https://staff.keplerops.test/api/archive/handovers/$subj@keplerops.test" | head -c 400; echo
done'
