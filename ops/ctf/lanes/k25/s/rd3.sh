S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
echo "=== tree"; find ~/work/fieldlink-connector -type f -not -path '*/.git/*' | head -40
echo "=== README"; cat ~/work/fieldlink-connector/README.md
echo "=== docs"; for f in ~/work/fieldlink-connector/docs/*; do echo "##### $f"; cat "$f"; done
echo "=== consumer-request"; cat ~/work/registry/consumer-request.json
echo "=== git log"; git -C ~/work/fieldlink-connector log --oneline -15 2>&1
RSH
