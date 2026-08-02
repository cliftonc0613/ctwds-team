---
name: weekly-seo-report
description: Generate a styled weekly or monthly SEO progress report for any local business client, as either an editorial print-style PDF (HTML + PDF) or an interactive dark-theme HTML dashboard (HTML only, no PDF). Auto-reads the project's tracking file (knowledge/tracking/*.md) and business profile (context/core/business-profile.json). Use this skill whenever the user says "generate weekly report", "generate monthly report", "create the weekly/monthly PDF", "make this week's/month's report", "weekly progress report", "generate a report", or wants to document backlinks, citations, blog content, or SEO audit findings for a client period. Always ask which report style the user wants (PDF editorial report or HTML dashboard report) before generating — do not assume. Each style has its own STANDARD design system below — do not deviate from either one's color palette, typography, or component structure.
---

# SEO Report Generator

Produces a professional SEO progress report for a client, covering either a week or a full month. Files are saved to `knowledge/reports/`.

There are two report styles. Always ask the user which one they want before generating (unless they've already specified):

1. **PDF editorial report** — navy/orange, print-ready, multi-page, signature page. Best for client-facing deliverables that get printed or emailed as a formal document. Generates both an `.html` and a `.pdf`.
2. **HTML dashboard report** — dark theme, tabbed, interactive. Best for a report the client or team browses on screen. HTML only — do not generate a PDF for this style (the tabbed interactivity doesn't carry over, and it isn't the point of this format).

Both styles support weekly or monthly cadence — the only difference is the date range and which section headers say "week/next week" vs. "month/next month's priorities."

**Every link is clickable.** Any URL that appears in a report — live blog post URLs, backlink placement URLs, citation listing URLs, the client's website — must be a real `<a>` tag, never plain text. Always open in a new tab: `<a href="[url]" target="_blank" rel="noopener noreferrer">`. This applies to both formats: table cells, content-item URLs, and prose mentions alike. Don't leave a URL as bare text just because it's inside a `<td>`, `<span>`, or `<p>` — wrap it.

---

## Step 1: Gather data

Read these files in parallel:

- **`context/core/business-profile.json`** — client name, city, website, phone
- **Most recent `knowledge/tracking/YYYY-MM-prospecting.md`** and **`knowledge/tracking/YYYY-MM-links.md`** — completed `[x]` / logged items (backlinks, citations) and pending `[ ]` items

From the tracking file, extract:
- All items placed/submitted in the report period (backlinks, citations)
- Monthly targets (e.g., "10 backlinks + 10 citations")
- Counts: how many completed vs. target for backlinks, citations, blog posts
- Pending/skipped items (items with notes like "skipped", "blocked", "pending")

If `knowledge/reports/seo-audits/` or other audit files exist for the period, read them.

Ask the user for anything the files don't cover:
- Weekly or monthly report, and the exact date range (e.g., "May 25 – May 31, 2026" or "June 1–30, 2026")
- Which report style: PDF editorial or HTML dashboard
- Blog posts written this period (title + status)
- Any content published (Medium posts, press releases, LinkedIn)
- SEO audit scores and key findings (if no audit files exist)
- Next period's priorities and pending items
- If there's a gap in placements/activity versus the target, ask whether there's a business-side reason not captured in the tracking file (site rebuild, staffing change, holiday, client delay) — frame the gap around that reason rather than leaving it unexplained

---

## Filenames

- Weekly, PDF editorial style: `knowledge/reports/YYYY-MM-DD-weekly-report.{html,pdf}` (date = last day of the week)
- Monthly, PDF editorial style: `knowledge/reports/YYYY-MM-DD-monthly-report.{html,pdf}` (date = last day of the month)
- Weekly, HTML dashboard style: `knowledge/reports/YYYY-MM-DD-weekly-dashboard-report.html` (HTML only, no PDF)
- Monthly, HTML dashboard style: `knowledge/reports/YYYY-MM-DD-monthly-dashboard-report.html` (HTML only, no PDF)

Generate both the `.html` and the `.pdf` for the PDF editorial style. For the HTML dashboard style, generate only the `.html` file — skip the PDF step entirely.

---

## Format A: PDF Editorial Report

A 5-6 page navy/orange print-ready report.

### Design system

```css
:root {
  --navy: #1b2645;
  --orange: #e07830;
  --orange-light: #f5e8da;
  --text: #1a1a2e;
  --muted: #888899;
  --light-bg: #f7f7f5;
  --border: #e8e8e8;
  --white: #ffffff;
}
```

**Typography:**
```html
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,400;1,700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
```
- Body: Inter, 9.5pt
- Display headings (h1, h2 em): Playfair Display italic, navy or orange
- Labels: Inter uppercase, letter-spacing 0.18–0.2em, 7–8pt

**Page layout:**
```css
* { margin: 0; padding: 0; box-sizing: border-box; }

.page {
  padding: 0.55in 0 0.2in;
  page-break-after: always;
}
.page:last-child { page-break-after: avoid; }

@page { size: 8.5in 11in; margin: 0; }
@page content-page {
  size: 8.5in 11in;
  margin: 0 0.65in 0.45in 0.65in;
  @bottom-left {
    content: "AgencyName  ·  agency@email.com";
    font-family: 'Helvetica Neue', sans-serif;
    font-size: 7.5pt;
    color: #888899;
  }
  @bottom-right {
    content: "Week of [DATE RANGE]";
    font-family: 'Helvetica Neue', sans-serif;
    font-size: 7.5pt;
    color: #888899;
  }
}
@page cover-page { size: 8.5in 11in; margin: 0; }

.page { page: content-page; }
.cover { page: cover-page; }
```

---

### Page 1 — Cover

```html
<div class="page cover">
  <div>
    <div class="cover-eyebrow">[Agency Name] <span style="color:var(--orange)">—</span> Weekly SEO Report</div>
  </div>
  <div class="cover-main">
    <h1 style="font-family:'Playfair Display',serif;font-size:52pt;font-weight:700;color:white;line-height:1.05">
      Weekly<br>Progress<br><em style="font-style:italic;color:var(--orange);display:block">Report.</em>
    </h1>
    <div style="width:38px;height:3px;background:var(--orange);margin:0.35in 0 0.25in"></div>
    <div style="font-size:10.5pt;color:rgba(255,255,255,0.75);line-height:1.6;max-width:4in">
      A complete snapshot of SEO activity, backlinks placed, citations submitted, and content published for [Client Name].
    </div>
    <div style="font-size:8pt;color:rgba(255,255,255,0.4);margin-top:6pt;letter-spacing:0.05em">Week of [DATE RANGE]</div>
  </div>
  <div style="display:flex;justify-content:space-between;align-items:flex-end;border-top:1px solid rgba(255,255,255,0.12);padding-top:0.2in">
    <div style="font-size:8pt;color:rgba(255,255,255,0.4)">
      <strong style="color:rgba(255,255,255,0.7);display:block;font-size:9pt">[Client Name]</strong>
      [City, State] · [website] · [phone]
    </div>
    <div style="display:flex;gap:28pt;text-align:right">
      <!-- One .cover-kpi div per KPI -->
      <div>
        <div style="font-family:'Playfair Display',serif;font-size:32pt;color:var(--orange);font-weight:700;line-height:1">[N]</div>
        <div style="font-size:7.5pt;color:rgba(255,255,255,0.4);text-transform:uppercase;letter-spacing:0.1em">Backlinks</div>
      </div>
      <!-- Repeat for Citations and Blog Posts -->
    </div>
  </div>
</div>
```

For a monthly report, swap "Weekly Progress Report." for "Monthly Progress Report." and "Week of [DATE RANGE]" for the month's full date range.

**Critical:** The cover must use `min-height: 11in` so the navy fills the full page in both the browser and PDF:
```css
.cover {
  background: var(--navy);
  color: white;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 0.7in 0.75in;
  min-height: 11in;
}
```

---

### Page 2 — Weekly/Monthly Summary

Page header (on every content page):
```html
<div class="page-header" style="display:flex;justify-content:space-between;align-items:center;padding-bottom:10pt;margin-bottom:22pt;border-bottom:1.5px solid var(--orange)">
  <div style="font-size:8pt;color:var(--muted)">[Client] · [Month Year]</div>
  <div style="font-size:7.5pt;color:var(--orange);text-transform:uppercase;letter-spacing:0.15em;font-weight:600">Weekly Summary</div>
</div>
```

**At-a-glance cards** — one per tracked metric (backlinks, citations, blog posts). Color the card border by status:
- On track (≥70% of target): `border-left: 3px solid #2ecc71`
- At risk (30–69%): `border-left: 3px solid var(--orange)`
- Behind (<30%): `border-left: 3px solid #e74c3c`

```html
<div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12pt;margin-bottom:24pt">
  <div style="background:var(--light-bg);padding:12pt 14pt;border-left:3px solid var(--orange)">
    <div style="font-size:7pt;text-transform:uppercase;letter-spacing:0.15em;color:var(--orange);font-weight:600;margin-bottom:4pt">Backlinks</div>
    <div style="font-size:26pt;font-family:'Playfair Display',serif;font-weight:700;line-height:1;color:var(--navy)">
      [N] <span style="font-size:13pt;color:var(--muted);font-family:Inter,sans-serif;font-weight:400">/ [Target]</span>
    </div>
    <div style="font-size:8pt;color:var(--muted);margin-top:4pt">[status note]</div>
  </div>
  <!-- repeat for citations, blog -->
</div>
```

**Backlinks table:**
```html
<table style="width:100%;border-collapse:collapse;font-size:8.5pt">
  <thead>
    <tr style="border-bottom:1.5px solid var(--navy)">
      <th style="text-align:left;padding:5pt 8pt 5pt 0;font-size:7pt;text-transform:uppercase;letter-spacing:0.1em;color:var(--muted)">Date</th>
      <th ...>Platform</th>
      <th ...>Anchor Text</th>
      <th ...>Status</th>
    </tr>
  </thead>
  <tbody>
    <!-- one row per backlink -->
  </tbody>
</table>
```

Status badge styles:
```css
.status-live    { background:#e8f8f0; color:#27ae60; padding:2pt 7pt; border-radius:2px; font-size:7pt; font-weight:600; text-transform:uppercase; letter-spacing:0.08em; }
.status-written { background:#fff3e0; color:#e07830; padding:2pt 7pt; ... }
.status-pending { background:#f0f4ff; color:#3a5ccc; padding:2pt 7pt; ... }
.status-skipped { background:#f5f5f5; color:#888; padding:2pt 7pt; ... }
```

---

### Page 3 — Citations & Content

Same page header pattern (section: "Citations & Content").

**Citations table** — same column structure as backlinks table (Date, Directory, Listing URL, Status).

**Content list** — one item per piece of content published or drafted in the period:
```html
<div style="display:flex;align-items:flex-start;gap:10pt;padding:8pt 0;border-bottom:1px solid var(--border)">
  <div style="background:var(--navy);color:white;font-size:6.5pt;font-weight:600;text-transform:uppercase;letter-spacing:0.1em;padding:3pt 7pt;border-radius:2px;white-space:nowrap">[TYPE]</div>
  <div>
    <strong>[Title]</strong>
    <span style="display:block;font-size:8pt;color:var(--muted);margin-top:1pt">[URL or status note]</span>
  </div>
</div>
```

Tag background colors by type: Blog → navy, Medium → `#00ab6c`, Press Release → `#c0392b`, LinkedIn → `#0077b5`.

For a monthly report, add a "Why the Month Fell Short/Met Target" block here if there's a gap or blocker to explain (see Step 1's business-context question) — a table or callout naming the blocker, its impact, and status.

