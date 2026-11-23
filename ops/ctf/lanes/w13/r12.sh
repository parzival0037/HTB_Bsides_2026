#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'bash -s' <<'RSH'
for dns in 10.77.50.10 127.0.0.11; do
 echo "===== DNS $dns"
 for n in arwc.test connector.arwc.test appointment.arwc.test appointments.arwc.test gate.arwc.test access.arwc.test checkin.arwc.test check-in.arwc.test portal.arwc.test roster.arwc.test inspection.arwc.test outlet.arwc.test site.arwc.test visitor.arwc.test booking.arwc.test schedule.arwc.test maintenance.arwc.test; do
   r=$(timeout 3 dig +short @$dns $n A 2>/dev/null | tr '\n' ' ')
   echo "$n -> ${r:-none}"
 done
 echo "--- AXFR"
 timeout 5 dig @$dns arwc.test AXFR 2>&1 | head -20
 echo "--- NS/SOA"
 timeout 3 dig +short @$dns arwc.test NS; timeout 3 dig +short @$dns arwc.test SOA
done
RSH
