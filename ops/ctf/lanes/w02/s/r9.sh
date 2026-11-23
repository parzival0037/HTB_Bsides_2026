C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 25"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for r in connector-archive fieldlink-connector policy-compiler release-signer-history; do
 echo "##### $r"
 $C $A "https://source.keplerops.test/api/v1/repos/fieldkest/$r/git/trees/main?recursive=true" | python3 -c "import sys,json
try:
 d=json.load(sys.stdin)
 [print(t['type'],t['path']) for t in d.get('tree',[])]
except Exception as e: print('ERR',e)"
done
