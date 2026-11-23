#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== arwc pkg 7.4.2 files"
for f in /tmp/arwcpkg/keplerops-fieldlink-connector-7.4.2/package/*; do echo "### $f"; cat "$f"; echo; done
echo "===== grep trees for district/assistant/planning/source"
grep -rniI --exclude-dir=.git "district\|report.assistant\|source.selection\|linked.document\|planning excerpt\|retrieval\|assistant" /tmp/grepo /tmp/gt /tmp/gm /tmp/gr-fieldlink-connector /tmp/gr-connector-archive /tmp/gr-policy-compiler /tmp/gr-release-signer-history 2>/dev/null | head -80
echo "===== tree /tmp/grepo"
find /tmp/grepo -maxdepth 5 -type f | sort | head -80
echo "===== tree /tmp/gt"
find /tmp/gt -maxdepth 5 -type f | sort | head -60
echo "===== tree /tmp/gm"
find /tmp/gm -maxdepth 5 -type f | sort | head -60
echo "===== e.json / del.json / deliv.py / dns*.py / getkey.py"
for f in /tmp/e.json /tmp/del.json /tmp/deliv.py /tmp/getkey.py /tmp/conn2.py /tmp/dbg.py; do echo "### $f"; head -c 2000 "$f"; echo; done
echo "===== fz / fl tgz contents"
cat /tmp/fz; for t in /tmp/fl-*.tgz; do echo "### $t"; tar tzf "$t" 2>&1 | head; done
INNER
