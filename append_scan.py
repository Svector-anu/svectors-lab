import json
p = "/home/runner/work/svectors-lab/svectors-lab/memory/vuln-scanned.json"
d = json.load(open(p))
d.append({
    "repo": "RyanCodrai/turbovec",
    "scanned_at": "2026-08-22T06:15:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": (
        "Rust quantized vector index (16.2k stars, PVR enabled + SECURITY.md real disclosure channel). "
        "semgrep=ok 0 findings (security-audit+secrets). osv=ok via public OSV batch API on Cargo.lock (55 crates): "
        "1 hit paste 1.0.15 RUSTSEC-2024-0436 UNMAINTAINED-warning only, no patched version exists, build-time transitive "
        "proc-macro dep -> non-actionable, no dep-bump PR possible. trufflehog=skip (binary exec denied this session); "
        "compensated with manual secret grep -> 0 hardcoded literals (17 keyword-hit files all GHA secrets.* refs or "
        "env-based test tokens). Manual malformed-input audit of the stated attack surface (crafted .tv/.tvim bytes per "
        "SECURITY.md): io_v7.rs load_image/parse_header_at every field via bounds-checked .get(), n validated vs file_len "
        "before sizing, n_units<=MAX_OPS, block idx <n/BLOCK and lane<BLOCK checked before scales[slot]/ids[slot] indexing, "
        "checked_mul on offsets, superblock+delta CRC; convert.rs read_legacy n_vectors bounded by bytes.len()/5 before any "
        "arithmetic; par_copy.rs FFI set_len only after full write; search.rs query len validated (lib.rs:1364) before unsafe "
        "SIMD, prefetch guarded by pf+64<=len. Repo ships extensive adversarial test suite. ~4 candidate classes reviewed, 0 confirmed."
    ),
})
json.dump(d, open(p, "w"), indent=1)
print("appended; entries now:", len(d))
