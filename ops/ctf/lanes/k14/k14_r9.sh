set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
echo "=== WELLKNOWN MORE ==="
for h in objects source source-tools ci review packages preview indexer llm data kerberos cloud; do
 port=""; [ "$h" = "source-tools" ] && port=":8443"
 echo "##### $h"
 curl -sSk -m 6 "https://$h.keplerops.test$port/.well-known/fieldkest-client" | head -c 1800; echo
done
echo "=== OBJECTS ROOT ==="
curl -sSk -m 8 -i https://objects.keplerops.test/ | head -c 1200; echo
echo "=== OBJECTS BUCKET GUESSES ==="
E=https://objects.keplerops.test
for b in fieldlink-exports fieldlink-support fieldlink-support-exports support-exports support-export fieldlink-workloads workload-identity workload-trust fieldlink-identity fieldlink-trust keplerops-trust trust-records fieldlink-data; do
  code=$(curl -sSk -m 5 -o /tmp/b -w '%{http_code}' "$E/$b/")
  echo "-- $b -> $code :: $(head -c 160 /tmp/b | tr '\n' ' ')"
done
echo "=== S3 BUCKET API GUESSES (signed) ==="
for b in fieldlink-exports fieldlink-support support-exports support-export fieldlink-workloads workload-identity fieldlink-identity; do
  echo "-- head $b"; aws --endpoint-url $E s3api head-bucket --bucket "$b" 2>&1 | head -3
  echo "-- list $b"; aws --endpoint-url $E s3 ls "s3://$b/" 2>&1 | head -5
done
echo "=== DNS ENUM ==="
for n in trust oidc sts workload workloads identity id auth login sso token tokens kepler cloud api k8s kube cluster s3 export exports support data objects ca cert; do
  ip=$(getent hosts $n.keplerops.test | awk '{print $1}' | head -1)
  [ -n "$ip" ] && echo "$n.keplerops.test = $ip"
done
echo "--- wildcard?"; getent hosts doesnotexist-zzz.keplerops.test
RSH
echo DONE_K14_R9
