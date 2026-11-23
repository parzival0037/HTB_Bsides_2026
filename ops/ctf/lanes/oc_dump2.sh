set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=15 rowan-dev 'python3 -' <<'PY'
import re
d=open('/tmp/ch.dump','rb').read()
print("len",len(d))
for s in re.findall(rb'[\x20-\x7e]{4,300}', d):
    print(s.decode('latin-1'))
PY
