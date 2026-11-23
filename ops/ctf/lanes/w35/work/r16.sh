#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== rec.txt ====="
$S 'cat /tmp/rec.txt'
echo "===== resolution ====="
$S 'for h in customer-handover corporate-identity reports retained-archive business-workplace contractor-portal documents erp engineering suppliers planning-data supply procurement; do printf "%-22s " $h; getent hosts $h.arwc.test || echo NO; done'
echo "===== arwc client refs ====="
$S 'for h in erp planning-data; do echo "##### $h"; curl -sS -k -m 10 "https://$h.arwc.test/.well-known/arwc-client" -w "\n%{http_code}\n"; done'
