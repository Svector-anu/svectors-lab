## Summary

Two independently confirmed issues found during a security audit of `NousResearch/hermes-agent` at commit `6327930` (2026-09-03):

1. **HIGH — DOM-based HTML/script injection via remote bot display names** (verified with an executable reproduction)
2. **MEDIUM — a live, TruffleHog-verified Algolia API key committed with broader-than-intended ACL scope**

---

## 1. DOM injection via `blobMarkup` attribute breakout (HIGH)

**Location:** `apps/desktop/src/plugins/hermes-bots/avatar.tsx:212`

```js
return blobatarSvg(seed, opts).replace('<svg ', '<svg data-bot-face=' + JSON.stringify(name) + ' ')
```

**Impact.** `name` here is `entry.from.name` — for a *remote* speaker in a group chat (per the code's own comment: "Remote speakers have no local meta and get the deterministic face for their name"), this is attacker-controlled: a party in a shared/group chat can set their bot's display name to arbitrary text. That name is concatenated into raw SVG markup with `JSON.stringify`, then rendered via `dangerouslySetInnerHTML` in `BotFace` (used from `group-chat-view.tsx`).

`JSON.stringify` escapes a literal `"` as the two characters `\` + `"`, but HTML attribute parsing does not understand that backslash escape — it terminates the quoted attribute at the first literal `"` it sees, backslash or not. A name like:

```
x"><img src=x onerror=alert(1)><svg x="
```

closes the `data-bot-face` attribute (and the `<svg>` tag itself) early, and everything after becomes real sibling markup — including a live `<img onerror=...>` element that fires immediately once inserted via `innerHTML`.

**Proof (reproduced locally, not merely reasoned about).** A Node.js harness extracted this exact expression verbatim from the shipped file, ran it with the real `JSON.stringify`/string-replace logic and a stub `blobatarSvg`, and parsed the resulting markup with `jsdom` (the same DOM-insertion path `dangerouslySetInnerHTML`/`innerHTML` uses):

- Benign name (`"Assistant"`) → renders safely inside the attribute, 0 injected elements (negative control).
- Malicious name (`x"><img src=x onerror=window.__X__=1><svg x="`) → produces exactly 1 live `<img onerror="window.__X__=1">` element as a direct sibling in the rendered DOM — confirmed via `querySelectorAll('img[onerror]')` and `parentElement` checks.

This demonstrates a genuine DOM XSS reachable from a remote/untrusted chat participant's bot name, executing in the Electron desktop app's renderer.

### Verification
- Reproduced locally: yes
- Command: a standalone Node.js script that imports the literal vulnerable expression from `apps/desktop/src/plugins/hermes-bots/avatar.tsx` (regex-extracted, not reimplemented), exercises it with a benign control and a malicious `name`, and parses the output with `jsdom`
- Before (attacker-controlled name `x"><img src=x onerror=window.__AEON_POC_XSS__=1><svg x="`): renders as `<svg data-bot-face="x\"><img src=x onerror=window.__AEON_POC_XSS__=1><svg x=\"" ...>` — HTML parses this as a truncated `<svg>` tag followed by a live `<img onerror>` element
- After (suggested fix): escape `name` for HTML-attribute context (e.g. encode `"`, `<`, `>`, `&`) before the string concatenation, or avoid string-built markup entirely and set the attribute via DOM APIs (`setAttribute`) after parsing the trusted SVG, rather than concatenating untrusted text into an HTML string
- Environment: Node.js v22, `jsdom` (standalone, same HTML-parsing behavior class as Chromium's `innerHTML` parser)

**Suggested fix.** Don't build HTML by string-concatenating untrusted text. Either HTML-attribute-escape `name` before inserting it (escape `"`, `&`, `<`, `>`), or parse the trusted `blobatarSvg` output first and then set `data-bot-face` via `setAttribute()` on the resulting element, which handles escaping correctly by construction.

---

## 2. Live Algolia key with broader-than-documented ACL (MEDIUM)

**Location:** `website/docusaurus.config.ts:105`

```ts
algolia: {
  appId: '2JLBVEYZN5',
  apiKey: '8fda2a49223ce185ac30c2dbf6898a07',
  ...
}
```

The preceding comment states this is a "public search-only" key, "safe to commit." TruffleHog's verified-secret check (which actually authenticates against the Algolia API, not just pattern-matches) confirms this key is **live** and its ACL is:

```
browse, listIndexes, search, settings
```

`settings` is not part of a pure search-only key — it permits modifying index configuration (ranking rules, synonyms, facets, etc.), which is more than the comment claims. This doesn't grant account-wide admin, but it's broader than "search-only," and a key with `settings` ACL could be used to degrade or redirect docs search results.

**Suggested action.** Confirm whether `settings` ACL is intentional; if not, rotate this key in the Algolia dashboard and issue a strictly `search`-only key for client-side use (Algolia's standard pattern for public DocSearch keys).

### Verification
- Reproduced locally: yes — TruffleHog `filesystem --only-verified` scan against the audited commit confirmed the key authenticates
- Command: `trufflehog filesystem <clone> --only-verified --json`
- Before: key present in `website/docusaurus.config.ts:105`, live, ACL `browse,listIndexes,search,settings`
- After: rotate the key in the Algolia dashboard; issue a `search`-only replacement
- Environment: TruffleHog 3.97.4

---

## Detected by

Automated scan (Semgrep OSS `p/security-audit`+`p/owasp-top-ten`+`p/secrets`, TruffleHog `--only-verified`, osv-scanner, and a manual source-to-sink review) run by Aeon (https://github.com/aeonframework/aeon). Both findings above were individually confirmed by hand — the DOM injection was verified with an executable reproduction (not merely a scanner hit), and the secret finding is TruffleHog's authenticated verification, not a pattern match.

Happy to share the PoC harness for finding 1 privately if useful for your own regression test.
