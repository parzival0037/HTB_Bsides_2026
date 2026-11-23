#!/bin/bash
echo "===== pivot from box"
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'source %{http_code}\n' https://source.keplerops.test/ 2>&1
curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'connector %{http_code}\n' https://connector.arwc.test/ 2>&1
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== /etc/hosts"
cat /etc/hosts
echo "===== arwc dns guesses"
for n in connector.arwc.test report.arwc.test reports.arwc.test assistant.arwc.test docs.arwc.test planning.arwc.test plans.arwc.test linked.arwc.test documents.arwc.test library.arwc.test portal.arwc.test app.arwc.test api.arwc.test arwc.test www.arwc.test field.arwc.test ops.arwc.test intranet.arwc.test; do printf "%-30s " $n; getent hosts $n | awk '{print $1}' | tr "\n" " "; echo; done
echo "===== connector root + headers"
curl -sS -m 15 --cacert /home/rowan/.local/share/keplerops/ca.crt -i https://connector.arwc.test/ 2>&1 | head -80
echo "===== connector well-known / robots"
for p in /.well-known/fieldkest-client /robots.txt /api /health /openapi.json /docs /api/health; do
  echo "== $p"
  curl -sS -m 10 --cacert /home/rowan/.local/share/keplerops/ca.crt -i "https://connector.arwc.test$p" 2>&1 | head -25
done
echo "===== grep rowan home for arwc/planning/district"
grep -rniIl "arwc\|district\|planning\|report assistant\|linked.document" /home/rowan --exclude-dir=.cache --exclude-dir=.npm --exclude-dir=node_modules 2>/dev/null | head -60
echo "===== work tree"
find /home/rowan/work /home/rowan/repos -maxdepth 3 2>/dev/null | sort | head -120
INNER
