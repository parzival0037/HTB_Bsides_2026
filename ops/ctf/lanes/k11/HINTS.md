# Unlocked hints (already paid for)

### K11.1: Where the policy begins (100p)
  - Read work/build-operations/policy-compiler-handoff.md on the developer workstation. It directs you to the fieldkest/policy-compiler repository in Gitea (source.keplerops.test). Clone it; the repository website field points to the client reference on source-tools.keplerops.test:8443 where the evaluation route is listed.
  - The retained binary is an unstripped ELF; binary analysis with nm reveals the eight fieldkest_opcode_XX_NAME symbols. Search the binary for the FKPC magic bytes (the embedded 68-byte program table, 14 four-byte instructions). Trace the PUSH_FIELD opcodes by index to identify the four evaluated fields — tenant_state (0), connector_api (1), signer_lineage (2), compatibility_exception (3).
  - Build a fieldkest.policy-program-model/v1 with the 68-byte program base64-encoded and its sha256. Submit it to the policy-compiler evaluation route on source-tools.keplerops.test with operation=corpus-check and the corpus_id from the README. The service returns a PCMIG receipt with program_sha256 and condition_set_sha256.

### K11.2: Learn its instructions (200p)
  - The fieldkest/policy-compiler repository README describes each fragment's policy intent in the Fragments section. No .fkpc bytecode is provided — the participant must assemble each fragment. Use the FKPC encoding from K11.1 (magic plus header plus 4-byte instructions). PUSH_FIELD operand is field index 0-3; PUSH_CONST is constant index; IN_SET is set index; each set and constant value is in the README.
