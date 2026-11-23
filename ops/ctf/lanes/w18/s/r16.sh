#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 15"
for h in workloads.keplerops.test objects.keplerops.test tickets.keplerops.test assistant.keplerops.test staff.keplerops.test data.keplerops.test ca.keplerops.test id.keplerops.test identity.keplerops.test support.keplerops.test llm.keplerops.test cert.keplerops.test cloud-api.keplerops.test workboard.keplerops.test review.keplerops.test indexer.keplerops.test delivery.keplerops.test:8443 source-tools.keplerops.test:8443 source.keplerops.test ci.keplerops.test preview.keplerops.test packages.keplerops.test; do
  echo "########## $h"
  curl $P "https://$h/.well-known/fieldkest-client" | head -c 3000
  echo
done
