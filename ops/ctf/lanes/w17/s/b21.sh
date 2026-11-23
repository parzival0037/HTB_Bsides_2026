#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
H=connector.arwc.test
words="process process-data processdata process_data history historian historian/query historian/series historian/catalog points tags plant plants site sites outlet outlets reservoir reservoirs level realtime live feed observations readings series catalog tags status health info version time now opcua ua plc scada fuxa hmi data telemetry measurements samples samples/latest latest current state overview crr crr-og2 arwc cairn flows flow_b flow_b_m3s opc tags/latest plant/state process/state process/history process/samples historian/samples history/latest"
for w in $words; do
 for pre in /api /api/v1 /api/fieldlink /api/arwc; do
  p="$pre/$w"
  out=$(curl -sS $P -m 5 -k -o /tmp/f -w "%{http_code}" "https://$H$p" 2>/dev/null)
  if [ "$out" != "404" ] && [ "$out" != "000" ]; then echo "GET $p -> $out $(head -c 200 /tmp/f|tr -d '\n')"; fi
 done
done
echo "== POST probes"
for p in /api/fieldlink/process /api/process /api/history /api/historian/query /api/observations /api/points; do
 out=$(curl -sS $P -m 6 -k -X POST -H 'Content-Type: application/json' -d '{}' -o /tmp/f -w "%{http_code}" "https://$H$p" 2>/dev/null)
 echo "POST $p -> $out $(head -c 200 /tmp/f|tr -d '\n')"
done
