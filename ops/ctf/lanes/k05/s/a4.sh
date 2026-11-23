set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'set -x; rm -rf /tmp/k05; mkdir -p /tmp/k05; cd /tmp/k05; export NODE_EXTRA_CA_CERTS=$HOME/.local/share/keplerops/ca.crt
npm pack @keplerops/fieldlink-connector@7.4.2 2>&1 | tail -3
npm pack @keplerops/fieldlink-connector@6.9.8 2>&1 | tail -3
npm view @keplerops/fieldlink-connector readme 2>&1 | head -120
for v in 7.4.2 6.9.8; do mkdir -p p$v; tar xzf keplerops-fieldlink-connector-$v.tgz -C p$v; done
find . -path ./node_modules -prune -o -type f -print | head -50
for v in 7.4.2 6.9.8; do echo "##### $v"; for f in $(find p$v/package -maxdepth 2 -type f); do echo "--- $f"; cat "$f"; echo; done; done' 2>&1 | tail -300
