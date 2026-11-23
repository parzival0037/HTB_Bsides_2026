#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'for s in export public support workspace; do echo "##### schema $s"; psql service=fieldlink -Atc "select table_schema||'.'||table_name from information_schema.tables where table_schema='"'"'$s'"'"' order by 1"; done; echo "##### workspace cols"; psql service=fieldlink -c "select table_name,column_name,data_type from information_schema.columns where table_schema in ('"'"'support'"'"','"'"'workspace'"'"','"'"'export'"'"') order by 1,2" '
