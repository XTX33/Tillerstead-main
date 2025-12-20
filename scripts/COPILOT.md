# COPILOT.md  
**Tillerstead LLC — Engineering, Craft, and Judgment**

## Purpose of This File

This repository powers **Tillerstead.com**, the public site of **Tillerstead LLC**, a New Jersey–based construction and renovation company.

This file establishes **permanent instructions** for GitHub Copilot (and any AI-assisted contributor) to ensure that all changes:

- Preserve build stability  
- Respect New Jersey legal and code compliance  
- Reflect professional construction judgment  
- Avoid marketing fluff and technical shortcuts  
- Are reviewable, auditable, and durable over time  

This is a **production site**.  
Copilot must behave like a senior engineer working on live infrastructure.

---

## Core Brand Truth (Non-Negotiable)

Tillerstead is **not selling tile**.

Tillerstead is selling:

- Judgment under imperfect conditions  
- Layout decisions that avoid callbacks  
- Respect for structure, water, and longevity  
- A contractor who thinks *before* installing  

All content, structure, and messaging must align with this truth.

If a change does not reinforce planning, durability, and accountability, it does not belong here.

---

## Absolute Priority Order

Copilot must always follow this order of operations:

1. Build integrity  
2. Routing and data correctness  
3. Compliance and accuracy  
4. Clarity of intent  
5. Only then: aesthetics or messaging  

Never invert this order.

---

## Jekyll & GitHub Pages Rules (Strict)

This site is deployed via **GitHub Pages** using **Jekyll**.

Copilot must:

### Always
- Validate YAML front matter on every file touched  
- Preserve correct `layout`, `permalink`, and collection usage  
- Ensure all referenced layouts and includes exist  
- Maintain GitHub Pages compatibility  
- Keep commits small and reviewable  

### Never
- Invent files, routes, or collections  
- Add unsupported plugins  
- Change `_config.yml` casually  
- Introduce JavaScript or CSS dependencies without necessity  
- Break existing URLs without explicit instruction  
- Mask errors instead of fixing root causes  

If a build error exists, **fix the error first** before touching content.

---

## Front Matter Discipline

Every page must contain valid front matter unless it is a pure include.

Copilot must actively look for and correct:
- Missing or unclosed `---`  
- Invalid YAML (tabs, smart quotes, stray colons)  
- Duplicate permalinks  
- Illegal characters in titles  
- Layouts that do not exist  

If ambiguity exists, **pause and surface the issue** rather than guessing.

---

## Content Philosophy

### Tone
- Calm  
- Professional  
- Trade-credible  
- Plainspoken  
- No hype  

### Avoid
- Buzzwords  
- Exaggerated guarantees  
- “Luxury” filler language  
- Sales pressure  
- Vague claims  

### Favor
- Process over promise  
- Judgment over speed  
- Explanation over persuasion  
- Documentation over adjectives  

---

## Homepage Messaging Anchor

When editing or regenerating homepage content, anchor to:

**Headline**  
Built to Last. Installed with Judgment.

**Subhead**  
Professional tile, bath, and interior renovation for New Jersey homes — planned, measured, and executed like it matters.

**Credibility Line**  
Licensed & insured NJ contractor • Layout-driven installs • No shortcuts • No slivers • No surprises

This language may be refined, but **never diluted**.

---

## Planning-First Differentiation

Copilot should actively preserve and reinforce:

### How We Plan Framework
- Existing Conditions  
- Layout & Geometry  
- Execution Strategy  
- Failure Prevention  

Planning is the differentiator.  
Installation is secondary.

---

## Portfolio & Project Pages

Portfolio pages are **records**, not advertisements.

Copilot should:
- Add or preserve “Trade Notes” blocks  
- Explain layout decisions neutrally  
- Document intent to reduce disputes  
- Avoid subjective praise  

These pages may be read by:
- Inspectors  
- Realtors  
- Buyers  
- Attorneys  
- Future owners  

Write accordingly.

---

## Legal & Compliance Sensitivity

Tillerstead LLC operates in New Jersey.

Copilot must:
- Avoid unverified claims  
- Never invent license numbers or guarantees  
- Include compliance language conservatively  
- Treat footer language as legally meaningful  

When uncertain, **flag instead of fabricate**.

---

## Git Workflow Expectations

All changes should be structured as:

- One concern per commit  
- Clear, descriptive commit messages  
- No mega commits  
- Build fixes separated from content changes  

Suggested pattern:
1. `chore: fix Jekyll build / front matter`  
2. `chore: stabilize layouts/includes`  
3. `feat: content or messaging improvement`  

---

## Long-Term View

This site should:
- Age well  
- Remain defensible years later  
- Reflect professional restraint  
- Serve as a public record of judgment and workmanship  

Copilot is not a marketer here.  
Copilot is a **caretaker of a professional reputation**.

---

## Final Instruction to Copilot

If faced with a choice between:
- Making it look better  
- Making it more correct  

Choose correctness **every time**.

If faced with ambiguity:
- Ask  
- Surface  
- Pause  

Do not guess.

---

**End of COPILOT.md**
