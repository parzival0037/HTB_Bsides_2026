#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
echo "=== resolv ==="; cat /etc/resolv.conf
echo "=== hosts arwc ==="; grep -i arwc /etc/hosts
echo "=== dig ==="
for n in arwc.test connector.arwc.test; do echo "-- $n"; dig +short $n 2>&1; done
echo "=== cert ==="
echo | timeout 10 openssl s_client -connect connector.arwc.test:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>&1
echo "=== candidate vhosts ==="
for h in arwc.test connector appointment appointments gate checkin check-in roster access inspection inspect outlet maint maintenance booking schedule visit visitor reception portal ops api www dev staging admin; do
  name=$h.arwc.test
  [ "$h" = "arwc.test" ] && name=arwc.test
  ip=$(getent hosts $name | awk '{print $1}' | head -1)
  code=$(curl -sS -m 6 -o /tmp/b.$$ -w '%{http_code}' -k --resolve $name:443:10.77.60.20 https://$name/ 2>/dev/null)
  echo "$name dns=${ip:-none} code=$code body=$(head -c 120 /tmp/b.$$ | tr -d '\n')"
done
echo "=== port scan 10.77.60.20 ==="
for p in 80 443 3000 5000 8000 8080 8081 8082 8083 8443 9090 9443 22 5432 6379; do
  timeout 3 bash -c "echo > /dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "OPEN $p"
done
echo "=== https connector root verbose ==="
curl -sS -m 8 -k -D- https://connector.arwc.test/ 2>&1 | head -20
INNER
