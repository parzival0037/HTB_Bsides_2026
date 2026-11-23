echo 'c2VsZWN0IHRhYmxlX3NjaGVtYXx8Jy4nfHx0YWJsZV9uYW1lIGZyb20gaW5mb3JtYXRpb25fc2NoZW1hLnRhYmxlcyB3aGVyZSB0YWJsZV9zY2hlbWEgIX4gJ14ocGdfY2F0YWxvZ3xpbmZvcm1hdGlvbl9zY2hlbWF8cGdfdG9hc3QpJCcgb3JkZXIgYnkgMTsK' | base64 -d > ~/k25/q.sql
cat ~/k25/q.sql
ssh rowan-dev "psql service=fieldlink -At" < ~/k25/q.sql 2>&1
