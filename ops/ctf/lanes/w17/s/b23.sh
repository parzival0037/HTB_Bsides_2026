#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== backups"; aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports/backups/ 2>&1 | head -100
echo "== exports root recursive"; aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports/ 2>&1 | head -100
echo "== anon list"; curl -sS -m 10 -k "https://objects.keplerops.test/fieldlink-exports?list-type=2&prefix=backups/" | head -c 2000; echo
echo "== assistant workspaces"; curl -sS -m 10 -k https://assistant.keplerops.test/api/v1/workspaces | head -c 1500; echo' 2>&1 | tail -60
