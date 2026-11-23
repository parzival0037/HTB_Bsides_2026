#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set +e
CA=$HOME/.local/share/keplerops/ca.crt
cd /tmp; rm -rf arwcpkg; mkdir arwcpkg; cd arwcpkg
echo "## npm versions"
npm view @keplerops/fieldlink-connector versions --json 2>&1 | head -c 1500; echo
echo "## registry search"
curl -sS -m 15 --cacert $CA "https://packages.keplerops.test/-/v1/search?text=keplerops&size=50" | head -c 3000; echo
echo "## registry all"
curl -sS -m 15 --cacert $CA "https://packages.keplerops.test/-/all" -o /tmp/all.json -w "%{http_code} %{size_download}\n"; head -c 1500 /tmp/all.json; echo
echo "## pack 7.4.2"
npm pack @keplerops/fieldlink-connector@7.4.2 2>&1 | tail -2
echo "## pack 6.9.8"
npm pack @keplerops/fieldlink-connector@6.9.8 2>&1 | tail -2
ls -la
for t in *.tgz; do echo "##### $t"; tar tzf "$t"; mkdir -p "${t%.tgz}"; tar xzf "$t" -C "${t%.tgz}"; done
echo "## grep routes/urls in package"
grep -rhoE "https?://[A-Za-z0-9._-]+|[A-Za-z0-9_./-]*api/[A-Za-z0-9_./{}-]+" */package/ 2>/dev/null | sort -u | head -80
echo "## package json"
for f in */package/package.json; do echo "### $f"; cat "$f"; echo; done
echo DONE_A6
' 2>&1
