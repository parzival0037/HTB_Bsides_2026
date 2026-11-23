set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
echo "###### partition_bindings ALL"
$P -c "select export_id, tenant, partition_id, connector_revision, revision, is_current from export.partition_bindings order by export_id, revision"
echo "###### partition_bindings json"
$P -c "select row_to_json(t) from export.partition_bindings t"
echo "###### current only"
$P -c "select * from export.partition_bindings where is_current"
echo "###### service-notes.md"
cat ~/work/service-notes.md
echo "###### platform-access.md"
cat ~/work/platform-access.md
echo "###### identity-access.md"
cat ~/work/identity-access.md
RSH
echo DONE_S3
