## Branch Model

- **main**: Production branch. Contains only code and content that meet Tillerstead’s release criteria, pass all status checks, and comply with TCNA 2024 and NJ HIC standards. Always stable and deployable.
- **staging**: Integration branch for active development. All feature and fix branches are created from and merged into `staging` via pull request, ensuring continuous validation and traceability.
- **Feature/fix branches**: Named descriptively for the work item (e.g., `feature/tcna-bath-updates`, `bugfix/accessibility-labels`). Always branch from `staging` and follow OUTPUT_RULES.md naming conventions.

## Change Flow & Merge Rules

1. Create a feature or fix branch from `staging` using descriptive, kebab-case names per OUTPUT_RULES.md.
2. Open a pull request targeting `staging`. Reference relevant TCNA/NJ HIC standards and link to work items.
3. Pass all required status checks (including Jekyll build, HTMLHint, ESLint, and accessibility tests).
4. Obtain approvals from designated reviewers per COMPLIANCE.md.
5. Merge using "Merge pull request" or "Squash and merge"—never force-push to shared branches.
6. Promote `staging` to `main` via pull request only after all release criteria are met and documented.

## GitHub Branch Protection (Recommended)

- Require pull requests for all merges into `main` and `staging`.
- Enforce passing status checks (Jekyll build, HTMLHint, ESLint, accessibility) before merging.
- Disallow force-pushes to `main` and `staging`; allow only fast-forward or merge commits via pull requests.
- Require signed commits and enforce CODEOWNERS review for regulated files.

## Release Criteria: `staging` → `main`

- Project builds cleanly (Jekyll build passes; no HTMLHint or ESLint errors).
- All content and code reviewed for TCNA 2024 and NJ HIC compliance; accessibility spot-checks completed.
- Release checklist completed and attached to the pull request (content updates, link validation, alt text and ARIA labels verified).
- All required reviewers have approved the promotion pull request.
- No unresolved issues, broken links, or accessibility violations.

> **Reference:** See `/.ai/OUTPUT_RULES.md` for naming, formatting, and commit conventions. All workflow steps must comply with SYSTEM.md, DOMAIN.md, and COMPLIANCE.md.

