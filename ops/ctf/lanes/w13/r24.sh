#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
B=https://support.keplerops.test:8443
J=DIAG-ARWC-F1C3F5B2
run(){
  local src="$1" exp="$2" label="$3"
  python3 - "$src" "$exp" <<'PY' > /tmp/pkg.json
import json,sys
print(json.dumps({"expected_output":json.loads(sys.argv[2]),"interface":"fieldkest.connector/v3","source":sys.argv[1]}))
PY
  p=$(curl -sS -m 20 $P -k -X PUT -H "Authorization: Bearer $T" -H 'Content-Type: application/json' --data-binary @/tmp/pkg.json "$B/api/diagnostics/$J/package" -o /tmp/put.out -w '%{http_code}')
  d=$(curl -sS -m 40 $P -k -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' -d '{}' "$B/api/diagnostics/$J/deliver" -o /tmp/del.out -w '%{http_code}')
  echo "[$label] put=$p $(cat /tmp/put.out | head -c 300) deliver=$d $(cat /tmp/del.out | head -c 400)"
}
run 'module.exports={diagnostic_summary:function(req){return {probe:"hello"};}};' '{"probe":"hello"}' A_match
run 'module.exports={diagnostic_summary:function(req){return {probe:"a"};}};' '{"probe":"b"}' B_mismatch
run 'module.exports={diagnostic_summary:function(req){return {v: process.version.startsWith("v")?1:0};}};' '{"v":1}' C_true
run 'module.exports={diagnostic_summary:function(req){return {v: 1+1===3?1:0};}};' '{"v":1}' D_false
run 'module.exports={diagnostic_summary:function(req){var fs=require("fs");var s="";try{s=fs.readFileSync("/proc/self/environ","utf8")}catch(e){s="ERR:"+e.message}return {v: s.includes("PATH")?1:0};}};' '{"v":1}' E_env_path
run 'module.exports={diagnostic_summary:function(req){var fs=require("fs");var s="";try{s=fs.readFileSync("/proc/self/environ","utf8")}catch(e){s="ERR:"+e.message}return {v: s.includes("ARWC")||s.includes("arwc")?1:0};}};' '{"v":1}' F_env_arwc
echo "=== job ==="
curl -sS -m 15 $P -k -H "Authorization: Bearer $T" "$B/api/diagnostics/$J" | head -c 1200; echo
