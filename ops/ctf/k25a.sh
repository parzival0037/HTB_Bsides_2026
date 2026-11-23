set +e
P="curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for path in / /openapi.json /docs /client /api /api/cases /api/tickets /.well-known/fieldkest-client; do
  printf '%-30s ' "$path"; code=$($P -H "$B" -o /tmp/s.out -w '%{http_code}' "https://support.keplerops.test$path"); echo -n "$code "; head -c 200 /tmp/s.out | tr '\n' ' '; echo
done
echo "=== with bearer, case list attempt ==="
for u in "https://support.keplerops.test/api/v1/cases" "https://support.keplerops.test/api/cases/SUP-2841" "https://support.keplerops.test/api/v1/tickets/SUP-2841"; do
  printf '%-50s ' "$u"; $P -H "$B" -o /tmp/s2.out -w '%{http_code} ' "$u"; head -c 200 /tmp/s2.out; echo
done
