S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
echo "=== ls work"; find ~/work -maxdepth 2 | head -60
echo "=== registry/README.md"; cat ~/work/registry/README.md
echo "=== release-lineage-review.md"; cat ~/work/build-operations/release-lineage-review.md
echo "=== README.md"; cat ~/README.md
echo "=== repos"; find ~/repos -maxdepth 2 | head -40
RSH
