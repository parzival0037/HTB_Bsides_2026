#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'INNER'
echo "=== support client cfg ==="; cat ~/.config/fieldlink/support-client.json 2>/dev/null
echo "=== grep connector.arwc cinder appointment ==="
grep -rl -i -E 'connector\.arwc|cinder' ~/work ~/repos ~/.config /etc 2>/dev/null | head -20
echo "=== all tickets via API ==="
B=$(python3 -c "import json;print(json.load(open('/home/rowan/.config/fieldlink/support-client.json'))['retained_staff_login'])" 2>/dev/null || python3 -c "import json;d=json.load(open('/home/rowan/.config/fieldlink/support-client.json'));print(d)")
echo "bearer=${B:0:25}..."
INNER
