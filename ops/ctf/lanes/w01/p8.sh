#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T="Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
show(){ echo "########## $1"; shift; curl -sS $P -k --max-time 20 -i "$@"; echo; }
show handover -H "Authorization: $T" https://support.keplerops.test:8443/api/handovers/current
show handover-noauth https://support.keplerops.test:8443/api/handovers/current
show customers -H "Authorization: $T" https://support.keplerops.test:8443/api/customers/arwc/diagnostics
show root -H "Authorization: $T" https://support.keplerops.test:8443/
