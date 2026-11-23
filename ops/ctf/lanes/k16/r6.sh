#!/bin/bash
set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
E=https://objects.keplerops.test/fieldkest-workspaces
echo "###### LISTING"
curl -sS -m 10 --cacert $CA "$E?list-type=2&max-keys=1000" | sed 's/></>\n</g' | head -80
echo "###### NOTEBOOK LATEST"
curl -sS -m 10 --cacert $CA "$E/notebooks%2Fdeploy-2026-09.json"; echo
echo "###### NOTEBOOK VERSIONS"
curl -sS -m 10 --cacert $CA "$E?versions&max-keys=1000" | sed 's/></>\n</g' | head -60
echo "###### HANDOVER LATEST"
curl -sS -m 10 --cacert $CA "$E/exports%2FEXP-2841%2Fhandover.json"; echo
RSH
echo DONE_R6
