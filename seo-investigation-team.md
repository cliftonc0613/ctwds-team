# SEO Investigation Team: Operational Playbook

An on-demand crew of 5 agents for answering "what do we really rank for, what changed, and why" on any site. Works for any client. Nothing here is tied to one business; client facts and rules are read from the project at run time.

**How this differs from `ai-seo-team.md`:** that file is a standing department with daily and weekly duties. This team runs when something needs investigating (a drop, a rank claim to verify, a page that will not rank) and ends with one dated report.

**Mode: investigate and report only.** The team reads, analyzes, and writes a report. It never edits site files, never changes redirects or listings, and never pushes. Fixes come back as proposals for the user to approve.

---

## How to run it

Tell the main session:

> Run the seo-investigation-team on `{domain}`: `{symptom}`

Examples of a symptom: "organic dropped, find out when and why", "verify the top 10 local keywords we rank for", "my service-area page ranks badly, find out why".

The main session runs this playbook. (Subagents cannot launch other agents, so the main session is the orchestrator.)

---

## Inputs

Ask the user only for what cannot be found in the project.

| Input | Where to look first |
|---|---|
| `domain` | the user's request, then the project's business profile file |
| OpenSEO `projectId` | `list_projects`, matched by domain |
| `target_geos` (the towns that count as local) | the business profile service area, else ask |
| `canonical_url` (https, correct host, trailing slash style) | the site itself, via the live redirect check |
| `core_terms` | the user's request, else the top ranked local terms |
| `windows` (date ranges to compare) | default last 28 days vs the 28 before, and a 90-day weekly series for drops |
| `site_repo_path` | optional; read-only use |
| `symptom` | the user's request |

---

## Step 0: Load the client's rules

Before launching anything, read these if they exist and pull out the rules that affect research or wording:

- `CLAUDE.md` and `.claude/CLAUDE.md` in the project
- the project's memory index (`MEMORY.md`) and the entries it points to
- the business profile file (for example `context/core/business-profile.json`)

Assemble one verbatim **Client Rules** block (claims not to make, words not to use, tool constraints, report folder conventions, geo scope). Pass the whole block to every agent. Agents start with no memory, so they cannot find it on their own. If nothing is found, say so and use only the defaults below.

---

## The roster

| # | Agent (`subagent_type`) | Job | Built on |
|---|---|---|---|
| 1 | `seo-rank-verifier` | Ranked keywords filtered to the target geos, cross-checked against Search Console, compared across windows | OpenSEO ranked keywords + Search Console |
| 2 | `seo-drop-forensics` | Finds the step date of a drop and gathers evidence for the cause | OpenSEO Search Console series, `inspect_urls`, read-only git and curl |
| 3 | `seo-cannibalization-checker` | Finds pages competing with each other and picks the owner | `jev-cannibalization` skill |
| 4 | `seo-profile-consistency-checker` | One canonical URL everywhere: redirects, Business Profile link, profile data, citations | OpenSEO business profile, curl, `seo-maps` NAP when available |
| 5 | `seo-report-writer` | One dated report in the project's reports folder, committed locally | the findings from agents 1 to 4 |

Agent definitions live in `seo-investigation-agents/`.

---

## Pipeline

```
Step 0  Load Client Rules + gather inputs
Step 1  Launch the agents the symptom needs, IN PARALLEL (one message):
          1 Rank Verifier       2 Drop Forensics
          3 Cannibalization     4 Profile Consistency
Step 2  Reconcile: read all findings, resolve or flag disagreements
Step 3  Launch 5 Report Writer with every findings path
Step 4  Present: the answer, what is unverified, manual steps, proposed changes
```

**Which agents to run:**

| Symptom | Agents |
|---|---|
| "What do we really rank for?" | 1 |
| "Organic dropped" | 1, 2, 4 |
| "This page will not rank" | 1, 3 |
| "Check our listings and URL consistency" | 4 |
| Full investigation | 1, 2, 3, 4 |

Always finish with agent 5.

**Findings location:** give each agent an `output_path` of the form `<scratchpad>/findings/NN-<agent>.md`, so the project folder holds only the final report.

**Reconcile (Step 2):** where two agents disagree, do not pick silently. Put both in the report and say what check would settle it.

---

## Guardrails (apply to every agent)

1. **Investigate and report only.** No edits to site or profile files, no listing changes, no pushes.
2. **OpenSEO only** for analytics and SEO data. Never substitute another tool. If it is disconnected, stop and ask the user to reconnect it, then retry.
3. **Hyper-local scope.** Filter to the target geos. Never lead with generic national terms.
4. **Cross-check before believing.** A rank-tracker number is not real until Search Console agrees. Split URL variants (http, https, www) before comparing.
5. **Label certainty.** VERIFIED or INFERRED on every claim. Say plainly what could not be checked.
6. **No cause without evidence.** "Cause unknown" is a valid finding.
7. **Anything that publishes needs the user's go-ahead,** including pushes to a site repo that deploys on push.
8. **Credits.** Ask the user before any batch over 2,000 OpenSEO credits.
9. **The report goes in a dated subfolder** (`<reports>/YYYY-MM-DD/`), is committed locally, and is never pushed.

---

## Reference requests (test cases)

Each agent should answer its requests end to end. Placeholders: `{domain}`, `{primary town}`, `{canonical page}`, `{competing page}`, `{step date}`.

| # | Agent | Request |
|---|---|---|
| T1 | 1 | List the top 10 `{primary town}`-area keywords `{domain}` ranks for, then cross-check each against Search Console and say which are real. |
| T2 | 1 | Are we ranking for `{service} near me`? |
| T3 | 1 | Compare `{window A}` to `{window B}`. Did we get better or worse? |
| T4 | 2 | Pull a weekly series for the core terms on `{canonical page}` and tell me when organic started slipping. |
| T5 | 2 | Check Search Console and the site repo for any coverage, canonical or redirect change around `{step date}`. |
| T6 | 2 | Check for pages that showed up as 404s around `{step date}`. |
| T7 | 3 | Does `{competing page}` compete with `{canonical page}` for `{primary town}` terms? Which should own them? |
| T8 | 4 | Does the Business Profile website link use `http://`? What should it be, and how do I change it? |
| T9 | 5 | Save the findings to a dated report and commit it. |

**What a pass looks like:** T1 returns a table with a Ranking Page column and a verdict per keyword. T4 names a step date, or says there is none. T6 states that the API cannot show 404 history and gives the manual Search Console steps. T8 names who can change the link.

---

## Out of scope (always manual or separate)

- Applying redirects, template, or content changes in the site repo
- Changing a Business Profile or third-party listing
- Pushing, merging, or syncing branches
- Standing daily and weekly SEO duties (see `ai-seo-team.md`)

---

## Install

The agent files live in `seo-investigation-agents/` so they can be committed with this repo. Claude Code loads agents from `.claude/agents/`, which this repo ignores. To use them, link or copy the five files:

```bash
# Global (available in every project)
mkdir -p ~/.claude/agents
ln -s "$(pwd)/seo-investigation-agents/"*.md ~/.claude/agents/
```

Requirements: the `openseo-selfhost` MCP server connected; for agent 3, the `jev-cannibalization` skill and an OpenRouter key; for agent 4's citation check, the `seo-maps` skill with DataForSEO or Apify connected (optional).