---

### Page 4 — SEO Audits

Only include this page if audit data exists. If no audits were run in the period, skip this page entirely.

Each audit row uses a colored left border based on score:
- High (≥65): `border-left: 3px solid var(--orange)`
- Mid (40–64): `border-left: 3px solid #e0a030`
- Low (<40): `border-left: 3px solid #e74c3c`

```html
<div style="display:flex;align-items:flex-start;gap:14pt;padding:10pt 0 10pt 12pt;border-bottom:1px solid var(--border);border-left:3px solid var(--orange);margin-bottom:6pt">
  <div style="font-size:22pt;font-family:'Playfair Display',serif;font-weight:700;color:var(--navy);line-height:1;min-width:36pt">[SCORE]</div>
  <div>
    <div style="font-size:9pt;font-weight:600;color:var(--navy)">[Audit Name]</div>
    <div style="font-size:8.5pt;color:var(--muted);margin-top:2pt">[Key finding]</div>
  </div>
</div>
```

Follow with a numbered action list of the top 5 developer fixes.

---

### Page 5 — Next Week/Month

Two-column layout:

**Left column — Pending Follow-Ups:**
List each pending item with its site name, note, and status badge.

**Right column — Month-to-Date Progress:**
Progress bars for each tracked metric:
```html
<div style="display:flex;align-items:center;gap:10pt;margin-bottom:8pt">
  <div style="font-size:8pt;font-weight:500;width:70pt">[Metric]</div>
  <div style="flex:1;background:var(--border);height:8pt;border-radius:4pt">
    <div style="width:[PCT]%;height:8pt;border-radius:4pt;background:var(--orange)"></div>
  </div>
  <div style="font-size:8pt;color:var(--muted);white-space:nowrap">[N] / [Target]</div>
</div>
```

