---
name: keyword-cannibalization-checker
description: Use to check whether a site's own pages compete against each other for the same query — service pages, location pages, service+location combo pages, the homepage, and blog posts all included. Builds a full page inventory, finds exact title/meta duplicates, clusters pages by target keyword and intent, then cross-checks against real ranked-keyword data to tell confirmed cannibalization apart from healthy hub-and-spoke overlap. Pairs with the 5-skill SEO system (run after keyword-fanout-map and internal-link-architect). Use for cannibalization, "are my pages competing with each other", duplicate title tags, or when a page won't rank despite good content.
---

# Keyword Cannibalization Checker

Publishing volume is good until two of your own pages start fighting each other
for the same query — Google splits authority between them and both rank worse
than one focused page would. This skill finds those pairs, and just as
importantly, tells them apart from pages that only *look* similar because they
share an entity (same service, same town) but target genuinely different intent.
That second case is a normal, healthy hub-and-spoke structure. Flagging it as a
problem is the most common false positive in this kind of audit — don't make it.

## Before you start

**Read `site-brief.md`** for the domain, the money pages, and the site's URL
architecture (which page types exist: services, locations, combo pages, blog).
Without it you'll guess at which pages are "the same type" and miss the real
structure.

**A DataForSEO connector is preferred but not required.** It's what turns this
from a title-tag audit into a confirmed-cannibalization audit — see Step 3. If
there's no connector, or the site is pre-launch/newly-launched with almost no
ranking history, say so plainly and run Steps 1-2 only (see Honesty rules).

## Input

The domain, plus however the page inventory is available:

- A live site: crawl it (see Step 1).
- A codebase you have direct read access to (an in-progress or pre-launch
  client site): read the source/build output directly — this is often faster
  and more accurate than a crawl, and it's the right call whenever you're
  already working inside the client's repo rather than auditing a URL from
  outside.

## Process

### Step 1 — Build the full page inventory

Every indexable page, with: URL, `<title>`, meta description, H1, and page
*type* (homepage / service / location / service+location combo / blog post /
other).

- Live site: `/sitemap.xml` first; if it returns HTML instead of XML, that's a
  finding on its own. Fall back to `on_page/task_post` (full crawl) or
  `on_page/pages` (already-crawled site). Use `on_page/content_parsing` for H1
  and body-topic extraction. Match tools by description, not by assumed name.
- Local codebase: for a static/templated site, find the page-type templates
  (e.g. `[slug].astro`, `[area]/[slug].astro`, or the CMS equivalent) and read
  their title/meta-generation logic directly — this tells you the *intended*
  targeting pattern for an entire page type in one read, instead of crawling
  every instance. Then confirm against a handful of actual built/rendered
  pages. For blog posts, read the frontmatter of every post.

Exclude: tag/category archives, paginated archives, thank-you pages, noindex
pages.

State how many pages you inventoried and how (crawl vs. source read).

### Step 2 — Exact-duplicate detection

Group pages by exact `<title>` text, then by exact meta description text.

Any group with more than one URL is a **confirmed** cannibalization pair — no
further evidence needed. This should be rare on a well-built site; if you find
none, say so plainly rather than padding the report by lowering the bar.

### Step 3 — Cluster by target keyword and intent, then cross-check with real rankings

For every page, infer its primary target keyword and intent
(`informational` / `commercial` / `transactional` / `navigational` — same
taxonomy as `keyword-fanout-map`). Group pages that share both:

- the same **entity** (same service, same location, same specific topic), AND
- the same **intent**

That's a candidate pair. A shared entity with *different* intent (e.g. a blog
post explaining a topic vs. a transactional service page selling it) is the
normal hub-and-spoke pattern — note it as a candidate but don't flag it yet.

Now pull real evidence for every candidate pair, if a connector is available:

- `dataforseo_labs/google/ranked_keywords` (or the domain/page-level
  ranked-keywords tool available) for the domain, filtered to the candidate
  pages' likely queries.
- Check: does Google already rank **two or more of the client's own URLs**
  for the same query? That's the strongest possible confirmation.
- Also check `serp/google/organic` for the specific candidate query if the
  domain has too little history for the ranked-keywords tool to show anything
  yet (common on new sites) — see if a dual-ranking pattern shows up there
  instead.

