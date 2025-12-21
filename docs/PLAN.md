# Execution Plan

## Phase 1 — Repository Hygiene & CI Reliability
- Remove all accidental build artifacts (e.g., `tmp.css`) and ensure all dev dependencies are explicitly pinned in `package.json` so `npm run dev` and `npm run serve` function without global installs.  
- Update CI and GitHub Pages workflows to reference the actual default branch (`main`). Temporarily disable any destructive branch-pruning workflows until robust safeguards and admin sign-off are in place.  
- **Rationale:** Guarantees a reproducible, standards-compliant toolchain for all contributors and automation, eliminating silent CI/Pages failures and accidental branch loss.  
- **Risks:** Minimal; coordinate workflow changes with repository administrators to confirm branch protection and compliance with NJ HIC recordkeeping.

## Phase 2 — Contact Form Integrity & Accessible Layout
- Standardize the contact form to a single, secure submission endpoint. Remove conflicting or duplicate attributes (e.g., multiple `action` values) to ensure all requests are reliably delivered and logged per NJ HIC requirements.  
- Implement scoped, accessible CSS for `.ts-contact__grid`, `.ts-contact__fields`, and `.ts-contact__panel` to achieve a responsive two-column layout that meets WCAG 2.1 AA standards and TCNA-recommended usability practices.  
- **Rationale:** Maximizes lead capture reliability, legal compliance, and user experience for high-intent visitors.  
- **Risks:** Moderate; endpoint changes may require updating spam protection and notification settings with the selected provider.

## Phase 3 — Content & Asset Compliance
- Deduplicate and sanitize `_config.yml` metadata (e.g., remove duplicate `default_og_image`, correct reassurance text encoding) to ensure SEO, social previews, and on-page copy are accurate and compliant.  
- Replace any hotlinked Unsplash hero fallback with a locally hosted, properly licensed image asset (per OUTPUT_RULES.md), including descriptive alt text for accessibility and legal compliance.  
- **Rationale:** Enhances brand authority, eliminates third-party licensing and latency risks, and ensures all assets meet TCNA/NJ HIC documentation standards.  
- **Risks:** Low; requires selection or export of a compliant local image.

## Phase 4 — Automated SEO & Sitemap Integrity
- Integrate automated `sitemap.xml` generation into the build process, eliminating manual maintenance and ensuring all public-facing pages are discoverable by search engines.  
- **Rationale:** Reduces human error, maintains crawl integrity, and aligns with technical SEO best practices.  
- **Risks:** Low; verify that automation respects intentional exclusions and legal requirements before deployment.

