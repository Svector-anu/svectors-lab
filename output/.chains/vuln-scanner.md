⚠️ vuln-scanner disclose blocked

## vuln-scanner disclose — send blocked

tried to send the armed medium disclosure for **ZSvirt/zsvirt** → `security@zsvirt.io`.

- **status:** Resend `403` — `svector.xyz` domain is not verified ([resend.com/domains](https://resend.com/domains))
- **from:** `anu@svector.xyz`
- **subject:** Security: core module pins Spring Security 5.7.13 with a known authorization-bypass CVE
- **draft:** `memory/pending-disclosures/ZSvirt-zsvirt-2026-08-23.md` (still `pending-operator-send`, `send_attempts: 1/3`)
- **gates that passed:** armed, MX ok (3× Aliyun), secret-tripwire clean, cooldown ok, EMAIL-BODY plain text, budget 1 unused

same block as SpiderPanel on 2026-08-25 (that one went out manually via Gmail). verify the domain in Resend, or send this one manually from `svector.anu@gmail.com`. CRITICAL sibling draft stays `human_only` — do not auto-arm.

eligible backlog: 1 medium (this), blocked on Resend domain.