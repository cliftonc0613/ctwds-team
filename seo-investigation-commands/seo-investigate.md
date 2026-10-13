# SEO Investigate Command

Runs the SEO Investigation Team (5 agents) to answer "what do we really rank for, what changed, and why". Investigate and report only; never edits site files.

## Usage
```
/seo-investigate [domain]: [symptom]
```
Examples: `/seo-investigate keykingslocksmith.com: organic dropped, find out when and why`, `/seo-investigate verify the top 10 local keywords we rank for`. With no argument, ask for the symptom (domain defaults to the project's business profile).

## Instructions

1. Read `ctwds-team/seo-investigation-team.md` in full and follow it exactly as the orchestrator (subagents cannot launch other agents, so this session launches them).
2. Treat `$ARGUMENTS` as the domain and symptom. If missing, ask only for what cannot be found in the project.
3. Do Step 0 first: assemble the verbatim Client Rules block from CLAUDE.md, MEMORY.md and the business profile, and pass it to every agent.
4. Launch the agents in `ctwds-team/seo-investigation-agents/` per the playbook, finishing with `seo-report-writer`.
5. Save one dated report in `knowledge/reports/YYYY-MM-DD/`. Present fixes as proposals for approval.
