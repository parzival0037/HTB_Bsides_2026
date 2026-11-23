CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://delivery.keplerops.test:8443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
curl -sS $P --cacert $CA -m 25 -u "$U" -o /tmp/pm.json "$B/api/package-meta/fieldlink-connector"
python3 - <<'PY'
import json
d=json.load(open('/tmp/pm.json'))
print('TOP',list(d))
for v,meta in d.get('versions',{}).items():
    print('--- version',v)
    for k in meta:
        if k in ('readme',): continue
        print('   ',k,'=',json.dumps(meta[k])[:600])
PY
echo "=== private metadata support-rehearsal"
curl -sS $P --cacert $CA -m 25 -u "$U" -w '\n[%{http_code}]\n' "https://packages.keplerops.test/@keplerops%2fsupport-rehearsal" | head -c 3000
echo
echo "=== packages registry root listing (basic)"
curl -sS $P --cacert $CA -m 25 -u "$U" -w '\n[%{http_code}]\n' "https://packages.keplerops.test/" | head -c 800
