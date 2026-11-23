set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cd work/fieldlink-connector && for f in README.md docs/report-provider.md review/FLK-7.4.2.md tests/test_crr_og2_report.py; do echo "--- $f"; cat $f; done; echo ---GIT---; cat .git/config; git log --oneline --all; git branch -a; git tag'
run 'cd work && for f in registry/README.md registry/consumer-request.json registry/inspection-normal.json registry/inspection-compat.fki registry/k05-1-check.enc registry/k05-3-reconcile.enc registry/k05-4-check.enc samples/FK-SAMPLE-017.json reproducers/indexer-client.json local-helper.md; do echo "--- $f"; cat $f; echo; done'
run 'cd work && for f in service-notes.md identity-access.md platform-access.md build-operations/*.md analysis/staging-decoder.ps1; do echo "--- $f"; cat "$f"; echo; done'
run 'component; echo ---; ls -la ~/.local/share/keplerops/; echo ---; curl -sS -m 8 -i "https://packages.keplerops.test/" --cacert ~/.local/share/keplerops/ca.crt | head -40'
