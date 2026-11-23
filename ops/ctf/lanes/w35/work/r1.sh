#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
P="--socks5-hostname 127.0.0.1:1080"
C="curl -sS $P -k --max-time 15"
echo "===== resolv/hosts on rowan ====="
$S 'cat /etc/resolv.conf; echo ---HOSTS---; cat /etc/hosts'
echo "===== staff service-directory ====="
$C https://staff.keplerops.test/api/service-directory -w '\n%{http_code}\n' | head -c 4000
echo
echo "===== connector well-known ====="
$C https://connector.arwc.test/.well-known/fieldkest-client -w '\n%{http_code}\n' | head -c 3000
echo
echo "===== connector root/common ====="
for p in / /api /health /api/fieldlink /api/supply /api/supply/catalog /api/procurement /api/quotes; do
  printf '%s -> ' "$p"; $C -o /tmp/c.out -w '%{http_code} ' "https://connector.arwc.test$p"; head -c 160 /tmp/c.out; echo
done
echo "===== DNS lookups from rowan ====="
$S 'for h in supply.arwc.test procurement.arwc.test quotes.arwc.test quote.arwc.test districts.arwc.test district.arwc.test budget.arwc.test budgets.arwc.test water.arwc.test portal.arwc.test app.arwc.test arwc.test; do printf "%-28s " $h; getent hosts $h || echo NO; done'
echo "===== rowan browser history arwc ====="
$S 'cat ~/.config/chromium/Default/History 2>/dev/null | strings | grep -i -e arwc -e supply -e quote | head -30; ls ~/.config/chromium/Default/ 2>/dev/null'
