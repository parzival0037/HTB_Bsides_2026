#!/bin/bash
set +e
B=http://10.77.40.10:8000
echo "== root"
curl -sS -m 8 "$B/" | sed -n 's/.*href="\([^"]*\)".*/\1/p'
echo "== guess dirs"
for d in CairnReach/ CairnReach/Records/ Records/ cairnreach/ cairn/ Desktop/ Documents/ Downloads/ .ssh/ repos/ notes/ work/ opt/ tmp/; do
  printf "%-24s " "$d"
  curl -sS -m 6 -o /tmp/l -w "%{http_code} %{size_download} %{content_type}\n" "$B$d"
done
echo "== dump body of CairnReach if any"
curl -sS -m 6 "$B/CairnReach/" | head -c 1500; echo
