#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "===== wildcard dns"
for n in zzz.keplerops.test zzz.arwc.test report.keplerops.test reports.keplerops.test report-assistant.keplerops.test assistant.arwc.test; do printf "%-32s " $n; getent hosts $n | awk '{print $1}' | tr "\n" " "; echo; done
echo "===== cert SAN assistant"
echo | openssl s_client -connect assistant.keplerops.test:443 -servername assistant.keplerops.test 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep -A2 "Subject Alternative Name"
echo "===== cert SAN connector"
echo | openssl s_client -connect connector.arwc.test:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep -A2 "Subject Alternative Name"
echo "===== vhost scan on assistant ip 10.77.50.11"
for h in reports report report-assistant reportassistant retrieval linked-documents linked documents docstore docs assistant2 assistant-portal district districts planning planner cairn cairnreach arwc arwc-reports fieldlink report-service reportsvc assistant-api knowledge library; do
  code=$(curl -sS -m 6 --cacert $CA --resolve "$h.keplerops.test:443:10.77.50.11" -o /tmp/vh.$$ -w '%{http_code}' "https://$h.keplerops.test/" 2>/dev/null)
  sz=$(wc -c </tmp/vh.$$ 2>/dev/null)
  first=$(head -c 100 /tmp/vh.$$ | tr -d '\n')
  echo "$h -> $code $sz :: $first"
done
rm -f /tmp/vh.$$
INNER
