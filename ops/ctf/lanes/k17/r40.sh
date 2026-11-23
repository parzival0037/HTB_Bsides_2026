set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
E=/home/rowan/work/certificates/evan.calderoux
D="$S2/api/archive/delegation/probe"
P(){ curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d "$1" -w ' [%{http_code}]' "$D"; echo; }
echo "=== spn only ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}'
echo "=== spn + reviewer ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","reviewer":"talia.mornac-review"}'
echo "=== spn + subject ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","subject":"talia.mornac-review"}'
echo "=== spn + principal ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","principal":"talia.mornac-review"}'
echo "=== spn + upn ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","upn":"talia.mornac-review@keplerops.test"}'
echo "=== spn + delegate_to ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","delegate_to":"talia.mornac-review@keplerops.test"}'
echo "=== spn + handover ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","handover":"DIAG-CRR-MIXED-19"}'
echo "=== spn + case ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","case":"SUP-2841"}'
echo "=== spn + note ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","note":"NOTE-SUP-2841-7"}'
echo "=== spn + wrong spn ==="
P '{"spn":"HTTP/other.keplerops.test@KEPLEROPS.TEST"}'
echo "=== spn + reviewer + handover ==="
P '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST","reviewer":"talia.mornac-review","handover":"DIAG-CRR-MIXED-19"}'
echo "=== kerberos env ==="
echo "KRB5CCNAME=$KRB5CCNAME"; ls -la /tmp/krb5cc* 2>/dev/null; ls -la /home/rowan/*.keytab /etc/*.keytab 2>/dev/null
klist 2>&1 | head -10
cat /etc/krb5.conf 2>/dev/null | head -40
echo "=== identity realm discovery ==="
curl -sSk -m 8 --cacert $CA "https://identity.keplerops.test/realms/keplerops/.well-known/openid-configuration" | head -c 800; echo
INNER
echo DONE_R40
