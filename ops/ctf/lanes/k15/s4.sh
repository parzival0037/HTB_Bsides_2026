set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
echo "###### FULL cloud-api well-known"
curl -sS -m 12 --cacert $CA https://cloud-api.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
echo "###### FULL support well-known"
curl -sS -m 12 --cacert $CA -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" https://support.keplerops.test:8443/.well-known/fieldkest-client | python3 -m json.tool
echo "###### data well-known"
curl -sS -m 12 --cacert $CA https://data.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
echo "###### workloads well-known"
curl -sS -m 12 --cacert $CA https://workloads.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
RSH
echo DONE_S4
