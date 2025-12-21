# `ts-` Include & SCSS Audit

This technical audit documents how Tillerstead’s `ts-` includes integrate with `_sass` components and base utilities, providing a precise inventory of spacing, contrast, and layout rules. All references align with TCNA 2024 standards and NJ HIC compliance, ensuring accessibility, technical rigor, and legal clarity.

---

## Hero / Primary Banner

- **Include:** `_includes/ts-hero.html` (lines 1–40) outputs a `<section class="hero hero--with-pattern">` containing `.hero-title`, `.hero-lead`, `.hero-actions`, `.hero-visual`, `.hero-kpis`, and related blocks.
- **SCSS:** `_sass/components/_hero.scss` governs the `.hero` system: section-level `--section-padding-y`, `.hero-inner` grid (`grid-template-columns: minmax(280px,1fr) minmax(320px,1fr)`), `.hero-surface` overlays, and responsive collapse at 960px/640px. Typography and color tokens are sourced from `_sass/base/_typography.scss` and `_sass/base/_tokens.scss`, ensuring WCAG AA contrast and TCNA-compliant hierarchy.
- **Spacing/Contrast:** Uses `clamp()` for adaptive padding, heading, and button sizing. `.hero-actions` flex-wraps CTAs for mobile accessibility. `.hero-kpi` cards employ border/gradient emphasis for visual clarity.

---

## Services Grid

- **Include:** `_includes/ts-services.html` structures `.ts-services.ts-section` with a header, `.ts-services__grid` (auto-fit, minmax 260px), and optional gallery/photos.
- **SCSS:** `.ts-services` (in `_sass/theme/_tillerstead.scss`, lines 137–270) controls gradient backgrounds, container padding, and responsive grid. `.ts-service-card` styles (lines 263–370) extend `.card--service` from `_sass/components/_cards.scss` for hover, shadow, and spacing. Buttons use `_sass/components/_buttons.scss` and base tokens for consistent contrast.
- **Spacing/Contrast:** Section backgrounds use `var(--ts-gradient-section)` overlays. Card padding and grid gaps use `clamp()` and `var(--ts-spacing-lg)`. Gallery grids ensure responsive stacking and semantic markup.

---

## Service Cards

- **Include:** `_includes/ts-service-card.html` generates `.ts-service-card` articles with icon, `<h3>`, description, optional points, and a `Learn more` link.
- **SCSS:** `.ts-service-card` and `.card--service` (in `_sass/theme/_tillerstead.scss` and `_sass/components/_cards.scss`) define spacing, hover, and stacked layouts. Icons use `_includes/ts-service-icon.html` and color tokens. Typography inherits from `_sass/base/_typography.scss`.
- **Spacing/Contrast:** Cards use `display: flex` and `gap: var(--ts-spacing-md)`. CTA links (`.ts-service-card__link`) use `color: var(--ts-color-primary)` and accessible underline/outline transitions.

---

## Contact / CTA Form

- **Include:** `_includes/ts-contact.html` renders `.ts-contact` with `.container.ts-contact__grid`, `.ts-contact__copy`, `.ts-contact__form`, and `.ts-contact__panel` (licensing/trust info).
- **SCSS:** Layout uses `_sass/layout/_container.scss` for `.container` and `_sass/components/_forms.scss` for form controls (inputs, focus rings, spacing). Buttons are styled via `_sass/components/_buttons.scss`. Typography and spacing inherit from `_sass/base/_typography.scss` and `_sass/base/_tokens.scss`.
- **Spacing/Contrast:** `.ts-contact__grid` uses CSS grid (2 columns desktop, 1 column mobile, `gap: var(--ts-spacing-lg)`). Inputs use `border: 1px solid var(--ts-color-border)` and accessible focus states. Licensing info is always visible near the submit action.

---

## Breadcrumbs / Microcopy