End with a risk/status callout box:
```html
<div style="background:var(--orange-light);border-left:3px solid var(--orange);padding:10pt 12pt;border-radius:2px;font-size:8.5pt;line-height:1.6;margin-top:8pt">
  <strong style="color:var(--navy)">[Status headline]</strong><br>
  [1–2 sentences on what needs to happen to hit the period's targets]
</div>
```

---

### Page 6 — Signature Page

The final page. Use flex column with `justify-content: space-between` so the footer branding pins to the bottom.

```html
<div class="page" style="min-height:11in;display:flex;flex-direction:column;justify-content:space-between">
  <div>
    <div class="page-header">...</div>  <!-- section: "Client Authorization" -->

    <div class="section-label">Service Confirmation</div>
    <h2>Acknowledgment<br><em>of services.</em></h2>

    <p style="font-size:9.5pt;line-height:1.8;max-width:5.5in;margin-bottom:28pt">
      By signing below, the client confirms receipt of this progress report and
      acknowledges the SEO services described herein were delivered for the period of
      <strong>[DATE RANGE]</strong>, including backlink placements, directory citations,
      content creation, and site audits performed on behalf of <strong>[Client Name]</strong>.
    </p>

    <!-- Single signature block — client only -->
    <div style="margin-top:0.4in;max-width:3.5in">
      <div style="font-size:7pt;text-transform:uppercase;letter-spacing:0.18em;color:var(--orange);font-weight:600;margin-bottom:32pt">Client Signature</div>
      <div style="border-bottom:1.5px solid var(--navy);margin-bottom:8pt;height:1pt"></div>
      <div style="font-size:8pt;color:var(--muted)">Signature</div>
    </div>
  </div>

  <!-- Pinned footer -->
  <div style="border-top:1px solid var(--border);padding-top:14pt;display:flex;justify-content:space-between">
    <div style="font-size:8pt;color:var(--muted)">[Agency] · [email]</div>
    <div style="font-size:8pt;color:var(--muted)">Week of [DATE RANGE]</div>
  </div>
</div>
```

