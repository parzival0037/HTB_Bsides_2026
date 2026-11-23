set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
echo "===== request-token full ====="
curl -sSk -m 10 --cacert $CA -i -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | head -40
echo; echo "===== root headers ====="
curl -sSk -m 10 --cacert $CA -i "$A/" | head -25
echo "===== auth probes ====="
for p in /api/session /api/login /api/auth /api/request-session /api/token /api/verify /api/me /api/user; do
  for m in GET POST; do
    echo "--- $m $p"
    if [ "$m" = POST ]; then
      curl -sSk -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' -w '\n[%{http_code}] cookies=%{http_code}\n' "$A$p" | head -c 1200
    else
      curl -sSk -m 10 --cacert $CA -w '\n[%{http_code}]\n' "$A$p" | head -c 800
    fi
    echo
  done
done
INNER
echo DONE_R32
