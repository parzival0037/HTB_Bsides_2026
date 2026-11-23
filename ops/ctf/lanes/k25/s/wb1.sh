CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for host in staff.keplerops.test workboard.keplerops.test; do
 echo "########## $host"
 for path in / /.well-known/fieldkest-client /api /api/cases /api/attachments /api/reviews; do
   echo "--- $host$path"
   curl -sS $P --cacert $CA -m 25 -H "$A" -w '\nHTTP:%{http_code} CT:%{content_type}\n' "https://$host$path" 2>&1 | head -c 1200
   echo
 done
done
