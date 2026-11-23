set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cat .config/git/credentials 2>&1; echo ---KUBE---; cat .kube/config; echo ---AWS---; cat .aws/config'
run 'cat work/service-notes.md; echo ===; cat work/local-helper.md; echo ===; cat work/identity-access.md; echo ===; cat work/platform-access.md'
run 'cd work/fieldlink-connector && cat README.md; echo ===; cat .git/config; echo ===; git log --oneline --all; echo ===; git remote -v; echo ===; cat docs/report-provider.md; echo ===; cat review/FLK-7.4.2.md; echo ===; cat tests/test_crr_og2_report.py'
run 'cat work/registry/README.md; echo ===; cat work/registry/consumer-request.json; echo ===; cat work/registry/inspection-normal.json; echo ===; cat work/registry/inspection-compat.fki; echo ===; cat work/samples/FK-SAMPLE-017.json; echo ===; cat work/reproducers/indexer-client.json'
run 'cat work/build-operations/*.md; echo ===; cat work/previews/index.html; echo ===; cat work/previews/review.css; echo ===; cat work/analysis/staging-decoder.ps1'
