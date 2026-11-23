SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
for d in release-lineage-2026-09-18 connector-archive-2026-09-18 policy-compiler-2026-09-18 registry-foundation-2026-09-18; do
 echo "########## $d"; ls -laR ~/.local/share/keplerops/$d 2>&1 | head -40
done
echo "########## build-operations"
ls -la ~/work/build-operations; cat ~/work/build-operations/*.md 2>/dev/null
echo "########## analysis reproducers samples"
ls -la ~/work/analysis ~/work/reproducers; for f in ~/work/analysis/* ~/work/reproducers/*; do echo "--- $f"; head -c 1500 "$f"; echo; done
REMOTE
