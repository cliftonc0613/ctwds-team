---
name: openseo-batch-audit
description: Run a full-site OpenSEO Self-hosted crawl audit on a large site (500+ pages) by splitting it into sitemap-driven batches instead of one run_site_audit call. Use when a site audit fails with errorCode "cpu_limit", when the user wants to "audit the full site", "pull the whole sitemap", "run X pages", or names a page count near/above the site's total URL count, or when a single-shot audit on a large programmatic/local-SEO site (city×service pages, large blogs) needs to finish reliably.
---

# OpenSEO Batch Audit

The self-hosted OpenSEO worker (`open-seo-selfhost.hello-ca6.workers.dev`) enforces a
Cloudflare Workers CPU-time budget per invocation. A single `run_site_audit` call on a
large site (2,000+ pages) gets killed mid-crawl with `errorCode: "cpu_limit"` — it will
report partial `pagesCrawled` but the run itself is marked `"failed"` and its issues are
unusable. `run_site_audit` crawls same-origin from one start URL; it does not accept a
URL list, so batching means picking start URLs that bias the crawl toward different
sections of the site, run sequentially, one audit at a time.

This is the exact process worked out live on the KwiKey Locksmith DE audit (2,490-page
site, single-shot crawl died at 2,125/2,490 with `cpu_limit`).

## Step 1 — Get the projectId

```
list_projects
```

Match by domain. If the site isn't a project yet, offer to `create_project` first —
don't guess an ID.

## Step 2 — Pull the sitemap and map the URL split

Don't ask the user to describe their site structure — fetch it.

```bash
curl -s "https://<domain>/sitemap-index.xml" -o /tmp/sitemap-index.xml
```

If it 404s, try `/sitemap.xml` directly (some sites don't use an index). Parse out
every `<loc>` child sitemap URL, `curl` each one, and count `<loc>` entries per file:

```bash
grep -o "<loc>" /tmp/sitemap-child.xml | wc -l
```

Sum the counts and confirm the total roughly matches what the user asked to crawl
(e.g. "run 2490" should match the sitemap total — if it doesn't, say so before
proceeding).

For the largest sitemap (usually the programmatic/local-SEO one), break down the URL
list by path segment to find natural batch boundaries:

```bash
grep -o "<loc>[^<]*</loc>" /tmp/sitemap-child.xml | sed 's/<[^>]*>//g' > /tmp/urls.txt
sed -E 's|https://<domain>/||' /tmp/urls.txt | awk -F/ '{print $1}' | sort | uniq -c | sort -rn
```

Go one level deeper (`$1"/"$2`) if the top-level split is too coarse or too uneven.
The goal is category groupings whose page counts are each safely under the CPU
ceiling — in practice **keep every batch at or under ~1,300 pages**; the ~1,300-page
batch in the reference run completed clean, the ~2,490-page single-shot run did not.

## Step 3 — Propose the batch plan before running anything

Show the user a table: batch name, what it covers, start URL, and page count. Get
implicit or explicit go-ahead (a plain "run it" / "run 3" confirming a plan you just
showed counts as go-ahead) before spending crawl time. Example shape from the
reference run:

| Batch | Content | Start URL | Pages |
|---|---|---|---|
| 1 | Core site (home, services, service-areas, blog, utility) | `/` | 114 |
| 2 | Residential + Emergency city pages | `/services/residential/` | 1,296 |
| 3 | Commercial + Automotive city pages | `/services/commercial/` | 1,080 |

Note for the user: because `run_site_audit` crawls same-origin (not scoped to a
subtree), a batch's start URL biases discovery order toward that section but the
crawler can still wander into pages another batch already covered — some overlap
across batches is normal and fine, it does not need to be de-duplicated by hand.

Set each batch's `maxPages` slightly above its target count (small margin, e.g.
+a few percent) so the crawl isn't truncated mid-section.

## Step 4 — Run batches sequentially, never concurrently

Never fire multiple `run_site_audit` calls in parallel for the same project — that's
what stresses the worker's CPU budget in the first place.

For each batch, in order:

1. `run_site_audit(projectId, url: <batch start URL>, maxPages: <batch cap>)`
2. Poll `get_audit_status(projectId, auditId)` until `status` is `"completed"` or
   `"failed"`. Use `ScheduleWakeup` between polls (don't busy-poll) — 90–180s
   intervals are reasonable for batches in the hundreds-to-low-thousands range.
3. On `"completed"`: report `pagesCrawled`/`pagesTotal`, then start the next batch.
4. On `"failed"` with `errorCode: "cpu_limit"`: don't silently retry at the same
   size. Report the failure and `pagesCrawled` to the user, and propose splitting
   that batch in half before continuing — ask rather than guessing a new cap.

Track all `auditId`s as you go; you need every one of them for Step 5.

## Step 5 — Pull findings, with a fallback for empty issues

Try the built-in issues endpoint first, per batch:

```
get_audit_issues(projectId, auditId, limit: 1000)
```

**Known gap:** in the reference run, `get_audit_issues` returned `{summary: [],
issues: []}` for every batch despite `get_audit_pages` showing real per-page data
(titles, meta descriptions, word counts, status codes) for the same audits. If this
happens — completed audit, non-trivial `pagesCrawled`, but empty issues — don't
report "zero issues found." Say plainly that the issues endpoint came back empty
and pull `get_audit_pages(projectId, auditId, limit: 1000)` instead (paginate with
`urlContains` filters by section if `total` exceeds the 1000-row cap) to derive
findings by hand: missing/duplicate titles, missing/duplicate meta descriptions,
thin word counts, non-200 status codes, missing H1s where the field is present.

Before flagging any page as broken/erroring from `fetchClass: "error"` or
`statusCode: 0`, spot-check a couple of those URLs with a direct `curl` — in the
reference run these turned out to be sitemap-discovered-but-not-yet-fetched
placeholders (budget-truncated queue entries), not real site errors. Don't report
a page as broken without that direct verification.

## Step 6 — Combined summary

Once every batch is done, report as one picture, not three: total pages crawled
across all batches, total vs. the sitemap's actual URL count (call out any gap),
and issues merged and de-duplicated by URL where the same page appeared in more
than one batch. Lead with critical/severity-flagged findings, then counts by issue
type.