Each signature block has three lines: Signature, Printed Name, Date — each a `border-bottom: 1.5px solid var(--navy)` line followed by an 8pt muted label.

---

## Format B: HTML Dashboard Report

A dark-theme, tabbed, interactive report. Reference examples: `knowledge/reports/2026-06-22-weekly-link-report.html` (weekly) and `knowledge/reports/2026-06-30-monthly-link-report.html` (monthly) — read one of these directly for exact markup rather than reconstructing from scratch, and copy its CSS/JS verbatim.

### Design system

```css
:root {
  --bg: #0a0a0f; --bg-card: rgba(255,255,255,0.03); --bg-card-hover: rgba(255,255,255,0.06);
  --border: rgba(255,255,255,0.08); --border-hover: rgba(255,255,255,0.15);
  --text: #e8e8ed; --text-secondary: #8b8b9e; --text-muted: #5a5a6e;
  --accent: #6366f1; --accent-glow: rgba(99,102,241,0.3);
  --green: #22c55e; --green-bg: rgba(34,197,94,0.12); --green-border: rgba(34,197,94,0.25);
  --yellow: #eab308; --yellow-bg: rgba(234,179,8,0.12); --yellow-border: rgba(234,179,8,0.25);
  --red: #ef4444; --red-bg: rgba(239,68,68,0.12); --red-border: rgba(239,68,68,0.25);
  --blue: #3b82f6; --blue-bg: rgba(59,130,246,0.12);
  --orange: #f97316; --orange-bg: rgba(249,115,22,0.12); --orange-border: rgba(249,115,22,0.25);
  --purple: #a78bfa; --purple-bg: rgba(167,139,250,0.08); --purple-border: rgba(167,139,250,0.15);
  --radius: 16px; --radius-sm: 10px; --radius-xs: 6px;
}
```

