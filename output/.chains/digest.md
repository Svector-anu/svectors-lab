*daily digest — 2026-09-11*

_TL;DR: patch exposed PaperCut servers, update self-hosted GitHub runners, and test whether OpenAI’s new data agent can replace a reporting workflow._

1. *Patch PaperCut now; new releases replace the emergency fixes*  
   PaperCut shipped NG/MF 26.0.5, 25.0.13, and 24.1.10 for two actively exploited flaws. At least 440 servers across 395 organizations were reportedly compromised.  
   Why it matters: patched servers may still require compromise review.  
   https://www.papercut.com/kb/Main/security-bulletin-27-aug-2026-urgent-security-advisory/

2. *Update self-hosted GitHub runners before the next brownout*  
   GitHub is blocking registration for outdated Enterprise Cloud runners today. Runtime brownouts follow September 14, 16, and 18, with full enforcement September 25.  
   Why it matters: stale runner images can leave CI jobs queued or failing.  
   https://github.blog/changelog/2026-06-12-github-actions-minimum-version-enforcement-timeline-for-self-hosted-runners/

3. *OpenAI ships a data agent for governed company data*  
   The ChatGPT Work plugin connects to approved databases, investigates changes, builds dashboards, and preserves existing row, column, and table permissions.  
   Why it matters: one reporting workflow is worth testing end to end.  
   https://openai.com/index/put-data-to-work/

4. *Positron raises $875M for memory-first AI inference*  
   Positron closed an oversubscribed round at a $5B valuation for hardware and software targeting memory-bound inference workloads.  
   Why it matters: capital is moving toward inference memory bandwidth, not only training compute.  
   https://libertyglobal.gcs-web.com/news-releases/news-release-details/liberty-global-tech-ventures-invests-ai-inference-hardware-and

## Summary

Created [digest-2026-09-11.md](/home/runner/work/svectors-lab/svectors-lab/output/digest-2026-09-11.md), updated memory and the daily log. Notification delivery was attempted but the harness’s external queues were read-only.
