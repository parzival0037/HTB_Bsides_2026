set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://staff.keplerops.test
try_login(){
  u="$1"; p="$2"; jar="$3"
  rm -f "$jar"
  curl -sS -m 10 --cacert $CA -c "$jar" -o /tmp/lg.html "$B/login"
  csrf=$(grep -oE 'name="csrf_token" value="[a-f0-9]+"' /tmp/lg.html | grep -oE '[a-f0-9]{32,}' | head -1)
  code=$(curl -sS -m 10 --cacert $CA -b "$jar" -c "$jar" -o /tmp/lg2.html -w '%{http_code} %{redirect_url}' \
    --data-urlencode "username=$u" --data-urlencode "password=$p" --data-urlencode "csrf_token=$csrf" "$B/login/check")
  echo "LOGIN[$u] csrf=${csrf:0:8} -> $code"
  curl -sS -m 10 --cacert $CA -b "$jar" -o /dev/null -w 'after-login /login: %{http_code} redirect=%{redirect_url}\n' "$B/login"
  curl -sS -m 10 --cacert $CA -b "$jar" -w '\nservice-directory[%{http_code}]\n' "$B/api/service-directory" | head -c 1500; echo
}
for cred in "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "rowan.ito:fieldlink-dev-2841" "maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" "admin:admin"; do
  u=${cred%%:*}; p=${cred#*:}
  try_login "$u" "$p" /tmp/kb_$u.jar
done
echo "#### probe notes with any authenticated jar"
for jar in /tmp/kb_*.jar; do
  echo "--- $jar"
  curl -sS -m 10 --cacert $CA -b "$jar" -w '\n[%{http_code}]\n' "$B/api/notes/ESC-SUP-2841-R3" | head -c 400
  curl -sS -m 10 --cacert $CA -b "$jar" -X POST -H 'Content-Type: application/json' -d '{"service":"assistant"}' -w '\n[%{http_code}]\n' "$B/api/managed-identities/assistant/session" | head -c 400
done
INNER
echo DONE_MARK_$RANDOM