**Typography:** Space Grotesk (headings/numbers), Inter (body), JetBrains Mono (URLs/code) via Google Fonts `@import`.

**Structure:** header with pulsing status dot → score-circle KPI section (SVG ring + sub-scores grid) → sticky tab bar → 6 tab panels, one active at a time via `switchTab()`. Keep the `@media print` block that hides the tabs and forces all `.tab-content` to `display: block !important` — it costs nothing and means the file still prints cleanly if the client opens it in a browser and hits print, even though this skill doesn't generate a PDF for this format itself.

### Tab structure (adapt names to weekly vs monthly)

| # | Weekly tab name | Monthly tab name | Content |
|---|---|---|---|
| 1 | Executive Summary | Executive Summary | Score circle, stats-grid KPIs, key-findings card, top 3 priorities as `.action-item`s |
| 2 | Backlinks | Backlinks | stats-grid + progress-row + `.page-table` of placements, plus a "planned/blocked" card |
| 3 | Citations | Citations | Same structure as Backlinks, for directory submissions |
| 4 | Content & Blockers | Content & Blockers | `.content-item` list of published/drafted content, then `.finding` cards for each active blocker |
| 5 | SEO Audit | SEO Audits | `.finding` cards per audit score category, then a `.checklist-item` list of top developer fixes |
| 6 | Next Week | July/[Next Month] Priorities | `.action-item`s grouped by urgency (Critical/High/Medium in red/orange/purple `.section-title` headers), then a progress-bar summary card |

Reuse these existing component classes verbatim (defined in the reference files): `.header`, `.header-badge`, `.score-section`, `.score-circle`, `.sub-scores`, `.tabs`, `.tab-btn`, `.tab-content`, `.stats-grid`, `.stat-card`, `.card`, `.badge-critical/high/medium/low/pass/warning/fail`, `.finding` (+ `.finding-status.pass/warning/fail`), `.page-table`, `.checklist-item` (+ `.check-icon.pass/fail/warn`), `.action-item` (+ `.action-number`), `.content-item` (+ `.content-tag`), `.progress-row`/`.progress-bg`/`.progress-fill`.

Content tag background colors by type: Blog → `#5a5a6e`, Medium → `#00ab6c`, Press Release → `#c0392b`, LinkedIn → `#0077b5`.

The score circle's `stroke-dashoffset` maps to the overall score out of 100 (dasharray is fixed at 502): `dashoffset = 502 - (502 * score / 100)`. Color the ring `var(--red)` below 40, `var(--yellow)` 40–64, `var(--accent)`/`var(--green)` at 65+.

For a monthly report, merge multiple audits run during the month into one Executive Summary / SEO Audits tab rather than duplicating tabs per audit, and add a "root cause" `.finding-rec` block in Content & Blockers summarizing why any target was missed.

---

## Step 2: Generate the PDF (Format A only)

For the PDF editorial report, after saving the HTML immediately run:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless \
  --print-to-pdf="[absolute path]/knowledge/reports/[filename].pdf" \
  --no-pdf-header-footer \
  --print-to-pdf-no-header \
  "[absolute path]/knowledge/reports/[filename].html"
```

Use absolute paths for both the input HTML and output PDF.

For the HTML dashboard report, skip this step — save only the `.html` file.

Report the byte count and confirm the file(s) created — both for Format A, just the HTML for Format B.

---

## Output summary

Tell the user:
- Which style was generated (PDF editorial or HTML dashboard) and the cadence (weekly/monthly)
- HTML saved to: `knowledge/reports/[filename].html`
- PDF saved to: `knowledge/reports/[filename].pdf` — Format A only; omit this line for Format B
- Page/tab count and key numbers (backlinks, citations, blog posts captured)
