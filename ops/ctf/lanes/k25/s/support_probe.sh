CA=/tmp/k25-ca.crt
P="--socks5-hostname 127.0.0.1:1080"
AUTH="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for base in https://support.keplerops.test:8443 https://support.keplerops.test; do
  for path in / /api /api/ /api/health /health /openapi.json /api/docs /api/v1 /dossiers /api/dossiers /api/tickets /api/customers /.well-known/fieldkest-client; do
    code=$(curl -sS $P --cacert $CA -m 15 -o /tmp/out.$$ -w '%{http_code} %{content_type} %{size_download}' -H "$AUTH" "$base$path" 2>/dev/null)
    echo "$base$path -> $code"
    if [ "${code%% *}" != "404" ] && [ "${code%% *}" != "000" ]; then echo "   BODY: $(head -c 400 /tmp/out.$$ | tr '\n' ' ')"; fi
  done
done
