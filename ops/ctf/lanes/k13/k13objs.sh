set +e
E=https://objects.keplerops.test
C="curl -sSk -m 15 --socks5-hostname 127.0.0.1:1080"
for u in \
 "$E/fieldkest-workspaces/notebooks/deploy-2026-09.json" \
 "$E/fieldkest-workspaces/notebooks/deploy-2026-09.json?versionId=67169f3e5c4e624ee5fa60731e53ed20" \
 "$E/fieldkest-workspaces/exports/EXP-2841/handover.json" \
 "$E/fieldkest-workspaces/exports/EXP-2841/handover.json?versionId=67169f3dc6c67c16c30d26c11660f4ab"; do
 echo "===== $u"; $C "$u"; echo
done
