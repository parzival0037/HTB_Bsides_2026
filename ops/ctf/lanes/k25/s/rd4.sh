S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
echo "=== FK-SAMPLE-017.json"; cat ~/work/samples/FK-SAMPLE-017.json
echo "=== review/FLK-7.4.2.md"; cat ~/work/fieldlink-connector/review/FLK-7.4.2.md
echo "=== policy-compiler-handoff.md"; cat ~/work/build-operations/policy-compiler-handoff.md
echo "=== connector-archive-review.md"; cat ~/work/build-operations/connector-archive-review.md
echo "=== identity-access.md"; cat ~/work/identity-access.md
echo "=== platform-access.md"; cat ~/work/platform-access.md | head -60
echo "=== service-notes.md"; cat ~/work/service-notes.md
echo "=== local-helper.md"; cat ~/work/local-helper.md
RSH
