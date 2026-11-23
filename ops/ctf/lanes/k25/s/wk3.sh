CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
C="Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "=== well-known with bearer"
curl -sS $P --cacert $CA -m 15 -H "$A" -w '\n[%{http_code}]\n' "$B:8443/.well-known/fieldkest-client"
echo "=== well-known with cookie"
curl -sS $P --cacert $CA -m 15 -H "$C" -w '\n[%{http_code}]\n' "$B:8443/.well-known/fieldkest-client"
echo "=== well-known variants"
for p in fieldkest-client.json fieldkest-clients fieldkest-integration fieldkest-integrations fieldkest-support fieldkest-connector fieldkest-tenant fieldkest-import fieldkest; do
  printf '%-28s ' "$p"; curl -sS $P --cacert $CA -m 10 -o /tmp/x -w '%{http_code} ' "$B:8443/.well-known/$p"; head -c 200 /tmp/x; echo
done
echo "=== .well-known/ dir"
curl -sS $P --cacert $CA -m 10 -w '\n[%{http_code}]\n' "$B:8443/.well-known/" | head -c 400
echo "=== support root api paths"
for p in /api /api/integrations /api/integration /api/reconcile /api/customers /api/tenants /api/records /api/dossiers; do
  printf '%-24s ' "$p"; curl -sS $P --cacert $CA -m 10 -H "$A" -o /tmp/y -w '%{http_code} ' "$B:8443$p"; head -c 300 /tmp/y; echo
done
