set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
echo "######## support-client.json"
cat /home/rowan/.config/fieldlink/support-client.json
echo
echo "######## grep session in rowan config/work"
grep -rin --exclude-dir=node_modules --exclude-dir=.git 'session\|assistant\.keplerops\|ctx-support' /home/rowan/.config /home/rowan/work /home/rowan/README.md 2>/dev/null | head -40
echo "######## platform-access.md"
cat /home/rowan/work/platform-access.md
echo "######## service-notes.md"
cat /home/rowan/work/service-notes.md
echo "######## support:8443 root/wellknown/openapi"
for p in / /health /api /api/session /api/sessions /api/token /api/request-session /.well-known/fieldkest-client /openapi.json /docs /redoc; do
  echo "===== $p"
  curl -sSk -m 10 --cacert $CA -i "https://support.keplerops.test:8443$p" 2>&1 | head -25
done
INNER
echo DONE_MARK_$RANDOM
