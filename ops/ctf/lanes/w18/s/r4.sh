#!/bin/bash
echo "=== box hosts"; cat /etc/hosts
echo "=== resolve tests"
for h in connector.arwc.test plant.arwc.test cairn.arwc.test cairnreach.arwc.test historian.arwc.test plc.arwc.test hmi.arwc.test scada.arwc.test opcua.arwc.test gateway.arwc.test io.arwc.test; do
  printf '%s -> ' "$h"; getent hosts "$h" || echo NO
done
echo "=== probe 60.20 ports via nc"
for p in 22 80 443 502 4840 8080 8443 1883 102 5432 9090 3000; do
  timeout 2 bash -c "echo > /dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "OPEN $p"
done
