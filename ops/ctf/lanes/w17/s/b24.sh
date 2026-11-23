#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'cd ~/repos/connector-archive/connector-archive 2>/dev/null || cd ~/repos/connector-archive
echo "== tree"; find . -maxdepth 5 -type f -printf "%s %p\n" | head -40
echo "== configs"; for f in config/*.conf; do echo "### $f"; cat "$f"; done
echo "== map"; cat maps/*.map
echo "== ENT"; cat internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo "== ENG note"; cat internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md
echo "== strings endpoints"; strings -n 6 bin/fieldlink-connector 2>/dev/null | grep -iE "http|/api|arwc|hmi|plc|opc|historian|4840|5432|1881" | head -60' 2>&1 | head -180
