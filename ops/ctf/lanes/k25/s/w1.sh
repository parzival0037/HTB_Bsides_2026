CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
curl -sS $P --cacert $CA -m 25 -H "$A" "$B/.well-known/fieldkest-client" -o /tmp/wk.json -w '[%{http_code}]\n'
python3 - <<'PY'
import json
d=json.load(open('/tmp/wk.json'))
print(json.dumps(d,indent=1))
PY
