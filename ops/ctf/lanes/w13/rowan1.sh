#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'EOS'
echo "== resolv/dns tests =="
for h in connector.arwc.test appointment.arwc.test appointments.arwc.test gate.arwc.test checkin.arwc.test inspection.arwc.test roster.arwc.test access.arwc.test outlet.arwc.test arwc.test booking.arwc.test visit.arwc.test water.arwc.test portal.arwc.test; do
  printf "%-32s " "$h"; getent hosts "$h" | head -1 || echo NO
done
echo "== grep arwc in home =="
grep -ril arwc ~ 2>/dev/null | grep -v node_modules | head -40
echo "== bash_history =="
tail -50 ~/.bash_history 2>/dev/null
echo "== work dirs =="
ls -la ~ ~/work 2>/dev/null | head -60
echo "== listening =="
ss -lntp 2>/dev/null | head -30
EOS
