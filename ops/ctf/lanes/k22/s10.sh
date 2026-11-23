set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
curl -sS -m 30 --cacert $CA -o /tmp/index.js -w 'index.js %{http_code} %{size_download}\n' $A/index.js
grep -oE '"/api/[a-zA-Z0-9/_:${}.-]+"' /tmp/index.js | sort -u | head -100
echo "===== agent strings ====="
grep -oE '.{60}agent-invocation.{80}' /tmp/index.js | head -5
grep -oE '.{60}stream-chat.{80}' /tmp/index.js | head -5
grep -oE '.{40}api/agent[^"]{0,60}' /tmp/index.js | head -20
echo "===== version ====="
curl -sS -m 10 --cacert $CA $A/api/setup-complete | python3 -c "import sys,json;d=json.load(sys.stdin);print({k:v for k,v in d.items() if k!='results'})" 2>/dev/null | head -c 1500
echo
grep -oE 'anythingllm[^"]{0,20}' /tmp/index.js | head -3
INNER
