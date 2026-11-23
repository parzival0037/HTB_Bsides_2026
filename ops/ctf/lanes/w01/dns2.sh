#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/dns2.sh' <<'EOS'
#!/bin/bash
for d in keplerops.test arwc.test; do
 for h in www portal docs records water scada hmi plant opcua historian fuxa gate inspection inspections appointments appointment access checkin roster procurement purchasing planning cairn cairnreach outlet supply api app data files dms edms ecm register contracts suppliers customers field work ops control telemetry dashboard arwc admin intranet erp finance assets maintenance handover handovers supplier customer customer-portal selfservice; do
  ip=$(getent hosts "$h.$d" 2>/dev/null | awk '{print $1}' | head -1)
  [ -n "$ip" ] && echo "$h.$d -> $ip"
 done
done
echo "### wildcard"
getent hosts zzztest1.keplerops.test; echo "rc=$?"
getent hosts zzztest1.arwc.test; echo "rc=$?"
echo "### python resolve list"
python3 - <<'PY'
import socket
names=["arwc.test","portal.arwc.test","www.arwc.test","app.arwc.test","docs.arwc.test","records.arwc.test"]
for n in names:
    try: print(n, socket.gethostbyname_ex(n))
    except Exception as e: print(n, 'ERR', e)
PY
EOS
chmod +x /tmp/dns2.sh
$S 'bash /tmp/dns2.sh' 2>&1 | head -80
