#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
C="Cookie: KB_SID=61073ebaedb1d2e9986fea5cac5f50cd"
for u in https://staff.keplerops.test/ https://staff.keplerops.test/api https://staff.keplerops.test/api/health https://staff.keplerops.test/.well-known/fieldkest-client; do
 echo "=== $u"
 curl $P -H "$C" -i "$u" | head -40
done
echo "=== workboard"
for u in https://workboard.keplerops.test/ https://workboard.keplerops.test/api; do echo "=== $u"; curl $P -H "$C" -i "$u" | head -20; done
echo "=== identity"
curl $P -sS -k -i https://identity.keplerops.test/realms/keplerops/account/ | head -20
echo DONE_R9
