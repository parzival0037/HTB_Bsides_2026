#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
R 'CA=/home/rowan/.local/share/keplerops/ca.crt
for h in connector.arwc.test arwc.test supply.arwc.test supplier.arwc.test procurement.arwc.test planning.arwc.test allocation.arwc.test finance.arwc.test portal.arwc.test hmi.arwc.test fuxa.arwc.test plc.arwc.test opcua.arwc.test historian.arwc.test meter.arwc.test water.arwc.test scada.arwc.test data.arwc.test api.arwc.test edge.arwc.test gw.arwc.test; do
  printf "%-28s " "$h"
  curl -sS --cacert $CA -m 5 --resolve "$h:443:10.77.60.20" -o /tmp/o -w '%{http_code} ' "https://$h/" 2>/tmp/e || { printf "ERR "; head -c 80 /tmp/e; }
  head -c 120 /tmp/o; echo
done'
