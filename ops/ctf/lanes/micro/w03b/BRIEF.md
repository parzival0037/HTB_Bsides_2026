Solve exactly ONE card: W03.2. Do not work anything else. Time budget ~10 minutes.

ACCESS (already proven — do not re-derive):
- Run everything from the range box: /home/kali/ctf/box.py -f script.sh  (or 'box.py "cmd"')
- SOCKS pivot on the box: curl -sS --socks5-hostname 127.0.0.1:1080 -k https://HOST/...
- Support client bearer: fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
- Working ARWC ingress (NOT connector.arwc.test, that 403s):
    https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector
    https://support.keplerops.test:8443/api/handovers/current
    https://support.keplerops.test:8443/api/customers/{tenant}/diagnostics
    https://support.keplerops.test:8443/api/diagnostics/{job}[/package|/deliver]
    https://cloud-api.keplerops.test/api/workspaces/current/token-exchange
- Gitea: source.keplerops.test  rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
- Tenants: TEN-ARWC-047 (CRR-OG2), TEN-RILL-022 (RILL-PUMP-442)
- Full map: /home/kali/ctf/lanes/ARWC-FINDINGS.md and /home/kali/ctf/lanes/NETMAP.md

RULES: no hints (points), no guessing — submit only a flag you have literally read out of a
response. Submit with /home/kali/ctf/submit.py 'W03.2' 'FLAG{...}'.
Find the reference outside the order: delivery package-meta + support customer diagnostics for TEN-ARWC-047.

### W03.2: A reference outside the order  (100p medium)  id=dfbd4b4d-c4e4-498d-978d-9bd88ab1d5a5  attempts=0
Reconcile the annex revision history with the engineering document that reached the supplier account.

-- 1 unsolved matching '^W03.2'
