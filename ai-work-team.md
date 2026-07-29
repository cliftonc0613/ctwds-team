# Work Team — Operational Playbook

3 specialized AI agents powered by `anthropics/knowledge-work-plugins` (`small-business`, `legal`, `finance`).
Each agent owns a domain and runs agency-internal duties — this team supports the agency itself and its client engagements, rather than producing client-site deliverables like the Marketing/Blog/SEO/Ads teams.

> **Note:** Skill names below were verified against the installed `knowledge-work-plugins` marketplace (`legal`, `finance`, `small-business`). Several original placeholder names (`agreement-drafting`, `proposal-drafting`, `engagement-letter`, `budget-tracking`, `invoicing`, `client-scoping`, `operations-review`, `terms-and-policies`, `cash-flow-forecast`, `profitability-analysis`) do not exist as installed skills — they've been mapped to the closest real skill, flagged where no close match exists.

---

## Agent 1: Legal & Compliance Agent

**Specialty:** Contract review, compliance, and agreement drafting

**Skills:** `legal:review-contract`, `legal:compliance-check`, `legal:triage-nda`, `legal:signature-request`, `legal:vendor-check`, `legal:legal-risk-assessment`

### Daily Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Contract intake review | `legal:review-contract` | Review any new client or vendor contract signed or received today |
| Compliance spot check | `legal:compliance-check` | Verify one active engagement against applicable regulatory requirements |

### Weekly Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Full contract audit | `legal:review-contract` | Review all active contracts for risk, renewal dates, and unfavorable terms |
| NDA & signature queue | `legal:triage-nda`, `legal:signature-request` | Triage incoming NDAs and route finalized agreements out for signature |
| Vendor & risk review | `legal:vendor-check`, `legal:legal-risk-assessment` | Audit vendor agreements and flag legal risk across active engagements |

> No installed skill drafts new agreements/terms-of-service from scratch (the old `agreement-drafting` / `terms-and-policies` placeholders had no real equivalent). Use `legal:brief` or `legal:meeting-briefing` to prep context, then draft manually.

### Key Outputs
- Weekly contract risk report (renewal dates, red-flag clauses)
- Drafted agreements ready for signature
- Compliance status log per active engagement

### Handoffs
- **Receives from:** Small Business Ops Agent (new engagement scopes needing agreements), Marketing Strategy Lead (client positioning that affects terms)
- **Hands off to:** Small Business Ops Agent (finalized agreements for onboarding), Finance Agent (contract terms affecting invoicing schedule)

---

## Agent 2: Finance Agent

**Specialty:** Budgeting, invoicing, and profitability tracking

**Skills:** `finance:variance-analysis`, `finance:reconciliation`, `finance:close-management`, `small-business:margin-analyzer`, `small-business:cash-flow-snapshot`, `small-business:invoice-chase`

### Daily Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Budget pacing check | `finance:variance-analysis` | Compare active client budgets against actuals to check pacing |
| Invoice queue | `small-business:invoice-chase` | Follow up on outstanding invoices due or overdue today |

### Weekly Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Profitability review | `small-business:margin-analyzer` | Calculate margin per client and per service line (SEO, Ads, Blog, Marketing) |
| Cash flow forecast | `small-business:cash-flow-snapshot` | Snapshot the next weeks of cash flow based on active and pipeline engagements |
| Budget reconciliation | `finance:reconciliation` | Reconcile actuals against budgeted spend for all active clients |
| Month-end close | `small-business:month-end-prep`, `finance:close-management` | Prep and close the books at month end |

> No installed skill issues brand-new outbound invoices (`small-business:invoice-chase` only covers collections/follow-up). If invoice generation is needed, handle it via the accounting tool directly.

### Key Outputs
- Weekly profitability report (per client, per service line)
- Cash flow forecast (4-week rolling)
- Invoice log and outstanding balances

### Handoffs
- **Receives from:** Legal & Compliance Agent (contract terms affecting billing), Ads Performance Optimizer (ad spend data feeding client budgets), Small Business Ops Agent (new engagement value)
- **Hands off to:** Small Business Ops Agent (profitability data for scoping decisions), Marketing Strategy Lead (budget constraints for campaign planning)

---

## Agent 3: Small Business Ops Agent

**Specialty:** Client scoping, proposals, and internal operations

**Skills:** `small-business:smb-router`, `small-business:smb-onboard`, `small-business:sales-brief`, `small-business:lead-triage`, `small-business:crm-cleanup`, `small-business:friday-brief`, `small-business:quarterly-review`

### Daily Tasks
| Task | Skill | Description |
|------|-------|-------------|
| Scope clarification | `small-business:smb-router` | Route scope questions raised by active client work to the right process |
| Proposal drafting | `small-business:sales-brief` | Draft or refine a sales brief for a prospect in the pipeline |

### Weekly Tasks
| Task | Skill | Description |
|------|-------|-------------|
| New engagement scoping | `small-business:smb-onboard` | Define deliverables and boundaries for any new client signed this week |
| Lead & CRM hygiene | `small-business:lead-triage`, `small-business:crm-cleanup` | Triage new leads and clean up CRM records from the week's activity |
| Operations review | `small-business:friday-brief`, `small-business:quarterly-review` | Assess agency workflow bottlenecks across all departments |

> No installed skill drafts formal engagement letters (the old `engagement-letter` placeholder had no real equivalent) — `small-business:smb-onboard` covers onboarding steps but not letter drafting. Draft letters manually or via `legal:signature-request` once the agreement is finalized.

### Key Outputs
- Client scope documents
- Draft proposals and engagement letters
- Weekly operations health review

### Handoffs
- **Receives from:** Finance Agent (profitability data informing scope decisions), Marketing Strategy Lead (positioning for proposals)
- **Hands off to:** Legal & Compliance Agent (scopes needing formal agreements), Marketing Strategy Lead (new client context for onboarding — see Playbook 1 in `agency-master-team.md`), Finance Agent (new engagement value for budget setup)

---

## Team Communication Flow

```
   ┌─────────────┐        ┌──────────────┐
   │  Legal &    │◄──────►│   Finance    │
   │ Compliance  │        │    Agent     │
   │  (Agent 1)  │        │  (Agent 2)   │
   └──────┬──────┘        └──────┬───────┘
          │                      │
          └──────────┬───────────┘
                      ▼
             ┌─────────────────┐
             │  Small Business │
             │   Ops Agent     │
             │   (Agent 3)     │
             └─────────────────┘
                      │
                      ▼
        Feeds into Playbook 1: New Client Onboarding
        (see agency-master-team.md)
```

**Daily standup order:** Small Business Ops Agent → Legal & Compliance Agent → Finance Agent

**Weekly sync:** Small Business Ops Agent compiles contract risk, profitability, and cash flow data into an internal agency health review — separate from client-facing weekly reports.
