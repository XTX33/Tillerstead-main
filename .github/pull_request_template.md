## Pull Request Summary

This update standardizes theme tokens, enforces WCAG 2.1 AA contrast, and introduces modular, TCNA-compliant container components.

## Technical Changes
- Centralized color palette and surface tokens per TCNA guidelines
- Utility classes for typography, spacing, and responsive layout
- Modular containers: `.card`, `.panel`, `.callout`, `.section` (see `/assets/css/theme.css`)
- Theme toggle with real-time contrast validation (see `/assets/js/theme.js`)
- Eliminated all inline color usage for maintainability and compliance

## Accessibility & Compliance
- [ ] Pa11y CI: Passes all contrast and focus criteria (WCAG 2.1 AA)
- [ ] Focus outlines: Visible and accessible on all interactive elements
- [ ] Links: All have non-color affordances (underline, icon, or ARIA label)
- [ ] Alt text, ARIA, and labels: Verified for legal and NJ HIC accessibility compliance

## Visual Evidence
_Include before/after screenshots for:_
- Homepage hero section
- Services overview
- At least one case study page

## Risk Assessment & Rollback Plan
- Minimal risk to content integrity; all changes are modular and reversible
- Rollback: Revert `assets/css/theme.css`, `assets/js/theme.js`, and affected class names
- All updates validated with HTMLHint, ESLint, and Jekyll build; accessibility tested

---

_Reference: See `/.ai/OUTPUT_RULES.md` for naming, structure, and compliance standards. All changes adhere to TCNA 2024 and NJ HIC requirements._