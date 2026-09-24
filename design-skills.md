# Design Skills Reference

4 sources from the `design` group in `install-claude-company-os.sh`: `ui-ux-pro-max`, `impeccable`, `taste` (`design-taste-frontend`), `transitions.dev`. Plus a second wave of skills installed manually from external repos — see [Second Wave](#second-wave--manually-installed) below.

Impeccable and Taste both install and both target the same job — polishing and steering frontend design — so they overlap. The installer's own note: try both, then drop whichever you don't reach for; neither uninstall damages project files. Until you've made that call, treat them as two competing options for the same agent role rather than two agents.

---

## 1. UI/UX Foundation
- `ui-ux-pro-max:ui-ux-pro-max` — Full UI/UX design system generation and component work

## 2. Impeccable — Structure & Layout
- `impeccable:arrange` — Layout and composition
- `impeccable:frontend-design` — Distinctive, production-grade frontend interfaces; avoids generic AI aesthetics
- `impeccable:normalize` — Normalize inconsistent spacing/sizing/patterns
- `impeccable:extract` — Extract design tokens/patterns from existing work

## 3. Impeccable — Quality & Review
- `impeccable:audit` — Detector pass — flags generic/AI-slop patterns
- `impeccable:critique` — Structured design critique
- `impeccable:polish` — Final quality pass: alignment, spacing, consistency before shipping
- `impeccable:harden` — Production-hardening pass (edge cases, robustness of the UI)
- `impeccable:clarify` — Improve clarity of a design or flow
- `impeccable:distill` — Simplify/reduce a design to its essentials

## 4. Impeccable — Style & Tone
- `impeccable:colorize` — Color system work
- `impeccable:typeset` — Typography system work
- `impeccable:bolder` — Push a design toward a stronger, more confident visual statement
- `impeccable:quieter` — Pull a design back toward restraint/minimalism
- `impeccable:adapt` — Adapt an existing design system to a new context

## 5. Impeccable — Motion & Delight
- `impeccable:animate` — Motion and animation design
- `impeccable:delight` — Micro-interactions and moments of surprise
- `impeccable:overdrive` — High-impact, statement motion/visual treatment

## 6. Impeccable — Performance & Onboarding
- `impeccable:optimize` — Performance optimization of the implemented design
- `impeccable:onboard` — Onboarding flow design
- `impeccable:teach-impeccable` — Teach the Impeccable design system approach to a team/project

## 7. Taste — Alternative Frontend Design Skill
- `design-taste-frontend` — Frontend design steering and polish (`Leonxlnx/taste-skill`). Overlaps `impeccable:frontend-design`/`impeccable:polish` — same job, competing approach.

## 8. Motion Library
- `transitions.dev` — Page and component transitions (`Jakubantalik/transitions.dev`)

---

## Second Wave — Manually Installed

Installed directly from external GitHub repos (not via `install-claude-company-os.sh`), one skill/repo at a time, into `~/.claude/skills/` globally. Grouped here by the same agent-domain lens as `ai-design-team.md`.

### 9. Build — Structure & Layout (UI/UX Builder domain)
- `web-design-engineer` (`ConardLi/garden-skills`) — polished browser-rendered artifacts (pages, dashboards, prototypes, decks) with a 25-entry style-recipe library (Linear, Stripe Press, Vercel Mesh, Apple HIG, Dieter Rams/Braun, etc.) and a browser-acceptance/QA reference
- `landing-page-design` (`elayadesign/ai-design-skills`) — full landing-page system: intake questions, page structure, layout selection, conversion copywriting, SEO, plus strict visual rules
- `tastemaker` (`codeswithroh/tastemaker`) — anti-"AI slop" UI generation matched to brand/reference input; large skill with its own scripts (palette extraction, contrast checking, motion auditing, icon/photo fetching) and a nested `ideagram` illustration sub-skill
- `build-awwwards-quality-sites` (`MengTo/Skills`) — art-directs and implements cinematic, motion-rich marketing/portfolio sites: GSAP choreography, smooth-scroll, optional Three.js/shaders, original reference-inspired imagery
- `video-to-superprompt` (`MengTo/Skills`) — turns a reference video into a detailed recreation/inspiration prompt (UI, animation, scroll interactions, typography, colors covered section by section)
- `web-technique-to-skill` (`MengTo/Skills`) — turns a technique you already built into a reusable, demo-verified web-design skill
- Primitives from `designer-skills` (`Owl-Listener/designer-skills`, `ui-design` bundle): `layout-grid`, `spacing-system`, `responsive-design`, `typography-scale`, `color-system`, `dark-mode-design`, `data-visualization`, `platform-conventions`, `illustration-style`, `icon-system`, plus the Gestalt-law skills (`law-of-proximity`, `law-of-similarity`, `law-of-common-region`, `law-of-continuity`, `law-of-closure`, `law-of-figure-ground`) and `von-restorff-effect`, `aesthetic-usability`

### 10. Review — Quality & Critique (Design Auditor domain)
- `visual-critique` bundle (`Owl-Listener/designer-skills`) — 7 single-lens critique skills plus 2 orchestrating commands:
  - `critique-color`, `critique-typography`, `critique-composition`, `critique-visual-hierarchy`, `critique-affordance`, `critique-information-density`, `critique-brand-consistency`
  - `/critique-screen` — runs all seven, outputs a prioritized fix list
  - `/critique-ux` — focused pass (affordance, density, hierarchy only)
- `interface-review` (`jakubkrehel/skills`) — general single-pass UI review agent; lighter-weight alternative to the seven-lens bundle
- From `designer-skills` (`design-systems`/`prototyping-testing`/`design-ops` bundles): `accessibility-audit`, `design-qa-checklist`, `design-debt-audit`, `heuristic-evaluation`, `interfaces-that-feel`

### 11. Motion & Delight
- `animate` (`emilkowalski/skills`) — builds one animation at a time, in decision order: should it animate → purpose → tool → properties → curve/duration → interruption/exit; includes a `RECIPES.md` reference. Competes with `impeccable:animate` — try both, keep one.
- `emil-design-eng` (`emilkowalski/skills`) — Emil Kowalski's broader philosophy on UI polish, component design, animation decisions, and invisible detail; pairs with `animate`
- From `designer-skills` (`interaction-design` bundle): `animation-principles`, `motion-system`, `micro-interaction-spec`, `zeigarnik-effect`, `peak-end-rule`, plus the Laws-of-UX interaction set (`fitts-law`, `hicks-law`, `millers-law`, `teslers-law`, `jakobs-law`, `doherty-threshold`, `serial-position-effect`)

### 12. Copy & Layout Utilities
- `better-writing` (`jakubkrehel/skills`) — product copy improvement; likely better suited to the Marketing team's copy work than this Design team, but installed and available
- `better-layout` (`jakubkrehel/skills`) — grouping, alignment, reading order, progressive disclosure

### 13. Design-Ops / Research / Strategy (not wired into the 3-agent team)
The remaining ~90 skills from `Owl-Listener/designer-skills` (`design-research`, `ux-strategy`, `design-ops`, `designer-toolkit`, `prototyping-testing` bundles — personas, journey maps, sprints, stakeholder alignment, case studies, etc.) were installed globally but are **not** assigned to an agent in `ai-design-team.md`. They're UX-research/design-ops territory, out of scope for the current build → audit → motion pipeline. Available if a research-focused 4th agent gets stood up later.

Also installed: 42 slash commands from `designer-skills` into `~/.claude/commands/` (e.g. `/design-screen`, `/handoff`, `/tokenize`, `/start-here`), covering end-to-end workflows across all the bundles above.

---

## Related Existing Tools

This repo already has adjacent design coverage worth cross-referencing instead of duplicating:
- `page-layout` skill
- `stitch-design`, `stitch-loop` skills (Google Stitch UI generation)
- `taste-design` skill — separate from `design-taste-frontend` above; a Semantic Design System skill for Google Stitch. Confirm which one is meant before invoking — names are easy to confuse.
- `shadcn-ui`, `vercel:shadcn` skills — component library implementation
- `dataviz` skill — chart/dashboard-specific design system
