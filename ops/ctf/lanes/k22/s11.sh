set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
echo "=== agent chat strings ==="
grep -oE '.{300}Swapping over to agent chat.{200}' /tmp/index.js | head -2
echo
echo "=== websocketUUID ==="
grep -oE '.{300}websocketUUID.{400}' /tmp/index.js | head -3
echo
echo "=== agent endpoints ==="
grep -oE '.{80}api/agent[^"`]{0,80}' /tmp/index.js | head -20
echo
echo "=== thread endpoints ==="
grep -oE '.{40}(thread/new|threads)[^"`]{0,60}' /tmp/index.js | sort -u | head -20
echo
echo "=== version strings ==="
grep -oE '"version":"[^"]{1,20}"' /tmp/index.js | sort -u | head
INNER
