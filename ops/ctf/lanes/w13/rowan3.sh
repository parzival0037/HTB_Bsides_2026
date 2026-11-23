#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'EOS'
echo "=== README ==="; cat ~/repos/connector-archive/connector-archive/README.md
echo "=== retained-diagnostic ==="; cat ~/repos/connector-archive/connector-archive/notes/retained-diagnostic.md
echo "=== diagnostic.conf ==="; cat ~/repos/connector-archive/connector-archive/config/diagnostic.conf
echo "=== ordinary.conf ==="; cat ~/repos/connector-archive/connector-archive/config/ordinary.conf
echo "=== map (head) ==="; head -60 ~/repos/connector-archive/connector-archive/maps/fieldlink-connector-6.9.8.map
echo "=== grep keywords ==="
grep -ril -e appointment -e roster -e checkin -e 'check-in' -e contractor ~ 2>/dev/null | grep -v -e node_modules -e '/core' -e '.cache' | head -40
echo "=== registry ls ==="; ls -la ~/work/registry ~/work/samples ~/work/analysis ~/work/build-operations ~/work/reproducers ~/work/previews 2>/dev/null
EOS
