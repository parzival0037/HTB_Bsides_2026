#!/bin/bash
echo "== host header tests on 10.77.60.20 =="
for h in connector.arwc.test outlet.arwc.test gate.arwc.test checkin.arwc.test appointment.arwc.test appointments.arwc.test roster.arwc.test access.arwc.test inspection.arwc.test visitor.arwc.test site.arwc.test ops.arwc.test portal.arwc.test security.arwc.test reception.arwc.test arwc.test field.arwc.test crew.arwc.test maintenance.arwc.test booking.arwc.test; do
  r=$(curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -H "Host: $h" -o /tmp/hh.$$ -w '%{http_code}' https://10.77.60.20/ 2>/dev/null)
  echo "$h -> $r $(head -c 120 /tmp/hh.$$ | tr -d '\n')"
done
rm -f /tmp/hh.$$
echo "== tool check =="
which ffuf gobuster feroxbuster dirb curl jq 2>&1
echo "== wordlists =="
ls /usr/share/wordlists/ 2>/dev/null; ls /usr/share/seclists/Discovery/Web-Content/ 2>/dev/null | head
