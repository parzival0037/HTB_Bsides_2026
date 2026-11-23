set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
curl -sS -m 20 --cacert $CA "$A/index.js" -o /tmp/idx.js
ls -la /tmp/idx.js
echo "### routes containing workspace"
grep -oE '"/api/[a-zA-Z0-9:_/{}\.\$-]+"' /tmp/idx.js | sort -u | head -80
echo "### raw strings api"
grep -oE '/api/[a-zA-Z0-9:_/{}\.\$-]+' /tmp/idx.js | sort -u | head -120
echo "### agent tokens"
grep -oE '.{60}Swapping over to agent chat.{140}' /tmp/idx.js | head -3
INNER
echo DONE_MARK_$RANDOM
