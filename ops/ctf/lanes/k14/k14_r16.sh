set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
E=https://objects.keplerops.test
echo "=== LIST ALL KEYS (anon) ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/?list-type=2" | tr '<' '\n<' | grep -E 'Key>|VersionId>' | head -80
echo "=== VERSIONS ALL (anon) ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/?versions" | tr '<' '\n<' | grep -E 'Key>|VersionId>|IsLatest>|LastModified>' | head -120
echo "=== LATEST HANDOVER ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/exports/EXP-2841/handover.json"; echo
echo "=== LATEST NOTEBOOK ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/notebooks/deploy-2026-09.json"; echo
echo "=== OTHER GUESSED KEYS ==="
for k in exports/EXP-2841/trust.json trust/TR-1.json workloads/fieldlink-workload.json identity/workload.json exports/EXP-2841/definition.json exports/EXP-2841/export.json README.md trust.json workspace.json; do
 echo "-- $k"; curl -sSk -m 8 -w ' [%{http_code}]' "$E/fieldkest-workspaces/$k" | head -c 600; echo
done
RSH
echo DONE_K14_R16
