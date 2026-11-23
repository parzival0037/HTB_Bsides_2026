echo 'XGQgZXhwb3J0LnBhcnRpdGlvbl9iaW5kaW5ncwpzZWxlY3QgKiBmcm9tIGV4cG9ydC5wYXJ0aXRpb25fYmluZGluZ3M7Cg==' | base64 -d > ~/k25/q.sql
ssh rowan-dev "psql service=fieldlink" < ~/k25/q.sql 2>&1 | head -60
