# Lane K23 — FINAL REPORT (all 3 challenges SOLVED)

Submitted and accepted (event API, 2026-11-20 ~20:0xZ):
| Challenge | Flag | Endpoint / technique |
|---|---|---|
| K23.1 A context view left open (50p) | `FLAG{7ff69ab443a968ef}` | `GET https://assistant.keplerops.test/api/contexts` — **no auth**; returns the context inventory incl. `published:false` entries, top-level `flag` |
| K23.2 The conversation reference (50p) | `FLAG{25723607dbdb5768}` | `GET /api/conversations/CONV-RILL-442-8` with `Cookie: fieldkest_support=<support token>`; conversation outside SUP-2841, `tenant:"TEN-RILL-022"` |
| K23.3 A missing tenant boundary (100p) | `FLAG{4a4620cd59307eb7}` | `GET /api/contexts/ctx-rill-support-v3/conversations/CONV-RILL-442-8/documents/DOC-RILL-442` with the same cookie → `sources[0].text` = restricted `RILL-442.md`, "Document token: FLAG{4a4620cd59307eb7}" |

Scoring after: 3390 → 3540 pts, rank 16.

## Target / architecture
`https://assistant.keplerops.test` (from range box via SOCKS5 pivot 127.0.0.1:1080,
`curl -k --socks5-hostname 127.0.0.1:1080`). nginx vhost muxes two backends:

1. **AnythingLLM 1.19.0** (Express SPA, multi-user): `/api/workspaces`,
   `/api/request-token`, `/api/workspace/<slug>/...`, `/api/setup-complete`.
   Workspaces `fieldlink-operations`, `support-private` (ctx-support-private-v4),
   `rillhaven-support` (ctx-rill-support-v3). All `chatMode:"automatic"` + native
   tools → every chat swaps to the agent websocket; RAG chat unusable without
   admin/manager (workspace update 401). System prompts leak references (see below).
   Login: `POST /api/request-token {"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}`
   (also rowan.ito / `fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`).
2. **Custom "FieldKest/1.0" Python support-assistant overlay** on specific `/api/*`
   routes. Client reference: `GET /.well-known/fieldkest-client`.

### Overlay routes
```
GET  /static/app.js
GET  /api/config
GET  /api/contexts
GET  /api/conversations/{conversation_id}
GET  /api/selections/{selection_id}
GET  /api/contexts/{context_id}/conversations/{conversation_id}/documents/{document_id}
POST /api/answers
GET  /api/completions/examples/{example_id}
POST /api/completions/context
POST /api/completions/jobs
GET  /api/completions/jobs/{job_id}
POST /api/tools/accept-duplicate-review
```

### Auth trick (the key)
The overlay "session" is the retained support integration token as a **cookie**:
```
Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
```
(from rowan-dev `~/.config/fieldlink/support-client.json`; same value also works as
`Authorization: Bearer` on `support.keplerops.test:8443` and is stored as a Chromium
cookie in rowan's profile). Bearer headers, AnythingLLM JWT, Basic, Kerberos,
osTicket session all return `{"error":"session_required"}` (403).

## Data collected
Unauthenticated:
- `GET /api/config` → context `ctx-support-private-v4`, collection `support-private`,
  `answer_requests.compatibility_review` {mode query, selection SEL-SUP-2841-12},
  `answer_requests.private_escalation` {conversation CONV-SUP-2841-19,
  tenant TEN-RILL-022}, `source_selection` {attachment ATT-DIAG-698,
  selection SEL-SUP-2841-12}, completion example COMP-JOB-17, tool review DREV-2841-2,
  `flag FLAG{bda988856f374cc1}` (policy ref = K21.1, already solved).
- `GET /api/contexts` → inventory (flag `FLAG{7ff69ab443a968ef}` = K23.1):
  - ctx-support-private-v4: published:false, conversations [CONV-SUP-2841-19],
    documents **[DOC-RILL-442]**, selections [SEL-SUP-2841-12], workspace support-private
  - ctx-rill-support-v3: published:false, tenant TEN-RILL-022,
    conversations [CONV-RILL-442-8], workspace rill-support

With support cookie:
- `CONV-SUP-2841-19` → `FLAG{302e391567fb7188}` (K21.2, already solved), deleted_from_ui.
- `CONV-RILL-442-8` → `FLAG{25723607dbdb5768}` (K23.2), tenant TEN-RILL-022.
- `ctx-rill-support-v3/CONV-RILL-442-8/DOC-RILL-442` (30–45 s) → full restricted
  `RILL-442.md` in `sources[]`: Rillhaven TEN-RILL-022, asset RILL-PUMP-442,
  connector FLK-7.4.1-RILL, DIAG-RILL-MIX-08, `Document token: FLAG{4a4620cd59307eb7}`
  (K23.3).
- Cross-tenant `ctx-support-private-v4/CONV-SUP-2841-19/DOC-RILL-442` (42 s) returns
  ARWC `ESC-SUP-2841-R3.md` (two copies) + `COMP-JOB-17.md`; the 1:43:16 PM copy has
  `Completion token: FLAG{0613dee9e717f1e3}` (K21.3, already solved).
- `SEL-SUP-2841-12` → ATT-DIAG-698, case SUP-2841, tenant TEN-ARWC-047 (K22.1).
- `COMP-JOB-17` → `FLAG{664724eb7d7073e9}` (K24.1, solved), credential
  cred-completion-handover, runs as svc-assistant-completion, handover HANDOVER-COMP-2841.

## Chain logic
K23.1: the open `/api/contexts` view lists unpublished contexts and the
support-private entry's document `DOC-RILL-442` (another tenant) → flag in response.
K23.2: the retained selection/attachment from SUP-2841 points to the retained
Rillhaven conversation `CONV-RILL-442-8`, bound to tenant `TEN-RILL-022` → flag.
K23.3: use that context+conversation to pull the Rillhaven restricted document
`RILL-442.md` (tenant boundary missing: the support-private context lists it and
the document route serves it) → document token flag.

## Flags seen but NOT ours (do not resubmit)
- bda988856f374cc1 = K21.1; 302e391567fb7188 = K21.2; 0613dee9e717f1e3 = K21.3;
  664724eb7d7073e9 = K24.1.
- 599046b0487a95cb = AnythingLLM support-private "Authorization reference" —
  still unattributed (likely K22.x).
- 12791115ad005ed7 = support handover/current (K02.3); 408710d448134ab5 = K17.1;
  a56dde25afcee8cb = K17 export handover; 3177559b5e2a80d8 = staff note (K18?).

## Dead ends / operational notes
- AnythingLLM chat is a dead end: `stream-chat` ignores the request `mode` and uses
  `workspace.chatMode = automatic`; native tool calling forces the agent websocket
  `/agent-invocation/{uuid}`. No admin/manager account found; workspace update,
  `system/local-files`, `system/api-keys`, `workspace-chats` are 401 for default role.
- Filesystem agent exists but is confined to `storage/anythingllm-fs`; not needed.
- Kubernetes SA `fieldlink:rowan-workspace` can only selfreview (no pods/secrets).
- S3 `fieldlink-exports` only holds `backups/company-history.dump`.
- Overlay document route is slow (30–45 s) — use `curl -m 150`.
- Previous lane attempts had already burned 3 wrong guesses per K23 card; live API
  reset attempts (attempt 4 = correct). Pivot healthy throughout (~19:44–20:05Z).
