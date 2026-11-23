import subprocess, hashlib, base64, itertools
findings=["7.4.2","within-operating-limits","fieldkest.connector/v3","consume","consume(request)",
 "awaiting-measurements","callback-review-required","additional-samples-required",
 "fieldkest.rehearsal-result/v1","fieldkest.consumer-check-result/v1","@keplerops/fieldlink-connector",
 "7.4.2:within-operating-limits","184","17","arwc-connector-consumer@19f43d2","dac4e2ef698fe4311b6186664add17f3a3710e2275c4c16bfae334e9a6fb3ef0"]
records=["CRR-OG2","TEN-ARWC-047","CHK-7138E417672F","CHK-E7D1EB7FBF77","k05-1-check","k05-1",
 "CRR-OG2:TEN-ARWC-047","^7.4.0","@keplerops/fieldlink-connector"]
pairs=[]
for f in findings:
    for r in records:
        pairs.append(f+":"+r); pairs.append(r+":"+f)
# also single strings
singles=findings+records
hits=[]
def dec(p,extra):
    r=subprocess.run(["openssl","enc","-d","-aes-256-cbc","-pbkdf2","-pass","pass:"+p,"-in","enc/k05-1.bin"],capture_output=True)
    return r.returncode,r.stdout
for s in set(pairs+singles):
    p=hashlib.sha256(s.encode()).hexdigest()
    rc,out=dec(p,None)
    if rc==0 and b"FLAG{" in out:
        hits.append((s,out))
print(hits)
