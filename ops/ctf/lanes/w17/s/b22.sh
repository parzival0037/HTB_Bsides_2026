#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== npmrc"; cat ~/.npmrc
echo "== registry search";
for q in cairn arwc crr openplc fuxa historian ot- fieldlink keplerops; do echo "-- $q"; curl -sS -m 10 -k "https://packages.keplerops.test/-/v1/search?text=$q&size=50" | head -c 1500; echo; done
echo "== s3 buckets"; aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -30
echo "== s3 exports"; aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -40' 2>&1 | tail -80