- **Include:** `_includes/ts-breadcrumbs.html` injects `.breadcrumbs-bar`, `.breadcrumbs`, `.ts-breadcrumbs`, `.ts-crumb-link`, `.ts-breadcrumbs__current`, and JSON-LD markup.
- **SCSS:** `_sass/components/_breadcrumbs.scss` manages sticky bar, background, border, shadow, and responsive padding. Colors use `_sass/base/_tokens.scss` for primary/accent and text-muted. Print rules hide breadcrumbs.
- **Spacing/Contrast:** Links have pill-shaped padding and `var(--color-primary-soft)` backgrounds on focus. SVG arrow separators use contrast-coded strokes for accessibility.

---

## Supporting Includes

- **Includes:** `ts-deliver.html` (`_sass/components/_deliver.scss`), `ts-process.html` (uses `.ts-process` tokens from `_sass/components/_plans.scss`), `ts-plans.html`, `ts-reviews.html`, `ts-testimonials.html`, etc.
- **SCSS:** All leverage shared `_sass/components/_cards.scss`, `_sass/components/_buttons.scss`, and `_sass/base/_tokens.scss` for spacing and contrast. Wrappers use `.ts-section` from `_sass/layout/_container.scss` for vertical rhythm.

---

## Base Utilities

- **Tokens:** `_sass/base/_tokens.scss` defines all spacing, color, gradient, and shadow tokens (`--ts-spacing-*`, `--ts-color-*`).
- **Typography:** `_sass/base/_typography.scss` sets heading/paragraph defaults, `.lead`, `.heading-2`, `.eyebrow`, `.text-muted`.
- **Layout:** `_sass/layout/_container.scss` provides `.ts-section`, `.container`, `.ts-section-inner` for grid/padding consistency.

---

## Modernization Roadmap

### 1. Markup Updates

- **Hero:** Remove duplicate Liquid assignments; wrap CTAs in `.hero-actions.hero-cta-group`; output hero visual as `<picture>` with WebP for desktop/mobile; move `hero-note` near CTAs for NJ HIC trust.
- **Services:** Add `<header>`, `<footer>` to cards; ensure gallery `figure` pairs image/caption; add `aria-label` to gallery containers.
- **Contact:** Use `<div class="ts-contact__fields grid">` for form fields; move aside above/below button on mobile; add inline NJ HIC messaging near submit.
- **Breadcrumbs:** Render a single breadcrumb trail; align JSON-LD with nav; reuse `.ts-crumb-link` for consistent focus styles.

### 2. SCSS Refactors

- **Hero:** Explicit `grid-template-columns`; `.hero-cta-group` with `gap: var(--ts-spacing-md)` and `flex-wrap: wrap`; increase `.hero-surface` box-shadow contrast.
- **Services:** Reference `--section-padding-y`; refactor `.ts-services__gallery` as mixin; ensure `.ts-service-card` links meet WCAG AA.
- **Forms:** Add `.ts-contact__grid` helpers; align `.ts-contact__field` spacing; style `.ts-contact__panel` with `var(--ts-color-surface-elevated)` and `var(--ts-shadow-soft)`.
- **Buttons/Tokens:** Ensure primary/ghost buttons use `var(--ts-color-primary)` and `var(--ts-color-primary-strong)`; CTA text uses `font-weight: 600`, `letter-spacing: 0.02em`.

### 3. Verification

- Run `npm run dev` and inspect all sections (320px–1200px) for grid collapse, spacing, and CTA visibility.
- Use Chrome DevTools color contrast analyzer to confirm WCAG AA compliance for all interactive elements.
- Validate hero/contact copy readability (`font-size`, `line-height` per tokens); ensure NJ HIC license text is always visible for trust and legal compliance.

---

**All changes must pass HTMLHint, ESLint, and Jekyll build. Accessibility, TCNA, and NJ HIC compliance are non-negotiable. For any ambiguity, reference the `.ai/` directory and cite the relevant rule.**

