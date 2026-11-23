set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sSk -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("token",""))')
echo "TOKLEN=${#TOK}"
H="Authorization: Bearer $TOK"
for p in /api/config /api/contexts /api/conversations /api/selections /api/notes /api/support/context; do
  echo "######## $p"
  curl -sSk -m 10 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "$A$p" | head -c 4000; echo
done
echo "######## completion examples 1..5"
for i in 1 2 3 4 5; do
  echo "--- ex $i"
  curl -sSk -m 10 --cacert $CA -H "$H" -w '\n[%{http_code}]\n' "$A/api/completions/examples/$i" | head -c 1200; echo
done
echo "######## index.js custom api strings"
ls -la /tmp/idx.js 2>/dev/null
if [ -f /tmp/idx.js ]; then
  grep -oE '/api/[A-Za-z0-9_./{}$:-]+' /tmp/idx.js | sort -u | grep -viE 'workspace|admin|system|user|request-token|ping|setup|env|utils|browser|document' | head -80
  echo "--- any contexts/selections/completions/conversations mentions"
  grep -oE '.{60}(contexts|selections|completions|conversations).{100}' /tmp/idx.js | head -20
fi
INNER
echo DONE_R30
