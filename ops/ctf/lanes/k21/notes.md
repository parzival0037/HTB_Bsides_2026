# Lane K21 notes — COMPLETE (all 3 solved)

## Flags
- K21.1 FLAG{bda988856f374cc1}  <- GET /api/config (also workspace openAiPrompt)
- K21.2 FLAG{302e391567fb7188}  <- GET /api/conversations/CONV-SUP-2841-19 + Cookie fieldkest_support
- K21.3 FLAG{0613dee9e717f1e3}  <- GET /api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442 ; sources[3] ESC-SUP-2841-R3.md Audit Reference

## Golden trick
Overlay session == Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
All other auth (bearer/JWT/basic/keycloak/kerberos) -> session_required.

## Extra flags seen (other lanes' cards, NOT submitted by us)
- CONV-RILL-442-8 -> FLAG{25723607dbdb5768}
- COMP-JOB-17 -> FLAG{664724eb7d7073e9}
- staff note NOTE-SUP-2841-7 -> FLAG{3177559b5e2a80d8}
- support handover/current -> FLAG{12791115ad005ed7} (K02.3)

## Useful creds/endpoints
- rowan.ito AnythingLLM pw = fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo (also staff Basic + Keycloak admin-cli pw + Kerberos kinit pw)
- Support token fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
- maya.ranscombe pw sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk
- staff service-directory Basic -> archive_subject evan.calderoux@keplerops.test,
  enrollment_worker fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9,
  OIDC-FIELDKEST-SUPPORT; managed-identities needs Kerberos but rowan is denied.
