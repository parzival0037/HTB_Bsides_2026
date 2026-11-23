set +e
E=https://objects.keplerops.test
echo "== anon list fieldkest-workspaces =="
curl -sSk -m 10 "https://objects.keplerops.test/fieldkest-workspaces?list-type=2" | head -c 4000; echo
echo "== anon list v2 max-keys 1000 =="
curl -sSk -m 10 "https://objects.keplerops.test/fieldkest-workspaces?list-type=2&max-keys=1000" | python3 -c 'import sys,re;d=sys.stdin.read();print(re.sub(r"<","\n<",d))' | head -80
echo "== anon versions =="
curl -sSk -m 10 "https://objects.keplerops.test/fieldkest-workspaces?versions&max-keys=1000" | head -c 6000; echo
