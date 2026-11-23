# Unlocked hints (already paid for)

### K02.1: The missing fixture (50p)
  - Begin with the retained source history and the continuous-integration review workflow. The failing-job note identifies a repository revision, so the removed fixture should be sought in version history rather than the current tree.
  - This stage is version-history recovery. Keep the named revision and fixture path bound together; the provider contract is a separate build artifact.
  - Compare the revision in the failing-job note with the repository history, then inspect the change that removed the named fixture without restoring unrelated files.

### K02.2: An input outside its lane (50p)
  - Inspect the native Jenkins build page and its separately archived artifacts. The console is only one part of the retained build record.
  - Match the review note to the failed build and source revision before using its provider contract. Reading an artifact does not grant repository write or job configuration access.
  - Compare the exact fixture path and revision in REVNOTE-1842 with the native source history and inspect the file parameter on fieldlink-report-review.

### K02.3: Green, with our changes (100p)
  - Use the native Jenkins fieldlink-report-review job and its provider.zip file parameter. The original fieldlink-report job is the retained failing baseline.
  - This is interface validation. Preserve the fixture's exact file bytes and immutable fields while implementing the documented provider extension point. A valid package is different from an accepted changed report.
  - Compare the native build artifacts with the support handover. The job ID and report digest must identify the same fresh output; a green status by itself is insufficient.
