set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
echo "########## ROOT HTML"
curl -sS -m 8 --cacert $CA $A/ 2>&1
echo
echo "########## token as bearer on assistant"
for p in /api/workspaces /api/workspace/fieldlink-operations /api/admin/workspaces /api/v1/workspaces; do
 echo "--- $p"
 curl -sS -m 8 --cacert $CA -i -H "Authorization: Bearer $TOK" "$A$p" 2>&1 | head -15
 echo
done
echo "########## assistant login-ish routes"
for p in /login /api/auth /api/request-token /api/admin/users /api/admin/invites /robots.txt /manifest.json /sitemap.xml /version /health; do
 echo "--- $p"
 curl -sS -m 6 --cacert $CA -i "$A$p" 2>&1 | head -8
done
echo "########## support 8443 probe"
for p in /api/support /api/support/context /api/context /api/v1/context /api/assistant /api/assistant/config /api/config /config /api/v1/config /api/workspaces /api/support/workspaces /api/v1/support/workspaces /api/documents /api/support/documents /api/cases /api/v1/cases; do
 echo "--- $p"
 curl -sS -m 6 --cacert $CA -i -H "Authorization: Bearer $TOK" "https://support.keplerops.test:8443$p" 2>&1 | head -8
done
INNER
