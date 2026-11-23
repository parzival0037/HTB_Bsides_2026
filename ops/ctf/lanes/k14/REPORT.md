# K14 — REPORT (in progress)

Lane workdir: /home/kali/ctf/lanes/k14
Assigned: K14.1 trust document, K14.2 scoped role for another audience, K14.3 export resource boundary.

## Status
Recon started. Shared intel from lane k13 (same cloud env) shows:
- rowan-dev has a kubeconfig token (JWT) for a service account
- cloud-api.keplerops.test: /api/token-exchange/<role>, /api/trust-records/TR-1, /api/exports/EXP-2841, /api/maintenance...
- objects.keplerops.test S3-like with STS AssumeRoleWithWebIdentity
- k13 already recovered workload identity flag FLAG{6bb66074f2325405} (K13.4)

## Flags submitted
(none yet)
