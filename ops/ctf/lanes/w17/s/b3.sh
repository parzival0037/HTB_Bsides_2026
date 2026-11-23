#!/bin/bash
echo "== resolv"; cat /etc/resolv.conf; echo; cat /etc/nsswitch.conf | grep hosts
echo "== getent"; for h in hmi.arwc.test plc crr arwc.test historian ot-workstation ot.workstation cairn; do echo "$h => $(getent hosts $h|head -1)"; done
echo "== dns python"
python3 - <<'PY'
import socket
for h in ["hmi.arwc.test","plc","arwc.test","hmi","historian","ot-workstation","localhost"]:
    try: print(h, socket.getaddrinfo(h,None))
    except Exception as e: print(h,"ERR",e)
PY
echo "== vhost probes"
for ip in 10.77.50.11 10.77.60.20 10.77.50.20; do
 for port in 443 80 8443; do
  for h in hmi.arwc.test fuxa.arwc.test; do
   out=$(curl -sS -m 6 -k --resolve $h:$port:$ip -o /tmp/v -w "%{http_code}" "https://$h:$port/" 2>/dev/null)
   echo "$h $ip:$port -> $out $(head -c 100 /tmp/v|tr -d '\n')"
  done
 done
done
echo "== ports on 10.77.60.x for hmi"
for i in $(seq 1 40); do (timeout 1 bash -c "echo >/dev/tcp/10.77.60.$i/1881" 2>/dev/null && echo "1881 open 10.77.60.$i") & done; wait
