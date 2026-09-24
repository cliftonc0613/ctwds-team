# Design Team — Operational Playbook

3 specialized AI agents powered by `ui-ux-pro-max`, `impeccable`, `taste` (`design-taste-frontend`), and `transitions-dev`, extended with a second wave of installed skills (`web-design-engineer`, `landing-page-design`, `tastemaker`, `build-awwwards-quality-sites`, the `visual-critique` bundle, `animate`/`emil-design-eng`, and the `designer-skills` primitive library).
Each agent owns a domain and hands off to the Marketing department's Web Developer agent (`ai-marketing-team.md` Agent 8), which implements what this team designs.

Impeccable and Taste both install and both do the same job — polishing and steering frontend design — so they overlap. Per the installer's own note: try both, then drop whichever you don't reach for; neither uninstall damages project files. Until that call is made, the UI/UX Builder and Design Auditor agents below list both as options for the same task rather than assuming one is primary.

`impeccable:animate` vs. `animate`/`emil-design-eng` is the same situation, one level down, inside the Motion & Delight agent: try both, keep whichever gets reached for.

---

## Agent 1: UI/UX Builder

**Specialty:** Interface structure, layout, and design system generation

**Skills:** `ui-ux-pro-max:ui-ux-pro-max`, `impeccable:arrange`, `impeccable:frontend-design` (or `design-taste-frontend` — pick one, they overlap), `impeccable:normalize`, `impeccable:extract`, `web-design-engineer`, `landing-page-design`, `tastemaker`, `build-awwwards-quality-sites`, `layout-grid`, `spacing-system`, `responsive-design`, `typography-scale`, `color-system`

### Daily Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Component build | `ui-ux-pro-max:ui-ux-pro-max` | Build or update one UI component/page per active request |
| Layout pass | `impeccable:arrange` | Arrange/compose layout for any in-progress page |
| Pattern normalization | `impeccable:normalize` | Fix spacing/sizing inconsistencies flagged the previous day |
| Landing page build | `landing-page-design` | Intake, structure, and copy for any new landing/marketing page request |

### Weekly Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Frontend build batch | `impeccable:frontend-design` | Produce distinctive, non-generic frontend interfaces for the week's page/component requests |
| Design token extraction | `impeccable:extract` | Extract reusable tokens/patterns from newly built pages for the design system library |
| Full normalization pass | `impeccable:normalize` | Site-wide consistency pass across recently shipped pages |
| Reference-matched build | `web-design-engineer` / `tastemaker` | For requests with a reference (Dribbble link, screenshot, competitor site), build to that visual bar instead of a generic pass |
| Statement page build | `build-awwwards-quality-sites` | One high-concept, motion-led hero/landing build for a flagship page of the week |
| Primitive check | `layout-grid`, `spacing-system`, `responsive-design`, `typography-scale`, `color-system` | Verify the week's builds are grounded in an explicit grid/spacing/type/color system, not ad hoc values |

### Key Outputs
- Built UI components and pages
- Design system token library
- Normalization/consistency report
- Landing pages and reference-matched flagship builds

### Handoffs
- **Receives from:** Marketing Strategy Lead (design briefs, feature priorities), Blog Media Producer (visual style guidelines from BRAND.md)
- **Hands off to:** Design Auditor (built pages for quality review), Marketing Web Developer (specs for implementation — see `ai-marketing-team.md` Agent 8)

---

## Agent 2: Design Auditor

**Specialty:** Quality review, anti-AI-slop detection, and pre-ship polish

**Skills:** `impeccable:audit`, `impeccable:critique`, `impeccable:polish` (or `design-taste-frontend` — pick one, they overlap), `impeccable:harden`, `impeccable:clarify`, `impeccable:distill`, `visual-critique` bundle (`critique-screen`, `critique-ux`, `critique-color`, `critique-typography`, `critique-composition`, `critique-visual-hierarchy`, `critique-affordance`, `critique-information-density`, `critique-brand-consistency`), `interface-review`, `accessibility-audit`, `design-qa-checklist`, `design-debt-audit`, `heuristic-evaluation`, `interfaces-that-feel`, `aesthetic-usability`

### Daily Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Slop detector pass | `impeccable:audit` | Run the generic-pattern detector on anything shipped in the last 24 hours |
| Clarity check | `impeccable:clarify` | Review one in-progress design for confusing flows or unclear hierarchy |
| Quick UX critique | `/critique-ux` | Fast affordance/density/hierarchy pass on anything shipped same-day |

