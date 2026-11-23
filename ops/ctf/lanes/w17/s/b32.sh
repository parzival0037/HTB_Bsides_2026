#!/bin/bash
NAMES="plc hmi fuxa historian history ot ot-workstation otworkstation opcua opc opc-server postgres postgresql db timescaledb timescale influxdb influx grafana node-red nodered mqtt arwc crr cairn cairnreach cairn-reach reservoir scada plant gateway worker nginx redis fuxa-server fuxaweb crr-overview crr-og2 engineer engineering workbench otws otws1 admin portal app api web"
echo "== box DNS"
for n in $NAMES; do r=$(getent hosts $n 2>/dev/null | head -1); [ -n "$r" ] && echo "BOX $n => $r"; done
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'NAMES="plc hmi fuxa historian history ot ot-workstation otworkstation opcua opc opc-server postgres postgresql db timescaledb timescale influxdb influx grafana node-red nodered mqtt arwc crr cairn cairnreach cairn-reach reservoir scada plant gateway worker nginx redis fuxa-server fuxaweb crr-overview crr-og2 engineer engineering workbench otws otws1 admin portal app api web fieldkest-workbench"
for n in $NAMES; do r=$(getent hosts $n 2>/dev/null | head -1); [ -n "$r" ] && echo "ROWAN $n => $r"; done' 2>&1
