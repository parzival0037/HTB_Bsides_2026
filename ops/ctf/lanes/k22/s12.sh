set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
echo "=== new WebSocket ==="
grep -oE '.{250}new WebSocket.{350}' /tmp/index.js | head -5
echo
echo "=== ws:// ==="
grep -oE '.{150}ws://.{250}' /tmp/index.js | head -3
grep -oE '.{150}wss://.{250}' /tmp/index.js | head -3
echo
echo "=== api template strings ==="
grep -oE '"[^"]{0,40}\$\{C\}[^"]{0,80}"' /tmp/index.js | sort -u | head -80
echo
echo "=== backtick api ==="
grep -oE '`[^`]{0,50}\$\{C\}[^`]{0,90}`' /tmp/index.js | sort -u | head -80
INNER
