set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
echo "######## tree work"
find /home/rowan/work -maxdepth 3 -type f | head -60
echo "######## indexer-client.json"
cat /home/rowan/work/reproducers/indexer-client.json
echo; echo "######## registry README"
cat /home/rowan/work/registry/README.md
echo; echo "######## inspection-normal.json"
cat /home/rowan/work/registry/inspection-normal.json
echo; echo "######## consumer-request.json"
cat /home/rowan/work/registry/consumer-request.json
echo; echo "######## build ops notes"
for f in /home/rowan/work/build-operations/*.md; do echo "=== $f"; cat "$f"; done
echo; echo "######## local-helper.md + sample"
cat /home/rowan/work/local-helper.md 2>/dev/null
cat /home/rowan/work/samples/*.json 2>/dev/null
echo; echo "######## indexer probes"
CA=/home/rowan/.local/share/keplerops/ca.crt
for u in https://indexer.keplerops.test/ https://indexer.keplerops.test/api/config https://indexer.keplerops.test/api/contexts https://indexer.keplerops.test/health https://indexer.keplerops.test/.well-known/fieldkest-client; do
  echo "===== $u"; curl -sSk -m 10 --cacert $CA -i "$u" 2>&1 | head -30
done
INNER
echo DONE_MARK_$RANDOM
