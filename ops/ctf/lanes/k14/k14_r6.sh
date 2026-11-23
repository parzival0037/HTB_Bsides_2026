set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
echo "=== SUDO? ==="
sudo -n id 2>&1 | head -3
echo "=== 3350 listener proc ==="
sudo -n ss -lntp 2>/dev/null | grep 3350
sudo -n lsof -nP -iTCP:3350 -sTCP:LISTEN 2>/dev/null | head
echo "=== CURL 3350 ==="
for u in http://127.0.0.1:3350/ https://127.0.0.1:3350/ https://localhost:3350/ http://localhost:3350/; do
 echo "--- $u"; curl -sSk -m 5 -i "$u" | head -c 800; echo
done
echo "=== PATHS on 3350 (https) ==="
for p in latest latest/meta-data latest/meta-data/iam latest/meta-data/identity api api/trust api/trust-records api/trust-records/TR-1 .well-known/openid-configuration .well-known/fieldkest-client healthz identity workloads workload-token token trust; do
 for sch in https http; do
  code=$(curl -sSk -m 4 -o /tmp/p -w '%{http_code}' "$sch://127.0.0.1:3350/$p")
  if [ "$code" != "000" ]; then echo "-- $sch/$p -> $code :: $(head -c 200 /tmp/p | tr '\n' ' ')"; fi
 done
done
echo "=== SYSTEMD UNITS ==="
systemctl list-units --type=service --no-pager 2>/dev/null | head -40
sudo -n systemctl list-units --type=service --no-pager 2>/dev/null | head -40
echo "=== PROCESSES ==="
ps auxww 2>/dev/null | head -40
RSH
echo DONE_K14_R6
