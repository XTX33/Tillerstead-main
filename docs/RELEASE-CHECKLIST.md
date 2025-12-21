# Release Checklist

Before promoting any changes to production, rigorously complete this checklist to uphold Tillerstead’s technical standards, regulatory compliance, and client trust. Reference TCNA 2024 guidelines, NJ HIC requirements, and internal `.ai/` policies throughout.

## Automated Verification
- [ ] **CI Workflow:** Confirm all status checks are green—linting, full static build, and link validation (per `.github/workflows/ci.yml`).
- [ ] **Jekyll Build Verification:** Ensure `bundle exec jekyll build` passes with no HTML or link errors (see [TCNA Section 4.1.2](https://www.tcnatile.com/), NJ HIC §13:45A-16.2).
- [ ] **Local Testing:** Run `npm run test` to replicate production link checks and static build. Address all warnings and errors.

## Visual & UX Quality Assurance
- [ ] **Homepage Integrity:** Loads without console errors, missing assets, or layout shifts. Validate with Chrome DevTools and Lighthouse.
- [ ] **Navigation:** All menus and section links function on desktop and mobile. Test hamburger toggle, footer navigation, and skip links for accessibility.
- [ ] **Calls-to-Action:** All contact, quote, and service request buttons are visible, keyboard-accessible, and route to correct destinations.
- [ ] **Media Rendering:** Images, SVGs, and backgrounds display at intended resolutions with descriptive, standards-compliant alt text (see `.ai/COMPLIANCE.md`).
- [ ] **Responsive Layout:** No horizontal scrolling at 320px, 768px, 1024px, or ≥1440px. Validate with browser emulation and manual resizing.

## Content, Accessibility & Legal Compliance
- [ ] **Header Structure:** One `<h1>` per page; logical `<h2>`/`<h3>` nesting. Confirm with HTMLHint and screen reader tools.
- [ ] **Contact Links:** Phone, email, and map links open correct apps/URLs, are keyboard-accessible, and use ARIA labels as needed.
- [ ] **Interactive Elements:** All forms and widgets support keyboard navigation, visible focus states, and do not trap focus (WCAG 2.1 AA).
- [ ] **Alt Text & Descriptions:** Informative images have precise alt text; decorative images use `role="presentation"` or empty alt attributes. Review for NJ Consumer Fraud Act compliance.

## Repository & Deployment Safeguards
- [ ] **Branch Protection:** `main` branch requires passing CI and Jekyll Build Verification before merges. Confirm via GitHub branch protection settings.
- [ ] **Automated Validation:** No manual deploys—ensure all updates pass automated checks and are reviewed per `.ai/OUTPUT_RULES.md`.

---

**Final Step:**  
Document any deviations, edge cases, or technical debt in the release notes. Reference the relevant `.ai/` policy file for each exception.

*For authoritative guidance, consult: `/.ai/SYSTEM.md`, `/.ai/STYLE.md`, `/.ai/DOMAIN.md`, `/.ai/COMPLIANCE.md`, `/.ai/OUTPUT_RULES.md`, and `/.ai/COPILOT.md`.*
