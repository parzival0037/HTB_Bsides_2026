#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== relay script + s5.py"
$SSH 'ls -la /tmp/*.py /tmp/*.sh 2>&1; echo ---; cat /tmp/s5.py 2>&1; echo ---; cat /tmp/relay.sh 2>&1; cat /tmp/fwd.sh 2>&1'
echo "===== dns candidates"
$SSH 'for n in report.arwc.test reports.arwc.test assistant.arwc.test docs.arwc.test planning.arwc.test plans.arwc.test retrieval.arwc.test linked.arwc.test library.arwc.test districts.arwc.test district.arwc.test cedar-run.arwc.test cedar.arwc.test riverbend.arwc.test northquay.arwc.test marshgate.arwc.test portal.arwc.test app.arwc.test api.arwc.test docs.keplerops.test documents.keplerops.test knowledge.keplerops.test report.keplerops.test; do printf "%-32s " $n; getent hosts $n | awk "{print \$1}" | tr "\n" " "; echo; done'
echo "===== work tree"
$SSH 'find /home/rowan/work -maxdepth 2 | sort; echo ---; ls -la /home/rowan/results 2>&1'
echo "===== previews index"
$SSH 'cat /home/rowan/work/previews/index.html 2>&1 | head -120'
echo "===== connector route guesses"
B=https://connector.arwc.test
for p in /api/ping /api/healthz /api/v1/ping /relay /c /connector /report /reports /assistant /districts /planning /documents /linked /api/reports /api/assistant /api/districts /api/documents /api/v1 /api/v1/reports /api/v1/districts /api/v1/documents /.well-known/fieldkest-relay /invoke /callback; do
  printf '# %-32s ' "$p"
  curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -o /tmp/cb -w '%{http_code} %{content_type} %{size_download}\n' "$B$p" 2>&1
  head -c 200 /tmp/cb; echo
done
