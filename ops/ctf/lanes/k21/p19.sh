set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
C="Cookie: fieldkest_support=$SUP"
curl -sSk -m 120 --cacert $CA -H "$C" "$A/api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442" -o /tmp/doc.json
echo "size: $(wc -c < /tmp/doc.json)"
python3 - <<'PY'
import json
d=json.load(open('/tmp/doc.json'))
print("KEYS",list(d.keys()))
print("DOC:",d.get("document"))
for i,s in enumerate(d.get("sources",[])):
    print(f"\n===== SOURCE {i} title={s.get('title')} =====")
    print(s.get("text"))
PY
INNER
echo DONE_MARK_$RANDOM
