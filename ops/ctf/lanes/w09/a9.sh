#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 10"
for u in indexer.keplerops.test workloads.keplerops.test data.keplerops.test staff.keplerops.test tickets.keplerops.test workboard.keplerops.test registry.keplerops.test preview.keplerops.test objects.keplerops.test cloud-api.keplerops.test identity.keplerops.test ca.keplerops.test cert.keplerops.test llm.keplerops.test support.keplerops.test delivery.keplerops.test packages.keplerops.test; do
  echo "##### $u"
  curl $P "https://$u/.well-known/fieldkest-client" -w '\n[%{http_code}]\n' | head -c 2500
  echo
done
echo DONE_A9
