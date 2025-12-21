# OUTPUT_RULES.md — Code Quality & Compliance Standards

**Inherits From**: `SYSTEM.md`  
**Scope**: Code, documentation, assets, and workflow standards  
**Authority**: Tillerstead conventions, TCNA 2024, NJ HIC, WCAG 2.1, industry best practices

---

## PURPOSE

Defines non-negotiable technical, legal, and brand standards for all code, content, and assets generated or modified by AI or humans. Every output must pass these requirements before commit or deployment.

---

## FILE NAMING & STRUCTURE

### HTML
- **Format**: `kebab-case.html`
- **Root pages**: `index.html`, `404.html`, `success.html`
- **Examples**: `theme-demo.html`, `about-us.html`
- **Rule**: No underscores, no camelCase, no spaces

### CSS/SCSS
- **Format**: `kebab-case.css`, `_partial-name.scss`
- **Partials**: Must start with underscore
- **Compiled**: `main.css`, `theme.css`
- **Examples**: `theme.css`, `_tokens.scss`

### JavaScript
- **Format**: `camelCase.js` or `kebab-case.js` (prefer camelCase for modules)
- **Examples**: `nav.js`, `formValidation.js`, `scrollHandler.js`

### Images & SVG
- **Format**: `kebab-case.svg|png|jpg|webp`
- **Patterns**: `pattern-*.svg`
- **Icons**: `icon-*.svg`
- **Examples**: `sacred-tile.svg`, `pattern-sacred-tile.svg`, `icon-chevron-down.svg`

### Directories
- **Format**: `kebab-case/` or `_underscore-prefix/`
- **Jekyll**: `_includes/`, `_layouts/`, `_sass/`
- **Examples**: `assets/`, `pages/`, `.github/workflows/`

---

## HTML STANDARDS

### Semantic Structure
- Use HTML5 landmarks: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`
- Avoid unnecessary `<div>`/`<span>` wrappers (“divitis”)
- Use heading hierarchy: single `<h1>`, logical `<h2>`–`<h6>`

### Meta & SEO
- Required: `<meta charset="UTF-8">`, `<meta name="viewport">`, unique `<title>`, `<meta name="description">`
- Open Graph & Twitter Card tags for every page
- Canonical URLs, robots.txt, sitemap.xml
- JSON-LD for LocalBusiness schema

### Accessibility (WCAG 2.1 AA+)
- Descriptive `alt` text for all images (no “image”, “tile”, or empty values)
- Explicit `<label for>` on all form fields
- ARIA labels for icon-only buttons
- Keyboard navigation: skip links, focus states
- Color contrast: 4.5:1 minimum for text, 3:1 for large text

### Performance
- Preload critical fonts and hero images
- Inline above-the-fold CSS
- Use `loading="lazy"` for non-critical images
- Responsive images: `srcset`, `sizes`
- Defer or use `type="module"` for scripts

### HTMLHint Compliance
- Must pass: `npx htmlhint '**/*.html'`
- No duplicate IDs, all attributes lowercase, double quotes, all tags closed, special chars escaped

---

## CSS/SCSS STANDARDS

### Design Tokens (see `_sass/base/_tokens.scss`)
- **Colors**: `--color-primary`, `--color-accent`, `--color-surface`, etc.
- **Typography**: `--font-sans`, `--heading-1`–`--heading-6`
- **Spacing**: `--space-1`–`--space-12`
- **Shadows**: `--shadow-soft`, `--shadow-lift`
- **Radius**: `--radius-sm`, `--radius-pill`
- **Gradients**: `--gradient-primary`, etc.

**Rule**: No hard-coded values—always use tokens.

### Responsive & Layout
- Mobile-first: use `@media (min-width: …)`
- CSS Grid for 2D layouts, Flexbox for 1D
- Utility classes for spacing, color, typography
- BEM naming for components, low specificity

### Linting
- (Planned) `npx stylelint "assets/css/**/*.css" "_sass/**/*.scss"`
- No ID selectors, no `!important`, use logical properties, prefer CSS variables

---

## JAVASCRIPT STANDARDS

### Syntax & Patterns
- ES6+ only: `const`/`let`, arrow functions, template literals, destructuring
- Prefer ES6 modules: `import`/`export`
- CamelCase for variables/functions, kebab-case for filenames

### Error Handling
- All async code must use `try/catch` and fail gracefully (never crash UI)
- Log errors with context, show fallback UI if needed

### DOM & Performance
- Batch DOM updates with fragments
- Minimize reflows/repaints
- Defer or module-load scripts

### ESLint Compliance
- Must pass: `npx eslint .`
- Key rules: no unused vars, prefer const, arrow spacing, semicolons, single quotes

---

## JEKYLL/LIQUID STANDARDS

### Front Matter
- Always include: `layout`, `title`, `description`
- Use unified hero: `{% include unified-hero.html ... %}` with explicit params
- Minimal logic in templates; move complexity to data files

---

## PERFORMANCE & TESTING

### Lighthouse Targets
- **Desktop**: Perf ≥ 90, Accessibility ≥ 95, Best Practices ≥ 95, SEO ≥ 95
- **Mobile**: Perf ≥ 85 (goal: 90+), Accessibility/Best/SEO ≥ 95
- **Core Web Vitals**: LCP < 2.5s, FID < 100ms, CLS < 0.1

### Asset Optimization
- Compress images (WebP preferred)
- Inline critical CSS
- Defer non-critical JS
- Preload fonts, use `font-display: swap`

### Pre-Commit Checklist
1. Lint HTML: `npx htmlhint '**/*.html'`
2. Lint JS: `npx eslint .`
3. Jekyll build: `bundle exec jekyll build`
4. (Optional) Check links, run visual regression
5. Manual accessibility test: keyboard, screen reader, contrast

### Browser Support
- Chrome/Edge/Firefox/Safari: last 2 versions
- iOS Safari 12+, Android Chrome 8+

---

## DOCUMENTATION

### Code Comments
- Explain “why”, not “what”
- Use JSDoc for functions, SCSS comments for design decisions

### README
- Update for new scripts, build changes, dependencies, structure, or deployment
- Use clear, actionable sections

---

## GIT COMMIT STANDARDS

### Conventional Commits
```
<type>(<scope>): <subject>

<body>

<footer>
```
- **Types**: feat, fix, docs, style, refactor, perf, test, chore
- **Examples**:
  - `feat(hero): add background pattern support`
  - `fix(nav): hide mobile drawer on desktop`
  - `docs(ai): create governance structure`
- **Body**: Explain what/why, reference issues

---

## SECURITY & COMPLIANCE

### Sensitive Data
- Never commit API keys, credentials, or personal info
- Use `.env` (gitignored) for secrets

### Content Security Policy
- Target: strict CSP, only self and trusted sources

---

## OUTPUT VERIFICATION CHECKLIST

- [ ] File/directory naming follows conventions
- [ ] HTML is semantic, accessible, and SEO-optimized
- [ ] CSS uses tokens, no hard-coded values
- [ ] JS is ES6+, error-handled, and modular
- [ ] All linter/build checks pass
- [ ] Lighthouse and accessibility targets met
- [ ] Documentation updated if needed
- [ ] Commit message is Conventional Commits compliant

---

**Version**: 1.1.0  
**Last Updated**: June 2024  
**Authority**: SYSTEM.md, STYLE.md, DOMAIN.md, COMPLIANCE.md, OUTPUT_RULES.md  
**Legal**: TCNA 2024, NJ HIC, WCAG 2.1, modern web standards

