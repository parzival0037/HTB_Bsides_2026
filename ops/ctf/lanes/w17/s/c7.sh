#!/bin/bash
set +e
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'set +e
echo "== work files"; find ~/work -type f | grep -v "/\.git/" | head -60
echo "== README"; cat ~/work/fieldlink-connector/README.md
echo "== docs"; for f in ~/work/fieldlink-connector/docs/*; do echo "### $f"; cat "$f"; echo; done
echo "== build-ops"; for f in ~/work/build-operations/*; do echo "### $f"; cat "$f"; echo; done
echo "== analysis ps1"; cat ~/work/analysis/staging-decoder.ps1
echo "== odt text"; cd /tmp && rm -rf odtx && mkdir odtx && cd odtx && unzip -o -q ~/work/analysis/field-notes-2026-08.odt 2>/dev/null && cat content.xml 2>/dev/null | sed -e "s/<[^>]*>/ /g" | tr -s " " | head -c 6000
' 2>&1 | tail -220
