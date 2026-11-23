#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'cd ~/repos/connector-archive/connector-archive
echo "== ENT"; cat internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo; echo "== ENG note"; cat internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md
echo "== strings interesting"; strings -n 5 bin/fieldlink-connector | grep -iE "arwc|hmi|plc|opc|historian|4840|5432|1881|/api|\.test|crr|flow|position|permissive|automode" | head -80' 2>&1 | tail -120
