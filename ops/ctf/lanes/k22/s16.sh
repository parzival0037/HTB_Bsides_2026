set +e
CA=/tmp/ca.crt
[ -s $CA ] || cp /home/kali/ctf/ca.crt $CA 2>/dev/null
[ -s $CA ] || CA=/home/kali/ctf/ca.crt
A=https://assistant.keplerops.test
TOK=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
C="Cookie: fieldkest_support=$TOK"
S="--socks5-hostname 127.0.0.1:1080"
echo "===== wellknown ====="
curl -sS -m 20 $S -k $A/.well-known/fieldkest-client; echo
echo "===== config ====="
curl -sS -m 30 $S -k $A/api/config; echo
echo "===== contexts ====="
curl -sS -m 30 $S -k $A/api/contexts; echo
echo "===== selection SEL-SUP-2841-12 ====="
curl -sS -m 30 $S -k -H "$C" $A/api/selections/SEL-SUP-2841-12; echo
echo "===== app.js head ====="
curl -sS -m 30 $S -k -o /tmp/app.js -w '%{http_code} %{size_download}\n' $A/static/app.js
wc -c /tmp/app.js
head -c 3000 /tmp/app.js
