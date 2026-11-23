#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
SUP="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
C=https://connector.arwc.test
probe(){ echo "### $1 $2"; curl $P -X "$1" -o /tmp/o -w '[%{http_code}] ' "$C$2" ${3:-} ; head -c 500 /tmp/o; echo; }
probe POST /api/fieldlink/packages/poll
probe POST /api/fieldlink/packages/poll "-u $A"
probe POST /api/fieldlink/packages/poll "-H Authorization:Bearer\ $SUP"
for v in 7.4.2 6.9.8 7.4.0 7.3.1; do probe GET /api/fieldlink/packages/$v/receipt; probe GET /api/fieldlink/packages/$v/receipt "-u $A"; done
probe POST /api/fieldlink/rehearsals/rollback
probe POST /api/fieldlink/packages/7.4.2/activate
probe GET /api/fieldlink/packages
probe GET /api/fieldlink
probe GET /api/fieldlink/handovers
probe GET /api/handovers
probe GET /api/customer
probe GET /api/tenant
probe GET /api/records
probe GET /api/observations
probe GET /api/process-data
probe GET /api/process
probe GET /api/tags
probe GET /api/points
probe GET /api/historian
probe GET /api/ot
probe GET /api/ot/tags
probe GET /api/outlets
probe GET /api/gates
probe GET /api/registers
probe GET /api/native
probe GET /api/export
probe GET /api/catalog
probe GET /api/v1/tags
probe GET /api/v1/points
probe GET /api/v1/health
probe GET /healthz
probe GET /status
probe GET /version
probe GET /api/version
probe GET /api/controller
probe GET /api/plc
probe GET /api/opcua
probe GET /api/mode
probe GET /api/reservoir
probe GET /api/level
