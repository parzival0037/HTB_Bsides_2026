set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=15 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_PAGER=""
A="aws --endpoint-url https://objects.keplerops.test --no-verify-ssl"
$A s3 cp s3://fieldlink-exports/backups/company-history.dump /tmp/ch.dump 2>/dev/null
file /tmp/ch.dump; ls -l /tmp/ch.dump
echo "===== strings"
strings -a /tmp/ch.dump | head -80
echo "===== hexdump"
xxd /tmp/ch.dump | head -10
RSH
