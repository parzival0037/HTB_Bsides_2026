#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
g(){ echo "===== $1"; curl -sS $P -k -m 15 -i "$1" | head -c 1500; echo; }
for h in id.keplerops.test identity.keplerops.test data.keplerops.test workboard.keplerops.test ca.keplerops.test cert.keplerops.test; do
  g "https://$h/.well-known/fieldkest-client"
done
echo "######## staff directory"; g https://staff.keplerops.test/api/service-directory
echo "######## enrollment"; g https://staff.keplerops.test/api/enrollment
echo "######## objects handover"; g https://objects.keplerops.test/fieldkest-workspaces/exports/EXP-2841/handover.json
echo "######## objects notebook"; g https://objects.keplerops.test/fieldkest-workspaces/notebooks/deploy-2026-09.json
echo "######## connector receipt"; g https://connector.arwc.test/api/fieldlink/packages/7.4.2/receipt
