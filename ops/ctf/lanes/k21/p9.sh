set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "######## staff /login"
curl -sSk -m 10 --cacert $CA -c /tmp/kb.jar -i "https://staff.keplerops.test/login" | head -60
echo "######## staff /login body"
curl -sSk -m 10 --cacert $CA -b /tmp/kb.jar "https://staff.keplerops.test/login" | head -c 4000
echo; echo "######## staff api service-directory"
curl -sSk -m 10 --cacert $CA -b /tmp/kb.jar -i "https://staff.keplerops.test/api/service-directory" | head -40
echo; echo "######## staff api notes guess"
curl -sSk -m 10 --cacert $CA -b /tmp/kb.jar -i "https://staff.keplerops.test/api/notes/ESC-SUP-2841-R3" | head -20
echo; echo "######## identity openid config"
curl -sSk -m 10 --cacert $CA "https://identity.keplerops.test/realms/keplerops/.well-known/openid-configuration" | head -c 3000
echo; echo "######## identity account page"
curl -sSk -m 10 --cacert $CA -i "https://identity.keplerops.test/realms/keplerops/account/" | head -20
echo; echo "######## staff js assets"
curl -sSk -m 10 --cacert $CA -b /tmp/kb.jar "https://staff.keplerops.test/login" | grep -oE '(src|href)="[^"]+"' | head -20
INNER
echo DONE_MARK_$RANDOM
