#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 8"
names="arwc plan planning planner allocate allocation ledger meter meters process process-data feed feeds observation observations district districts reserve reserves outlet outlets water water-supply supply supplies procurement purchasing report reports readings historian history data api portal app field fieldops fieldlink fieldkest crr crr-og2 cairn cairnreach plant scada hmi plc opcua registry relay gateway edge site records docs documents inspections maintenance customer customers supplier suppliers finance knowledge library retrieval linked native ics ot lab"
for h in $names; do
  for dom in keplerops.test arwc.test; do
    for ipp in 10.77.50.11:443 10.77.60.20:443; do
      host=$h.$dom; ip=${ipp%:*}; port=${ipp#*:}
      out=$(curl $P --resolve "$host:$port:$ip" -o /tmp/v.out -w '%{http_code}' "https://$host:$port/" 2>/dev/null)
      sz=$(wc -c </tmp/v.out)
      if [ "$out" != "404" ] && [ "$out" != "000" ] && [ "$out" != "403" ]; then
        echo "HIT $host @$ipp -> $out size=$sz :: $(head -c 160 /tmp/v.out | tr -d '\n')"
      elif [ "$out" = "403" ]; then
        echo "403 $host @$ipp :: $(head -c 120 /tmp/v.out | tr -d '\n')"
      fi
    done
  done
done
echo DONE_A5
