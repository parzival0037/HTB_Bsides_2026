import subprocess, itertools, json, hashlib
ref="dac4e2ef698fe4311b6186664add17f3a3710e2275c4c16bfae334e9a6fb3ef0"
passes={
 "ref":ref,"dg1":"578e274e8ab7b54a0283559ea7d6dd2ffb92ecec4f8d45b8fde967e171c560d0",
 "dg2":"244b3683ea4e428f290624797884a3658de6b6f89a8ca1f6462d1574abd2a710",
 "pkg":"4374eaa8d76237949cd373c889fb778b8c67b00c88b51f9a359ef1c3b3ddbb50",
 "chk":"CHK-7138E417672F","chk2":"CHK-E7D1EB7FBF77","rev":"arwc-connector-consumer@19f43d2",
 "pkgname":"@keplerops/fieldlink-connector","tenant":"TEN-ARWC-047","asset":"CRR-OG2",
 "range":"^7.4.0","ver":"7.4.2","ch":"K05.1","schemac":"fieldkest.connector/v3",
 "schema":"fieldkest.consumer-check-result/v1",
}
# extra derived
base=dict(passes)
for k,v in base.items():
    passes[k+".sha256"]=hashlib.sha256(v.encode()).hexdigest()
    passes[k+".md5"]=hashlib.md5(v.encode()).hexdigest()
    passes[k+".b64"]=__import__("base64").b64encode(v.encode()).decode()
cphers=["aes-256-cbc","aes-128-cbc","aes-192-cbc"]
mds=["md5","sha256","sha512","sha1"]
hits=[]
for name,p in passes.items():
    for c in cphers:
        for md in mds:
            r=subprocess.run(["openssl","enc","-d","-"+c,"-md",md,"-pass","pass:"+p,"-in","enc/k05-1.bin"],capture_output=True)
            if r.returncode==0:
                out=r.stdout
                if b"FLAG{" in out or b"flag" in out.lower():
                    hits.append((name,c,md,out))
print("hits",hits)
