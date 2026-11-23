#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 15"
B=https://connector.arwc.test
try(){ echo "### $1 $2 :: $3"; curl $P -X "$1" -H 'Content-Type: application/json' ${3:+-d "$3"} -o /tmp/o -w '[%{http_code}] ' "$B$2"; head -c 400 /tmp/o; echo; }
try POST /api/fieldlink/packages/poll ''
try POST /api/fieldlink/packages/poll '{}'
try POST /api/fieldlink/packages/poll '{"channel":"arwc-stable"}'
try POST /api/fieldlink/packages/poll '{"channel":"arwc-stable","tenant_id":"TEN-ARWC-047","asset_id":"CRR-OG2"}'
try POST /api/fieldlink/packages/poll '{"channel_identity":"arwc-stable"}'
try POST /api/fieldlink/packages/poll '{"identity":"arwc-stable","channel":"arwc-stable","version":"7.4.2"}'
try POST /api/fieldlink/packages/poll '{"tenant_id":"TEN-ARWC-047"}'
try POST /api/fieldlink/packages/poll '{"asset_id":"CRR-OG2"}'
try POST /api/fieldlink/packages/poll '{"connector_revision":"FLK-7.4.2"}'
try POST /api/fieldlink/packages/poll '{"channel":"arwc-stable","connector_revision":"FLK-7.4.2"}'
try GET /api/fieldlink/diagnostics ''
try POST /api/fieldlink/diagnostics '{}'
try GET /api/fieldlink/packages/7.4.2/receipt ''
try POST /api/fieldlink/packages/7.4.2/activate '{}'
try POST /api/fieldlink/rehearsals/rollback '{}'
