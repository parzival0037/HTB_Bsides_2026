#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
for u in "/" "/api" "/api/customers" "/api/customers/arwc" "/api/customers/ARWC" "/api/customers/TEN-ARWC-047" "/api/maintenance" "/api/handovers" "/api/handovers/current" "/api/diagnostics" "/api/tenants" "/api/enrollment" "/api/staff" "/api/onboarding" "/api/employees"; do
  c=$(curl -sS $P -k -m 12 -H "$T" -o /tmp/sp.$$ -w '%{http_code}' "$B$u")
  echo "[$c] $u :: $(head -c 300 /tmp/sp.$$|tr -d '\n')"
done
rm -f /tmp/sp.$$
