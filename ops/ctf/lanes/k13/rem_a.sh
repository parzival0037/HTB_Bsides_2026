set +e
echo "== grep words =="
grep -rliE 'support.?export|notebook|deployment' /home/rowan 2>/dev/null | head -40
echo "== find =="
find /home/rowan -type f 2>/dev/null | grep -iE 'notebook|ipynb|export|bucket|object' | head -40
echo "== anon S3 root =="
curl -sSk -m 10 -i https://objects.keplerops.test/ | head -30
echo "== anon list fieldlink-exports =="
curl -sSk -m 10 -i 'https://objects.keplerops.test/fieldlink-exports?list-type=2' | head -30
echo "== candidate buckets =="
for b in support-exports support-export fieldlink-support support exports notebooks cloud-notebooks deployment-notebooks fieldlink-notebooks backups public shared data handover handovers support-handover workspace workspaces fieldlink-handover; do
  code=$(curl -sSk -m 6 -o /tmp/bk -w '%{http_code}' "https://objects.keplerops.test/$b?list-type=2")
  echo "== $b -> $code"
  head -c 400 /tmp/bk; echo
done
echo "== aws s3api on fieldlink-exports =="
E=https://objects.keplerops.test
aws --endpoint-url $E s3api get-bucket-acl --bucket fieldlink-exports 2>&1
echo ---POLICY---
aws --endpoint-url $E s3api get-bucket-policy --bucket fieldlink-exports 2>&1
echo ---VERSIONING---
aws --endpoint-url $E s3api get-bucket-versioning --bucket fieldlink-exports 2>&1
echo ---VERSIONS---
aws --endpoint-url $E s3api list-object-versions --bucket fieldlink-exports 2>&1 | head -30
