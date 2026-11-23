set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
curl -sS -m 20 --cacert $CA "$A/static/app.js" -o /tmp/app.js -w 'code:%{http_code} size:%{size_download}\n'
echo "######## app.js"
cat /tmp/app.js
INNER
echo DONE_MARK_$RANDOM
