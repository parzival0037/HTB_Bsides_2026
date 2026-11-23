SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'ls -la ~/work ~/work/registry ~/work/samples ~/work/previews 2>&1; echo ====; cat ~/work/registry/inspection-normal.json; echo ====; ls -la ~/work/registry/*; echo ====; cat ~/work/registry/README.md' 2>&1