### Step 4 — Classify every candidate

- **Confirmed** — exact title/meta duplicate (Step 2), OR two+ owned URLs
  already ranking for the same query (Step 3 SERP evidence).
- **Watch** — same entity, differentiated intent, no SERP evidence of actual
  competition. This is architecture worth noting, not a problem worth fixing.
  Most hub-and-spoke sites (service page + service/location combo + blog post
  on the same topic) will produce several of these, and that's fine.
- **Dismiss** — surface-level topic overlap with no shared entity or intent
  (e.g. two blog posts that both mention a shared service in passing). Don't
  list these as findings; they're noise.

### Step 5 — Recommend a fix for every Confirmed pair

Pick one, specific to the pair, not a generic "differentiate your content":

- **Merge + 301** — when both pages target the identical query with no
  meaningful angle difference. Keep the stronger page.
- **Re-target one page** — when one page can legitimately own a different,
  adjacent keyword instead (name the keyword).
- **Differentiate the angle** — when both pages should exist but currently
  read too similarly (e.g. both are generic; one should go informational, one
  transactional). Say exactly what to change in the weaker page's title, H1,
  and opening paragraph.
- **Canonical tag** — when one page is a legitimate near-duplicate for a
  technical reason (e.g. a filtered/paginated variant) rather than a content
  decision.

## Output

**`06-cannibalization-report.html`** — fill
`templates/cannibalization-report.html.template`.

Build a `data.json` and render it:

```
python3 scripts/render.py templates/cannibalization-report.html.template data.json 06-cannibalization-report.html
```

`data.json` shape:

```json
{
  "tokens": { "PAGES_SCANNED": 136, "CONFIRMED_COUNT": 0, "WATCH_COUNT": 2, "...": "..." },
  "rows": {
    "EXACT_DUP_ROW": [{ "ROW_TITLE": "...", "ROW_URLS": "...", "..." }],
    "CONFIRMED_ROW": [{ "ROW_PAGE_A": "...", "ROW_PAGE_B": "...", "ROW_QUERY": "...", "ROW_EVIDENCE": "...", "ROW_FIX": "..." }],
    "WATCH_ROW": [{ "ROW_PAGE_A": "...", "ROW_PAGE_B": "...", "ROW_SHARED_ENTITY": "...", "ROW_WHY_OK": "..." }]
  }
}
```

Notes on tokens:
- `ROW_SEVERITY_CLASS` on confirmed rows is `fail`. Watch rows use `warn`.
- If `CONFIRMED_COUNT` is 0, set `CONFIRMED_EMPTY_DISPLAY` to `block` and
  `CONFIRMED_TABLE_DISPLAY` to `none`. A clean result is a real, useful
  finding — display it as one, don't bury it.
- `DATA_NOTES` must state: how the inventory was built (crawl vs. source
  read), how many pages, and whether SERP cross-check (Step 3) ran at full
  strength or was skipped/limited due to thin ranking history. A pre-launch
  or newly-launched site with almost no tracked keywords means Confirmed
  findings can only come from Step 2 (exact duplicates) — say that plainly
  rather than implying a full SERP-based audit ran.

## Honesty rules

- **A near-miss is not a finding.** The single biggest failure mode for this
  skill is flagging every page that shares a service or a town with another
  page. Only Confirmed pairs (Step 4) are findings; Watch pairs get their own
  section so the user can see the reasoning, not a false alarm.
- **Don't fabricate SERP evidence.** If the connector has too little ranking
  history to confirm or deny a candidate pair, say "not enough ranking data
  yet" — never infer competition from title similarity alone and call it
  confirmed.
- **Zero confirmed pairs is a real, good result.** Report it as a pass, not as
  "audit inconclusive."
- Quote the actual titles/URLs for every row. Never paraphrase a title tag.

## Handing off

> If any pair came back Confirmed, fix it, then re-run `internal-link-architect`
> on both pages — a differentiated page still needs the right internal links
> pointing at it for the new targeting to stick.
>
> If the SERP cross-check in Step 3 was skipped or thin because the site is
> new, re-run this skill once `ai-visibility-checker` or the domain's ranked
> keywords show real history — a Watch pair today can turn into a Confirmed
> pair once the site actually has traffic to fight over.
