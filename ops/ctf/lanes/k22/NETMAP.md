# K22 NETMAP (inherited from K17 + own enumeration)

## Access
- Range box: /home/kali/ctf/box.py
- Pivot: ssh rowan-dev (key ~/.ssh/keplerops-foothold, user rowan, uid 2000)
- CA: /home/rowan/.local/share/keplerops/ca.crt (use --cacert for *.keplerops.test)

## Hosts (from rowan-dev)
- support.keplerops.test (10.77.50.11) :443 osTicket staff/SCP (PHP 8.4.27, nginx)
  - :8443 FieldLink support integration API (Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b)
- staff.keplerops.test / workboard.keplerops.test :443 Kanboard-like (KB_SID cookie, /login)
- assistant.keplerops.test :443  <-- K22 target (local Ollama Qwen model + local doc retrieval)
- llm.keplerops.test :443 Ollama API
- identity.keplerops.test :443 Keycloak realm keplerops, account portal
- support.keplerops.test:8443 = FieldLink support integration client

## Credentials
- osTicket staff: maya.ranscombe / sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk
- osTicket reviewer (Talia Mornac): talia.mornac / K17r3v13wTalia2841 (changed via pwreset token)
  pwreset token k17-talia-mornac-review-token-2841
- Gitea: rowan.ito / fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
- Support integration bearer: fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
- kube fieldlink SA token in /home/rowan/.kube/config
- AWS: profile default (objects.keplerops.test), ca_bundle

## Prior flags (other lanes)
- SUP-2841 retention ref FLAG{408710d448134ab5} (K17)
- ESC-2841 handover ref FLAG{a56dde25afcee8cb} (K17)

## K22 challenge chain
- K22.1: assistant's retained source-selection record for ARWC support case
- K22.2: prompt injection via support attachment -> assistant recommends keeping obsolete diagnostic bundle
- K22.3: assistant marks duplicate diagnostic review accepted (privilege escalation via assistant action)
