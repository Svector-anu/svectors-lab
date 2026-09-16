---
type: Reference
repo: amirh00sain/SpiderPanel
severity: high
cwe: CWE-918
status: auto-send-ready
auto_send: true
human_only: false
operator_approved_at: 2026-09-16T13:00:00Z
contact_email: amirshaianfar@outlook.com
email_subject: "SpiderPanel follow-up — unauthenticated HTTP proxy permits SSRF and proxy abuse"
detected_at: 2026-09-16T12:00:00Z
related_disclosure: amirh00sain-SpiderPanel-2026-08-25.md
audited_commit: d8554ecbb4d0c099b87ab50835da683d02730840
---

<!-- EMAIL-BODY-START -->
Hi Amir,

This is a separate follow-up to my August 25 SpiderPanel report. During a fresh review I found an unauthenticated HTTP proxy endpoint that appears to permit both public proxy abuse and server-side requests to internal services. I did not test it against any live deployment.

## Finding: unauthenticated arbitrary-method proxy / SSRF (High)

`main.py` registers the following public route without `Depends(require_auth)`:

```python
@app.api_route("/proxy/{target_url:path}", methods=["GET","POST","PUT","DELETE","PATCH","HEAD","OPTIONS"])
async def http_proxy(target_url: str, request: Request):
    if not target_url.startswith("http"):
        target_url = "https://" + target_url
    body = await request.body()
    headers = {k: v for k, v in request.headers.items()
               if k.lower() not in _HOP and k.lower() != "host"}
    resp = await http_client.request(
        method=request.method,
        url=target_url,
        headers=headers,
        content=body,
    )
```

The shared `http_client` is initialized with `follow_redirects=True`. I found no application-wide authentication middleware, scheme allowlist, destination-IP validation, DNS pinning, redirect revalidation, or response-size limit around this route.

### Attacker prerequisites

Only network access to a deployed panel is required. The attacker does not need a panel session or the admin password.

### Impact

- Use the deployment as an unauthenticated forward proxy for arbitrary HTTP methods and bodies.
- Reach services available from the panel's network context, including loopback, RFC1918/link-local addresses, and potentially cloud metadata endpoints where the hosting platform exposes them.
- Bypass a first-hop host check through redirects because the client follows redirects and there is no destination validation on either hop.
- Consume outbound bandwidth and memory because the response is buffered with `resp.content` and no explicit size cap.

### Safe local verification

Run SpiderPanel only in an isolated local environment with a mock HTTP listener bound to loopback. Request `/proxy/http://127.0.0.1:<mock-port>/probe` without a session cookie. The mock listener receives the request and SpiderPanel returns its response. This demonstrates the missing trust boundary without contacting any third-party or live internal service.

### Suggested remediation

1. If this endpoint is not required, remove it.
2. Otherwise require `Depends(require_auth)` and add rate limiting.
3. Allow only `http` and `https`; reject userinfo, ambiguous URLs, and all loopback, private, link-local, multicast, reserved, and unspecified destinations after resolving every A/AAAA result.
4. Disable automatic redirects, or validate and pin every redirect destination before connecting.
5. Apply connection, request-body, response-size, and total-time limits; stream rather than buffering unbounded responses.
6. Consider a strict destination allowlist if the feature only needs known upstreams.

I am keeping this private and can help review a patch. Please let me know when it is safe to retest locally.

— Anu (Svector Lab)
<!-- EMAIL-BODY-END -->
