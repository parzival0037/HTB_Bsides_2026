set +e
R(){ ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev "$1" 2>&1; }
echo "===== remaining work files ====="
R 'for f in work/reproducers/indexer-client.json work/analysis/staging-decoder.ps1 work/fieldlink-connector/review/FLK-7.4.2.md work/fieldlink-connector/docs/report-provider.md work/registry/README.md work/samples/FK-SAMPLE-017.json; do echo "--- $f"; cat "$f"; echo; done'
echo "===== find notebooks/exports on ws ====="
R 'find / -xdev \( -iname "*.ipynb" -o -iname "*notebook*" -o -iname "*export*" \) 2>/dev/null | grep -v -E "^/(proc|sys|usr/share/(doc|man))" | head -60'
echo "===== grep words across ws ====="
R 'grep -rliE "support.?export|notebook|deployment" /home/rowan 2>/dev/null | head -40'
echo "===== anon S3 root ====="
R 'curl -sSk -m 10 -i https://objects.keplerops.test/ | head -40'
echo "===== anon list fieldlink-exports ====="
R 'curl -sSk -m 10 -i "https://objects.keplerops.test/fieldlink-exports?list-type=2" | head -40'
echo "===== anon candidate buckets ====="
R 'for b in support-exports support-export fieldlink-support support exports notebooks cloud-notebooks deployment-notebooks fieldlink-notebooks backups public shared data handover handovers support-handover; do code=$(curl -sSk -m 6 -o /tmp/b.$$ -w "%{http_code}" "https://objects.keplerops.test/$b?list-type=2"); echo "== $b -> $code"; head -c 300 /tmp/b.$$; echo; done'
echo "===== bucket policy / acl ====="
R 'aws --endpoint-url https://objects.keplerops.test s3api get-bucket-acl --bucket fieldlink-exports 2>&1; echo ---; aws --endpoint-url https://objects.keplerops.test s3api get-bucket-policy --bucket fieldlink-exports 2>&1; echo ---; aws --endpoint-url https://objects.keplerops.test s3api get-bucket-versioning --bucket fieldlink-exports 2>&1; echo ---; aws --endpoint-url https://objects.keplerops.test s3api list-object-versions --bucket fieldlink-exports 2>&1 | head -40'
echo DONE_K13_R3
