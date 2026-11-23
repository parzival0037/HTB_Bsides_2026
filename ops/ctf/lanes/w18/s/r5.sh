#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
ssh $KO rowan@10.50.13.180 'for h in connector.arwc.test plant.arwc.test cairn.arwc.test cairnreach.arwc.test historian.arwc.test plc.arwc.test hmi.arwc.test scada.arwc.test opcua.arwc.test gateway.arwc.test io.arwc.test field.arwc.test data.arwc.test api.arwc.test portal.arwc.test relay.arwc.test source.arwc.test; do printf "%s -> " $h; getent hosts $h | head -1 || echo NO; done; echo "=== zone transfer attempt"; getent hosts arwc.test; python3 - <<PY
import socket
for h in ["connector.arwc.test","cairn.arwc.test","cairnreach.arwc.test","historian.arwc.test","plc.arwc.test","outlet.arwc.test","gate.arwc.test"]:
    try: print(h, socket.gethostbyname(h))
    except Exception as e: print(h,"ERR",e)
PY' 2>&1
