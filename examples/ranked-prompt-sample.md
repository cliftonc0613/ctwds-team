# ranked-prompt.md — DRY RUN (not published)

**Topic:** Small business website cost
**Target keyword:** small business website cost
**Assumed business:** CT Web Design Shop (assumed from the ctwds-team repo — confirm)
**Data source:** OpenSEO (DataForSEO not connected). Project: "Default" (no domain set).
**Dry-run status:** Draft not written. Not published.

---

## Data pulled (K inputs)

| Keyword | Volume (US) | KD | CPC | Intent |
|---|---|---|---|---|
| small business website cost | 210 | 23 | $15.30 | commercial |
| website design cost for small business | 90 | 20 | $17.66 | commercial |
| small business website design cost | 90 | 20 | $17.66 | commercial |
| cost to create a website for a small business | 50 | 22 | $17.22 | commercial |
| ecommerce website cost | 320 | 15 | $15.14 | commercial |
| shopify website cost | 590 | 28 | $8.57 | commercial |
| how to make a website for a small business | 720 | 74 | $26.80 | informational |
| how do i create a website for my small business | 140 | 74 | $29.39 | informational |
| best website builder for small business | 260 | 24 | $52.75 | commercial |

**Caution:** The seed "small business website redesign cost" returned no "redesign cost" terms. Results drifted to Shopify and e-commerce. The result was marked `usedFallback: true`, so treat these figures as approximate.

**SERP for "small business website cost" (top organic):** comboapp.com, quora.com, namecheap.com, equinode.net, squarespace.com, mesmerdesign.ca, hubspot.com, mailchimp.com, shopify.com, aarlow.com. Most top results are cost guides with price ranges. Several are agency or software vendors.

**Price ranges quoted across top results (for the content to beat):**
- Custom professional build: about $1,500–$7,000 (mesmerdesign.ca); $2,000–$15,000 (HubSpot); $2,000–$10,000 (viserx)
- Basic agency build: $500–$3,000+ (aarlow.com)
- DIY/builder: under $20–$60/mo (Squarespace, Beck Digital)
- Wide range: $500–$35,000 (equinode.net)

**Gaps:** People Also Ask and fan-out queries were NOT returned. The SERP shows a PAA block, but OpenSEO gave no items. Flag this in the output. Do not invent questions.

---

## [R] Role
Senior SEO content strategist and web-design pricing writer for CT Web Design Shop, writing for small business owners who are comparing quotes.

## [A] Audience & Aim
- **Reader:** small business owners (non-technical) weighing a DIY builder against a designer or agency.
- **Aim:** help them estimate realistic cost, and show what drives the price. Earn a consultation, not a hard sell.
- **Search intent:** commercial investigation (price comparison). Lead with a direct answer.

## [N] Non-negotiables
- Answer the cost question in the first 60 words, with a realistic range and the factors that move it.
- Give ranges, not single figures. State the year and currency (USD) and say prices vary by scope.
- No invented statistics. Any price or figure must have a source. Use Tier 1–3 sources from the research packet; if none supports a claim, cut it.
- E-E-A-T: write from a practitioner's view, with concrete scope examples (page count, e-commerce, booking, SEO setup). Do not claim years of experience or client counts unless the brand file confirms them.
- Brand voice: **BRAND.md and VOICE.md were not found in ctwds-team.** Use plain, direct, non-hype language until those files are supplied. Flag this.
- No fluff, no "in today's digital world" openers, no AI-detectable filler.
- Length: 1,200–2,000 words.
- Include a clear CTA to a free quote or consultation, once near the top and once at the end.

## [K] Keyword & Data
- **Target keyword:** small business website cost (210/mo, KD 23, CPC $15.30)
- **Secondary keywords (use naturally in H2s):** website design cost for small business; cost to create a website for a small business; how to make a website for a small business (720/mo, KD 74, informational)
- **Real questions:** none returned by the data source. Use only the questions visible in the research packet, or write headings from the topic itself, and flag them as "not validated."
- **Competitor angle:** most top results publish one price range and stop. Beat them with a line-item breakdown (design, content, hosting, SEO, maintenance) and a decision guide.
- **Data source to state in the output:** OpenSEO (DataForSEO not connected).

## [E] Examples
- Match the structure of the strongest top-ranking cost guides (HubSpot, Mailchimp), but add a worked example with a sample small business and a line-item estimate.
- Beat them on: clarity of ranges, cost drivers, and a "what you get at each price" table.

## [D] Deliverable
A markdown blog post for the CT Web Design Shop blog, with:
1. Frontmatter: title (≤60 characters), meta description (150–160 characters), slug `small-business-website-cost`, date placeholder, author placeholder.
2. One H1 with the target keyword, then answer-first intro (60 words max with the direct range).
3. H2 sections in this order: cost ranges by approach (DIY, template designer, custom agency); what drives the price; line-item breakdown table; what's included at each price; hidden/ongoing costs (hosting, domain, maintenance, SEO); how to choose; FAQ (3–5 questions, marked up as an FAQ block; questions must be validated, see [K]).
4. Closing CTA.
5. Below the post, a short "Data notes" block listing: data source (OpenSEO), keyword metrics used, the PAA gap, and the BRAND.md/VOICE.md gap.
6. No images or charts in this step (Media Producer handles those).

Output format: markdown only, no preamble.
