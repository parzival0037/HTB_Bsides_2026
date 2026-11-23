set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
H="Authorization: Bearer $TOK"
for pair in "support-private:1b9adb92-643d-4888-9cc4-53a56b73754b" "support-private:e93f0368-c6f2-4acb-8ae0-964a03b34698" "support-private:384cd0fa-4c07-409c-bc71-67023cb73158" "support-private:0c112b4c-82a7-4b05-92df-6f400109f7f2" "rillhaven-support:7036102c-b664-40bb-8925-e0020c215764" "rillhaven-support:d5518dd4-3159-44e0-b18a-b99fc9a0b598" "fieldlink-operations:1c0fe454-6eec-448b-b2e4-1019457c495b"; do
 s=${pair%%:*}; d=${pair#*:}
 echo "########## DOC $d"
 for p in "/api/document/$d" "/api/workspace/$s/document/$d" "/api/workspace/$s/document/$d?mode=raw"; do
   echo "--- $p"
   curl -sS -m 10 --cacert $CA -H "$H" -i "$A$p" | head -c 1500; echo
 done
done
echo "########## DOCLIST"
for s in support-private rillhaven-support fieldlink-operations; do
 echo "--- $s"; curl -sS -m 10 --cacert $CA -H "$H" -i "$A/api/workspace/$s/documents" | head -c 800; echo
done
INNER
echo DONE_MARK_$RANDOM
