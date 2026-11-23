#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
G=https://source.keplerops.test
rm -rf /tmp/repos; mkdir -p /tmp/repos; cd /tmp/repos
for full in fieldkest/connector-archive fieldkest/fieldlink-connector fieldkest/policy-compiler fieldkest/release-signer-history; do
  fn=$(echo $full | tr / _)
  curl -sS $P -k -m 60 $A -L -o $fn.tgz "$G/api/v1/repos/$full/archive/main.tar.gz"
  mkdir -p $fn && tar xzf $fn.tgz -C $fn
done
echo "======== FILE LIST ========"
find /tmp/repos -type f | sed 's#/tmp/repos/##' | sort
echo "======== KEYWORD GREP ========"
grep -rin -E "mira|vale|roster|activation|starter|temporary|templ|channel.?ident|enroll|ldap|directory|upn|kerberos|adfs|activedirectory" /tmp/repos --include="*.py" --include="*.js" --include="*.md" --include="*.json" --include="*.yml" --include="*.yaml" --include="*.txt" --include="*.conf" --include="*.toml" -l 2>/dev/null | sort -u
