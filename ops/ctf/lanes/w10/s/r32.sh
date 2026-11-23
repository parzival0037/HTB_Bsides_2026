#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
J=https://ci.keplerops.test
g(){ echo; echo "##### $1"; shift; curl $P -u "$U" "$@" -o /tmp/j.$$ -w '%{http_code} %{size_download}\n'; head -c 2500 /tmp/j.$$; echo; }
g root "$J/api/json"
g jobs "$J/api/json?tree=jobs[name,url,color]"
g reportjob "$J/job/fieldlink-report/api/json"
g reportbuilds "$J/job/fieldlink-report/api/json?tree=builds[number,result,timestamp,description,actions[parameters[name,value]]]{0,30}"
g reviewjob "$J/job/fieldlink-report-review/api/json"
g reviewcfg "$J/job/fieldlink-report-review/config.xml"
g reportcfg "$J/job/fieldlink-report/config.xml"
rm -f /tmp/j.$$
