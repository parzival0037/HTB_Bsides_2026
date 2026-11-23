#!/bin/bash
# usage: mkrun.sh remote_payload.sh out.sh [user@host]
set -e
p="$1"; out="$2"; tgt="${3:-rowan-dev}"
b=$(base64 -w0 "$p")
{
  echo 'set +e'
  echo "printf '%s' '$b' | base64 -d > /tmp/k13pay.$$.sh"
  echo "ssh -o BatchMode=yes -o StrictHostKeyChecking=no $tgt 'bash -s' < /tmp/k13pay.$$.sh"
  echo "echo __PAYLOAD_DONE__"
} > "$out"
echo "wrote $out"
