#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'which dig nslookup host || pip3 install --quiet --user dnspython 2>/dev/null
echo ==AXFR
for z in arwc.test keplerops.test; do echo "-- $z"; dig +time=4 +tries=1 @10.77.50.10 AXFR $z 2>&1 | head -40; done
echo ==BRUTE
python3 - <<PY
import socket
names="""fuxa fuxa1 hmi hmi1 scada scada1 scada2 opc opcua opc-ua oua historian history hist db postgres postgresql pg pgadmin data plant plant1 site live iot plc control controls automation crr crr-og2 cairn cedar reservoir reservoir1 outlet outlets water arwc admin portal api web gateway edge node opcserver opc-server rt realtime telemetry view operator ops engineering eng docs reference documentation wiki grafana influx influxdb timescale timescaledb mqtt broker studio designer runtime server1 host1 app apps console dashboard dcs pas scada-hmi scadahmi opcuaserver ua fuxapro fuxa-pro cairnreach cairn-reach og2 crr-og2-plant relay proxy s7 modbus""".split()
ips={}
for n in names:
    for dom in ("arwc.test","keplerops.test"):
        h=n+"."+dom
        try:
            r=socket.gethostbyname_ex(h)
            print(h, r[2])
        except Exception: pass
PY' 2>&1
