#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'cd ~/repos/connector-archive/connector-archive
for f in README.md notes/retained-diagnostic.md config/diagnostic.conf config/ordinary.conf maps/fieldlink-connector-6.9.8.map; do echo "===== $f"; cat "$f"; done
echo "===== ENT"; cat internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json | head -60' 2>&1 | head -150
