set +e
E=https://objects.keplerops.test/fieldkest-workspaces
for spec in "notebooks%2Fdeploy-2026-09.json" "exports%2FEXP-2841%2Fhandover.json"; do
  echo "########## $spec (latest)"
  curl -sSk -m 10 -i "$E/$spec"; echo; echo
done
echo "########## notebook old version"
curl -sSk -m 10 -i "$E/notebooks%2Fdeploy-2026-09.json?versionId=67169f3e5c4e624ee5fa60731e53ed20"; echo
echo "########## handover old version"
curl -sSk -m 10 -i "$E/exports%2FEXP-2841%2Fhandover.json?versionId=67169f3dc6c67c16c30d26c11660f4ab"; echo
