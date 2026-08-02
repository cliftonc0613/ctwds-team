# SEO Skills Reference

24 skills from the `/seo` content engine — dual-optimized for Google rankings and AI search visibility.

Sections 9-12 below are 12 additional standalone skills with no marketplace of their own. They're bundled in this repo under `skills/seo/` and installed with `bash install-claude-company-os.sh --only seo`.

---

## 1. Auditing

- `audit <url>` — Full site audit: 9 parallel AI agents, 0-100 health score, prioritized improvements
- `technical <url>` — Technical deep dive across 9 categories: crawlability, indexability, security, mobile, Core Web Vitals, structured data
- `page <url>` — Single page deep analysis: titles, meta descriptions, headings, internal linking
- `content <url>` — E-E-A-T content assessment per 2025 Google Quality Rater Guidelines

## 2. Schema & On-Page Structure

- `schema <url>` — Detect, validate, and generate JSON-LD schema.org markup against Google's supported types
- `sitemap <url>` — XML sitemap validation, generation, and HTTP status verification
- `images <url>` — Image optimization: alt text, file size, WebP/AVIF format recommendations

## 3. AI Search & Visibility

- `geo <url>` — GEO/AEO optimization for Google AI Overviews, ChatGPT, Perplexity, and Bing Copilot
- `sxo <kw> <url>` — Search experience optimization via SERP-backward analysis
- `flow [stage] <url>` — 41 evidence-led AI prompts across Find, Leverage, Optimize, and Win stages (FLOW framework)

## 4. Local & Maps

- `local <url>` — Google Business Profile audit, NAP consistency, review sentiment, citations
- `maps <url>` — Geo-grid rank tracking, GBP profile audits, competitor radius mapping

## 5. Content & Competitor Strategy

- `plan <type>` — Industry-specific strategic planning with competitive analysis and content pillars
- `competitor-pages` — Generate comparison and "alternatives to X" pages
- `programmatic` — Large-scale programmatic SEO with quality gates and automation
- `cluster <seed>` — SERP-overlap topic clustering with hub-and-spoke architecture
- `ecommerce <url>` — Product schema, Google Shopping visibility, and pricing intelligence

## 6. International SEO

- `hreflang <url>` — hreflang validation, international SEO audit, and cross-domain support

## 7. Monitoring & Data

- `drift baseline <url>` — Git-style SEO monitoring with SQLite baselines and 17 comparison rules
- `backlinks <url>` — Free backlink audit with toxic link detection (Moz, Bing Webmaster, Common Crawl)
- `google [cmd] <url>` — Google API integrations: Search Console, PageSpeed Insights, CrUX, GA4, Indexing API

## 8. Extensions

- `dataforseo [cmd]` — Live SERP, keyword, and backlink data via DataForSEO MCP
- `image-gen <desc>` — AI image generation for OG previews and infographics via Google Gemini
- `firecrawl [cmd]` — Full-site crawling with JavaScript rendering

## 9. AI-Citation Content Pipeline (5-Skill System)

Five skills designed to chain in order — seed keyword to AI-citation tracking.

- `keyword-fanout-map <seed>` — **Step 1.** Turns a seed keyword/business type/topic into an intent-clustered keyword map with real search volume, AI search volume, and the fan-out questions a page must answer
- `seo-content-writer <brief>` — **Step 2.** Writes a blog post, article, service page, or product page built to rank and to be cited by AI search engines, using the keyword map from Step 1 and brand voice from `site-brief.md`
- `onpage-optimizer <url>` — **Step 3.** Detects blog vs. service/product page, applies the matching checklist, and rewrites title tag, meta description, headings, and schema
- `internal-link-architect <url>` — **Step 4.** Crawls existing pages and returns exactly which pages should link to the target (and vice versa) with anchor text and placement sentence; also finds orphan pages and maps topic clusters
- `ai-visibility-checker <url>` — **Step 5.** Checks whether a site is cited/mentioned in ChatGPT, Gemini, Google AI Overviews, and Perplexity, benchmarks against competitors, and produces a gap list of queries it should own but doesn't
- `keyword-cannibalization-checker <url>` — **Companion** (run after Steps 1 and 4). Builds a full page inventory, finds duplicate titles/metas, clusters pages by target keyword/intent, and cross-checks against ranked-keyword data to separate confirmed cannibalization from healthy hub-and-spoke overlap

## 10. Competitive Intelligence

- `competitor-analysis <competitor-url>` — Analyze one competitor's organic footprint: ranking keywords, content themes, backlinks, and gaps
- `competitive-landscape <niche>` — Map SEO market leaders across a niche: winning content themes, keyword coverage, backlinks, and strategic gaps

## 11. Reporting & Outreach

- `weekly-seo-report` — Generate a styled weekly/monthly SEO progress report as an editorial print-style PDF or interactive dark-theme HTML dashboard; auto-reads project tracking files and business profile
- `link-prospecting <niche>` — Find link prospects, discover contact paths, and draft outreach from SERPs and backlink signals

## 12. Setup & Alternatives

- `seo-project-setup` — Set up a durable local SEO workspace: project context, notes, goals, positioning, preferences, MCP checks, and Search Console data intake
- `seo-strategy <article-or-site>` — Dual-mode skill: Mode 1 optimizes a single article/page for SEO; Mode 2 runs a full-website audit. Overlaps with `audit`/`page` — evaluate before replacing them
