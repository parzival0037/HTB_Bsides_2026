#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 8"
names="arwc plan planning planner allocation allocate ledger meter meters process process-data feed feeds observation observations district districts reserve reserves outlet outlets water supply procurement purchasing report reports readings historian data api portal app field fieldops fieldlink fieldkest crr crr-og2 cairn cairnreach plant scada hmi plc opcua registry relay gateway edge site records docs documents inspections maintenance customer customers supplier suppliers finance knowledge library retrieval linked native ics ot lab"
echo "===== HOST HEADER probes on 10.77.60.20"
for h in $names; do
  for dom in arwc.test keplerops.test; do
    host=$h.$dom
    code=$(curl $P -H "Host: $host" -o /tmp/h60.out -w '%{http_code}' "https://10.77.60.20/" 2>/dev/null)
    sz=$(wc -c </tmp/h60.out 2>/dev/null)
    if [ "$code" != "404" ] && [ "$code" != "000" ]; then
      echo "HIT $host -> $code $sz :: $(head -c 150 /tmp/h60.out | tr -d '\n')"
    fi
  done
done
echo "===== connect-to probes on 10.77.60.20"
for h in $names; do
  host=$h.arwc.test
  code=$(curl $P --connect-to "$host:443:10.77.60.20:443" -o /tmp/ct.out -w '%{http_code}' "https://$host/" 2>/dev/null)
  sz=$(wc -c </tmp/ct.out 2>/dev/null)
  if [ "$code" != "404" ] && [ "$code" != "000" ]; then
    echo "HIT $host -> $code $sz :: $(head -c 150 /tmp/ct.out | tr -d '\n')"
  fi
done
echo "===== connect-to probes on 10.77.50.11"
for h in $names; do
  host=$h.keplerops.test
  code=$(curl $P --connect-to "$host:443:10.77.50.11:443" -o /tmp/ct2.out -w '%{http_code}' "https://$host/" 2>/dev/null)
  sz=$(wc -c </tmp/ct2.out 2>/dev/null)
  if [ "$code" != "404" ] && [ "$code" != "000" ] && [ "$code" != "403" ]; then
    echo "HIT $host -> $code $sz :: $(head -c 150 /tmp/ct2.out | tr -d '\n')"
  fi
done
echo DONE_A8
