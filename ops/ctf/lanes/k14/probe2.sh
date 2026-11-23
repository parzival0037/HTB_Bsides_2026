set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev '
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
B=https://objects.keplerops.test
echo "===== anonymous bucket fieldkest-workspaces ====="
curl -sSk -m 10 "$B/?list-type=2&prefix=" | head -c 2000; echo
for p in "" "workspaces/" "support/" "notebooks/" "fieldlink/"; do echo "-- prefix $p"; curl -sSk -m 8 "$B/fieldkest-workspaces?list-type=2&prefix=$p" | head -c 1200; echo; done
echo "===== anonymous fieldlink-exports ====="
curl -sSk -m 8 "$B/fieldlink-exports?list-type=2" | head -c 600; echo
echo "===== IAM get-role candidates ====="
for r in rowan.ito rowan-workspace fieldlink-workload fieldkest-workload support-export support-export-reader fieldlink-support support-reader export-reader fieldlink-export-reader support-export-job fieldlink-report-support workload analyst data-reader support; do
  out=$(aws --endpoint-url $B iam get-role --role-name "$r" 2>&1)
  echo "-- $r => $(echo "$out" | head -c 400 | tr "\n" " ")"
done
echo "===== STS web id role existence probes ====="
for r in rowan-workspace fieldlink-workload fieldkest-workload support-export support-export-reader fieldlink-support support-reader export-reader fieldlink-export-reader support-export-job workload analyst; do
  out=$(aws --endpoint-url $B sts assume-role-with-web-identity --role-arn "arn:aws:iam::000000000000:role/$r" --role-session-name probe --web-identity-token "eyJhbGciOiJub25lIn0.eyJhdWQiOiJ4In0." 2>&1 | grep -o "role not found: .*\|InvalidIdentityToken\|An error occurred.*" | head -1)
  echo "-- $r => $out"
done
'
echo DONE_PROBE2
