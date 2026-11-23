#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== opt workbench tree"
find /opt -maxdepth 4 -printf "%M %u %g %s %p\n" 2>/dev/null | head -80
echo "===== workbench.py head"
head -c 4000 /opt/fieldkest-workbench/workbench.py 2>&1
echo; echo "===== 8701 route probe"
for p in /api/inspection-summary /api/report /api/reports /api/districts /api/planning /api/assistant /api/answers /api/config /api/contexts /api/selections /api/sources /health /status; do
  for m in GET POST; do
    code=$(curl -sS -o /tmp/x.$$ -w '%{http_code}' -m 5 -X $m -H 'Content-Type: application/json' -d '{}' "http://127.0.0.1:8701$p")
    echo "$m $p -> $code $(head -c 100 /tmp/x.$$ | tr -d '\n')"
  done
done
rm -f /tmp/x.$$
echo "===== 3350 probe"
python3 - <<'PY'
import socket
s=socket.socket(); s.settimeout(3)
try:
    s.connect(("127.0.0.1",3350)); s.sendall(b"HTTP/1.0 GET / HTTP/1.0\r\n\r\n")
    print(repr(s.recv(300)))
except Exception as e: print("ERR",e)
PY
echo "===== tmp leftovers from other lanes?"
ls -la /tmp | head -40
INNER
