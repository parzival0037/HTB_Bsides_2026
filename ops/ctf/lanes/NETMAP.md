# KeplerOps / ARWC network map (verified 2026-11-20 ~18:01Z)

Everything below is reachable **from the range box** (via box.py). The range box
cannot route to 10.77.x directly — use the SOCKS5 pivot.

## Pivot (already running, supervised)

On the range box:
- tmux `relay`: keeps `python3 /tmp/s5.py 13389` alive on rowan-dev (only port
  sshd `PermitOpen` allows).
- tmux `pivot`: `ssh -N -L 0.0.0.0:1080:127.0.0.1:13389 rowan-dev`.

Use it:
```bash
curl -sS --socks5-hostname 127.0.0.1:1080 -k https://source.keplerops.test/
python3 -m pip install requests 'requests[socks]'   # then:
# requests.get(url, proxies={'https':'socks5h://127.0.0.1:1080'}, verify=False)
```
CA bundle: `/home/kali/ctf/ca.crt` (KeplerOps Range CA) — prefer
`--cacert /tmp/ca.crt`; `-k` also works. To put the CA on the box:
`/home/kali/ctf/box.py 'cat > /tmp/ca.crt' < /home/kali/ctf/ca.crt` (or echo base64).

If the pivot dies: re-run `bash /tmp/fwd.sh` / `bash /tmp/relay.sh` inside tmux, or
re-upload with the same recipe. `ssh -D` does NOT work: sshd is
`AllowTcpForwarding local` + `PermitOpen 127.0.0.1:13389`.

## Hosts (from rowan-dev /etc/hosts)

| Host | IP | What |
|---|---|---|
| source.keplerops.test, source-tools.keplerops.test | 10.77.51.20 | Gitea (source browser), fieldkest client reference :8443 |
| packages.keplerops.test | 10.77.51.30 | npm registry (rowan.ito token in ~/.npmrc) |
| ci.keplerops.test | 10.77.51.40 | Jenkins (`fieldlink-report` #1842, `fieldlink-report-review`) |
| review.keplerops.test | 10.77.51.41 | isolated report worker (`/api/jobs`) |
| preview.keplerops.test | 10.77.51.50 | preview renderer |
| indexer.keplerops.test | 10.77.51.70 | indexer |
| kerberos.keplerops.test | 10.77.50.40 | KDC realm KEPLEROPS.TEST |
| service cluster | 10.77.50.11 | workloads, objects(S3), tickets, assistant(AnythingLLM), staff, data(pg), ca, id/identity, support(osTicket), llm(Ollama), cert, cloud-api(k8s), workboard |
| connector.arwc.test | 10.77.60.20 | ARWC side (water utility) |
| rowan-dev | 10.77.50.20 / 10.77.55.2 | workstation (ssh from range box on :2222) |

## Credentials recovered on rowan-dev

- Gitea/Jenkins/report-service: `rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`
- npm: `//packages.keplerops.test/:_auth` (same fk_developer token, base64 rowan.ito:...)
- PostgreSQL: `psql service=fieldlink` → `data.keplerops.test:5432 fieldlink_data rowan_data / lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY`
- Support integration: `~/.config/fieldlink/support-client.json` (bearer `fk_support_rowan_...`, principal rowan.ito)
- Retained staff login: `maya.ranscombe / sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk`
- Kubernetes: kubeconfig service-account token, namespace `fieldlink` (`kubectl` works on rowan-dev)
- Kerberos: realm KEPLEROPS.TEST, client `kinit` available

## Service notes (work/service-notes.md, work/platform-access.md)

- Gitea API: `GET https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/{path}?ref={rev}`
- Jenkins: `/job/fieldlink-report/{n}/api/json`, `/consoleText`, `/artifact/reports/{file}`;
  `fieldlink-report-review` takes `provider.zip` via `buildWithParameters`.
- Report worker: `POST https://review.keplerops.test/api/jobs` → `GET /api/jobs/{id}`;
  client contract `https://review.keplerops.test/.well-known/fieldkest-client`.
- Review importer accepts `fieldkest.review-import/v1` JSON with `run_id` + `object` under `inputs/`.
- `report-consumer-v2` job: `{"template":"report-consumer-v2","input":{"archive_base64":"..."}}`
- Object storage: `aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports`
  (retained collections are NOT listable; exact bucket/key/digest from retained material).
- Kubernetes: `https://cloud-api.keplerops.test:6443`, context = namespace `fieldlink`;
  approved image `rancher/k3s:v1.37.2-k3s1` present on the node.
- Assistant: AnythingLLM at `https://assistant.keplerops.test`, Ollama at `https://llm.keplerops.test`.
- Support: osTicket at `https://support.keplerops.test/scp/` — SUP-2841 (ARWC connector
  callback latency), ESC-2841, REV-2841.

## rowan-dev local services

- `127.0.0.1:8701` FieldKest local helper: `curl --fail --form sample=@samples/FK-SAMPLE-017.json http://127.0.0.1:8701/api/inspection-summary`
- `127.0.0.1:13389` our SOCKS relay
- Also listening: 22, 3389 (RDP), 3350, 8701.