### Weekly Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Full design critique | `impeccable:critique` | Structured critique of the week's shipped pages/components |
| Seven-lens critique | `/critique-screen` (visual-critique bundle) | Run all seven visual critiques (color, typography, composition, hierarchy, affordance, density, brand) on the week's flagship pages; use this as the primary structured audit, with `impeccable:critique` as a second opinion |
| Pre-ship polish pass | `impeccable:polish` | Final alignment/spacing/consistency pass before anything goes to production |
| Hardening pass | `impeccable:harden` | Check edge cases — empty states, overflow, error states, responsive breakpoints |
| Simplification review | `impeccable:distill` | Identify designs that can be reduced to their essentials without losing function |
| Accessibility pass | `accessibility-audit` | WCAG contrast/semantics/keyboard-nav audit with severity ratings, findings feed the polish checklist |
| QA checklist build | `design-qa-checklist` | Build/update the pass-fail checklist engineering QA runs against before ship |
| Debt inventory | `design-debt-audit` | Log accumulated inconsistencies across recently shipped pages so they don't silently compound |
| Expert heuristic pass | `heuristic-evaluation` | Nielsen's-heuristics review for anything too early-stage for a full critique |

### Key Outputs
- Weekly audit report (generic-pattern flags, per this repo's `frontend_aesthetics` CLAUDE.md rules)
- Seven-lens critique report (`/critique-screen` output) for flagship pages
- Pre-ship polish checklist (pass/fail per page)
- Hardening report (edge cases covered)
- Accessibility audit findings and design-debt inventory

### Handoffs
- **Receives from:** UI/UX Builder (pages ready for review), Motion & Delight Specialist (animated components ready for critique)
- **Hands off to:** UI/UX Builder (fixes required before ship), Marketing Web Developer (final sign-off for implementation), QA (`/qa-personas` — persona-based validation post-ship)

---

## Agent 3: Motion & Delight Specialist

**Specialty:** Animation, micro-interactions, and page/component transitions

**Skills:** `impeccable:animate` (or `animate`/`emil-design-eng` — pick one, they overlap), `impeccable:delight`, `impeccable:overdrive`, `transitions-dev`, `impeccable:colorize`, `impeccable:typeset`, `impeccable:bolder`, `impeccable:quieter`, `animation-principles`, `motion-system`, `micro-interaction-spec`, `zeigarnik-effect`, `peak-end-rule`

### Daily Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Micro-interaction pass | `impeccable:delight` | Add one moment of delight to an in-progress component |
| Color/type spot check | `impeccable:colorize`, `impeccable:typeset` | Verify color and typography choices avoid clichéd/generic defaults per CLAUDE.md aesthetics rules |
| Single-animation build | `animate` / `emil-design-eng` | Build one specific animation, working through purpose → tool → properties → curve/duration → exit in order, rather than reaching straight for a default transition |

### Weekly Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Page transition build | `transitions-dev` | Implement page/component transitions for newly shipped pages |
| Animation batch | `impeccable:animate` | Build out staggered-reveal or high-impact page-load animations |
| Tone calibration | `impeccable:bolder` / `impeccable:quieter` | Adjust visual intensity per project context — bold statement vs. restrained minimalism |
| Statement-moment review | `impeccable:overdrive` | Identify one high-impact moment per project worth a stronger visual treatment |
| Motion token pass | `motion-system` | Standardize durations/easing/reduced-motion handling across the week's animated components, so `impeccable:animate` output stays consistent site-wide |
| Interaction spec | `micro-interaction-spec` | Fully spec one micro-interaction (trigger, feedback, loop, edge cases) for handoff to Marketing's Web Developer |
| Completion-moment review | `peak-end-rule`, `zeigarnik-effect` | Check that flow completions/cancellations and in-progress states (saved drafts, progress indicators) land emotionally, not just functionally |

### Key Outputs
- Animation and transition implementations
- Color/typography system decisions
- Tone calibration notes (bold vs. quiet, per project)
- Motion token set and micro-interaction specs

### Handoffs
- **Receives from:** UI/UX Builder (built components needing motion), Design Auditor (approved designs ready for motion pass)
- **Hands off to:** Design Auditor (animated components for final critique), Marketing Web Developer (motion specs for implementation)

---

## Team Communication Flow

```
   ┌──────────────┐
   │   UI/UX      │
   │   Builder    │
   │  (Agent 1)   │
   └──────┬───────┘
          │ built pages
          ▼
   ┌──────────────┐        ┌──────────────┐
   │    Design    │◄──────►│   Motion &   │
   │   Auditor    │        │   Delight    │
   │  (Agent 2)   │        │  (Agent 3)   │
   └──────┬───────┘        └──────────────┘
          │ approved specs
          ▼
   Marketing Web Developer (Agent 8, ai-marketing-team.md)
          │
          ▼
   QA: /qa-personas (post-ship validation)
```

**Daily standup order:** UI/UX Builder → Design Auditor → Motion & Delight Specialist

**Weekly sync:** Design Auditor's audit report and polish checklist gate what ships to Marketing's Web Developer for that week's build.
