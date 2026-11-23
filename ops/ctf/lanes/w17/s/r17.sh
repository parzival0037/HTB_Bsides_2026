#!/bin/bash
echo "== box hosts"; cat /etc/hosts; echo
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'pip3 install --quiet --user dnspython 2>/dev/null; python3 - <<PY
import dns.query, dns.zone, dns.resolver
try:
    z=dns.zone.from_xfr(dns.query.xfr("10.77.50.10", "arwc.test", timeout=8))
    for n in z.nodes: print(n)
except Exception as e: print("AXFR arwc fail:", e)
for q in ["arwc.test","connector.arwc.test","plant.arwc.test","fuxa.arwc.test","_http._tcp.arwc.test"]:
    try:
        print(q, [str(r) for r in dns.resolver.resolve(q,"A", lifetime=4)])
    except Exception as e: print(q,"ERR",e)
PY' 2>&1 | tail -30
