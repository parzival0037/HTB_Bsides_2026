CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "=== repos search"; curl -sS $P --cacert $CA -m 25 -u "$U" 'https://source.keplerops.test/api/v1/repos/search?limit=50' | jq -r '.data[]? | .full_name' | head -50
echo "=== users"; curl -sS $P --cacert $CA -m 25 -u "$U" 'https://source.keplerops.test/api/v1/users/search?limit=50' | jq -r '.data[]? | .login' | head -20
echo "=== orgs"; curl -sS $P --cacert $CA -m 25 -u "$U" 'https://source.keplerops.test/api/v1/orgs' | jq -r '.[]? | .username' | head
echo "=== support wellknown 8443"; curl -sS $P --cacert $CA -m 20 -w '\n%{http_code}\n' -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" https://support.keplerops.test:8443/.well-known/fieldkest-client
echo "=== support wellknown 443"; curl -sS $P --cacert $CA -m 20 -w '\n%{http_code}\n' https://support.keplerops.test/.well-known/fieldkest-client
echo "=== tools wellknown"; curl -sS $P --cacert $CA -m 20 -w '\n%{http_code}\n' https://source-tools.keplerops.test:8443/.well-known/fieldkest-client | head -c 1500
