# Tillerstead Refactored Theme System

## Overview

Tillerstead.com’s theme system has been fully re-engineered for technical clarity, accessibility, and conversion. The new design transitions from a dark navy to a parchment-inspired, light-first palette, leveraging TCNA 2024 standards and NJ HIC compliance. The system is card-based, modular, and optimized for performance, accessibility, and legal transparency.

**Design Philosophy:**
- **Parchment Base:** Warm, paper-like background (`#f5f1eb`) for a professional, inviting environment
- **Emerald Primary:** High-contrast action color (`#00a86b`) for CTAs, meeting WCAG 2.1 AA
- **Brass Accent:** Depth and hierarchy via warm brown (`#8b6f47`)
- **Component-Driven:** Card-first, modular, and responsive layouts
- **Technical Authority:** All patterns reference TCNA standards and NJ HIC requirements

## Color Palette

### Primary Colors
- **Background:** `#f5f1eb` (parchment)
- **Surface:** `#fffaf5` (paper white)
- **Surface Muted:** `#f0ede5` (light taupe)
- **Surface Elevated:** `#fef9f5` (off-white)
- **Text:** `#1a1a1a` (high-contrast, meets 4.5:1 ratio)
- **Text Muted:** `#666666`
- **Heading:** `#1a1a1a`

### Action & Accent Colors
- **Primary:** `#00a86b` (emerald) — CTAs, links, focus
- **Primary Light:** `#00d68f` — Hover states
- **Primary Strong:** `#004d35` — Active/focus
- **Accent:** `#8b6f47` (brass) — Borders, secondary actions
- **Accent Light:** `#a88760` — Accent hover

### Borders & Dividers
- **Border:** `rgba(0,0,0,0.08)` — Subtle, accessible

## Gradients

All gradients are optimized for light themes and accessibility:

```css
--gradient-primary: linear-gradient(135deg, #00a86b 0%, #008856 100%);
--gradient-accent: linear-gradient(135deg, #8b6f47 0%, #6b5536 100%);
--gradient-section: linear-gradient(180deg, #f5f1eb 0%, #f0ede5 100%);
```

## Shadows

Accessible, low-blur shadows for depth without contrast loss:

```css
--shadow-soft: 0 2px 4px rgba(26,26,26,0.08);
--shadow-lift: 0 8px 16px rgba(26,26,26,0.12);
--shadow-sharp: 0 12px 32px rgba(26,26,26,0.15);
--shadow-button: 0 6px 16px rgba(0,168,107,0.24);
--shadow-button-hover: 0 10px 24px rgba(0,168,107,0.32);
--shadow-glow: 0 0 24px rgba(0,168,107,0.28);
```

## Typography

### Font Stack
- **Body:** Inter, 14–32px, sans-serif, variable
- **Headings:** Manrope, 500–800, sans-serif, variable
- **Monospace:** IBM Plex Mono (for code/technical)

### Heading Sizes
- **H1:** `clamp(2.1rem, 3.6vw, 3rem)`
- **H2:** `clamp(1.8rem, 3vw, 2.4rem)`
- **H3:** `clamp(1.3rem, 2.2vw, 1.6rem)`
- **H4–H6:** Defined in `tokens.css` for consistency

## Spacing System

8px base, tokenized for consistency and maintainability:

```css
--space-1: 0.5rem; /* 8px */
--space-2: 1rem;   /* 16px */
--space-3: 1.5rem; /* 24px */
--space-4: 2rem;   /* 32px */
--space-5: 2.5rem; /* 40px */
--space-6: 3rem;   /* 48px */
--space-8: 4rem;   /* 64px */
--space-12: 6rem;  /* 96px */
```

## Component System

### Hero Component (`hero-refactored.css`)
Modern, accessible hero with semantic structure and KPI grid:

```html
<section class="hero hero-surface" aria-label="Homepage Hero">
  <div class="hero-inner">
    <div class="hero-main">
      <span class="hero-eyebrow" aria-label="Section Highlight">Eyebrow text</span>
      <h1 class="hero-title">Hero title</h1>
      <p class="hero-lead">Lead paragraph</p>
      <div class="hero-actions">
        <a href="#" class="btn btn-primary" aria-label="Primary Call to Action">Primary CTA</a>
        <a href="#" class="btn btn-secondary" aria-label="Secondary Call to Action">Secondary CTA</a>
      </div>
      <ul class="hero-kpis" aria-label="Key Performance Indicators">
        <li class="hero-kpi">
          <span class="hero-kpi-label">Label</span>
          <span class="hero-kpi-text">Value</span>
        </li>
      </ul>
    </div>
  </div>
</section>
```

**Features:**
- Emerald border on eyebrow (TCNA-compliant highlight)
- Responsive, fluid typography
- KPI grid (homepage only)
- Animations respect `prefers-reduced-motion`
- All interactive elements have accessible labels

### Card System (`cards.css`)
Reusable, accessible cards for services, portfolio, and reviews.

#### Service Cards
```html
<li class="card card--service" aria-label="Service Card">
  <div class="card-icon" aria-hidden="true">🛁</div>
  <h3 class="card-title">Service title</h3>
  <p class="card-desc">Description text</p>
  <a href="#" class="card-link" aria-label="Learn more about Service title">Learn more →</a>
</li>
```

#### Portfolio Cards
```html
<li class="card card--portfolio" aria-label="Portfolio Card">
  <img src="..." alt="Project photo: [describe project]" class="card-image" loading="lazy">
  <div class="card-content">
    <span class="card-category">Category</span>
    <h3 class="card-title">Project title</h3>
    <p class="card-desc">Description</p>
  </div>
</li>
```

#### Review Cards
```html
<li class="card card--review" aria-label="Client Review">
  <div class="card-rating" aria-label="5 out of 5 stars">★★★★★</div>
  <p class="card-quote">"Quote text"</p>
  <strong class="card-author">Author Name</strong>
  <p class="card-role">Client title</p>
</li>
```

**Grid Utilities:**
- `.cards--2col`, `.cards--3col`, `.cards--4col` — Responsive, accessible grids

### Gallery Component (`gallery.css`)
Accessible media management and showcase.

#### Upload Area
```html
<div class="upload-area" aria-label="Upload Photos">
  <span class="upload-area-icon" aria-hidden="true">📤</span>
  <label class="upload-area-label" for="upload-input">Drag files here or click to upload</label>
  <input type="file" id="upload-input" class="upload-area-input" multiple aria-label="Upload files">
</div>
```

#### Photo Grid
```html
<ul class="photo-grid" aria-label="Project Gallery">
  <li class="photo-item">
    <img src="..." alt="Project photo: [describe]" class="photo-item-image" loading="lazy">
    <div class="photo-item-overlay">
      <p class="photo-caption">Caption</p>
      <p class="photo-meta">Date or metadata</p>
    </div>
  </li>
</ul>
```

#### Trend Showcase
```html
<article class="trend-card" aria-label="Design Trend">
  <img src="..." alt="Trend photo: [describe]" class="trend-image" loading="lazy">
  <div class="trend-content">
    <span class="trend-label">Trend label</span>
    <h3 class="trend-title">Trend title</h3>
    <p class="trend-desc">Description</p>
    <div class="trend-meta">
      <div class="trend-meta-item">
        <span class="trend-meta-label">Label</span>
        <span class="trend-meta-value">Value</span>
      </div>
    </div>
  </div>
</article>
```

### Button Styles (`components-refactored.css`)

```html
<a href="#" class="btn btn-primary" aria-label="Primary Action">Primary CTA</a>
<a href="#" class="btn btn-secondary" aria-label="Secondary Action">Secondary</a>
<a href="#" class="btn btn-ghost" aria-label="Ghost Action">Ghost</a>
<a href="#" class="btn btn-small" aria-label="Small Action">Small</a>
<a href="#" class="btn btn-large" aria-label="Large Action">Large</a>
```

**Classes:**
- `.btn-primary` — Emerald gradient, white text, high-contrast
- `.btn-secondary` — Emerald border, emerald text
- `.btn-ghost` — Transparent, minimal border
- `.btn-small` — Compact for dense layouts
- `.btn-large` — Enhanced for hero CTAs

## CSS Architecture

### Layer Order (Load Order)
1. **tokens.css** — Design tokens (single source of truth)
2. **base.css** — Element resets, typography, accessibility
3. **layout.css** — Grid, container, responsive utilities
4. **components-refactored.css** — Buttons, forms, hero base
5. **hero-refactored.css** — Hero-specific styles
6. **cards.css** — Card variants and grids
7. **gallery.css** — Gallery, upload, photo grid
8. **home-refactored.css** — Homepage sections
9. **pattern-showcase.css** — Design system demo (optional)
10. **construction-banner.css** — Construction banner (optional)

### CSS Principles
- **Token-Driven:** All colors, spacing, and shadows via CSS custom properties
- **Utility-First:** Spacing, text, and shadow utilities for rapid, consistent development
- **Component-Based:** Reusable, accessible patterns
- **Mobile-First:** Base styles for mobile, media queries for larger screens
- **Accessible:** WCAG 2.1 AA, visible focus, keyboard navigation
- **Performance:** Minimal specificity, no selectors >3 levels deep

## Design Tokens (tokens.css)

**Location:** `_sass/base/_tokens.scss`

All design variables are defined here:
- Colors, gradients, shadows
- Typography, spacing, border radius
- Transitions, z-index

**Usage Example:**
```css
background: var(--color-bg);
color: var(--color-primary);
padding: var(--space-4);
box-shadow: var(--shadow-lift);
border-radius: var(--radius-lg);
```

## Responsive Design

### Breakpoints
- **Mobile:** 0–479px
- **Tablet:** 480–767px
- **Desktop:** 768px+
- **Large Desktop:** 1200px+

### Mobile-First
- Base styles for mobile
- Media queries for larger screens
- Use `clamp()` for fluid, accessible sizing

**Example:**
```css
font-size: clamp(0.95rem, 2vw, 1.25rem);
padding: clamp(1rem, 4vw, 2.5rem);
```

## Animations & Transitions

### Transition Times
- `--transition-short: 0.15s ease-out`
- `--transition-med: 0.3s ease-out`
- `--transition-long: 0.6s ease-out`

### Keyframes
- `fadeIn`, `slideInUp`, `slideInDown`, `scaleIn`, `pulse`
- All respect `prefers-reduced-motion` for accessibility

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Accessibility Features

### Color Contrast
- **Text on Background:** 4.5:1 minimum (WCAG AA)
- **Large Text:** 3:1 minimum
- **Emerald (#00a86b):** Verified for all interactive elements

### Focus States
```css
*:focus-visible {
  outline: 3px solid var(--color-primary);
  outline-offset: 2px;
}
```

### Keyboard Navigation
- All interactive elements are keyboard accessible
- Focus indicators are visible and consistent
- Tab order is logical and compliant

### Alt Text & Labels
- All images and controls require descriptive, legally compliant `alt` and `aria-label` attributes

## JavaScript Integration

### Theme Toggle
Accessible light/dark mode via `main.js`:

```javascript
document.documentElement.classList.toggle('dark-mode');
localStorage.setItem('ts:theme', 'dark');
```

### Deprecated Features
- High contrast mode and automated contrast scripts are deprecated for performance and clarity

### Color & Contrast
- All contrast is managed statically via tokens
- Manual checks with WebAIM Contrast Checker are required for new colors

## Development Workflow

### Theme Changes
1. Update `_sass/base/_tokens.scss` for tokens
2. Update relevant CSS for components
3. Run accessibility audit overlay (Alt+Shift+A) or PowerShell script
4. Test on all breakpoints in Chrome DevTools
5. Manually verify color contrast
6. Test with `prefers-reduced-motion: reduce`

### Adding Components
1. Create CSS in `assets/css/` (kebab-case)
2. Add to `_includes/head.html`
3. Use tokens for all variables
4. Include hover/focus/animation states
5. Test keyboard and screen reader accessibility
6. Document in this file

### Customizations

**Change Primary Color:**
```css
--color-primary: #00a86b;
--color-primary-light: #00d68f;
--color-primary-strong: #004d35;
--gradient-primary: linear-gradient(135deg, #00a86b 0%, #008856 100%);
--shadow-button: 0 6px 16px rgba(0,168,107,0.24);
```

**Adjust Spacing:**
```css
--space-4: 2rem; /* Looser layout */
```

**Modify Typography:**
```css
--heading-1: 3rem;
--heading-2: 2.4rem;
```

## Performance Considerations

### Critical CSS
Inline above-the-fold CSS in `<style data-critical>` in `_includes/head.html`.

### CSS Loading
- Use `media="screen"` on stylesheet links
- Fonts use `font-display: swap`
- Images use `loading="lazy"`

### Optimization
- Minimize selector specificity
- Group styles by component
- Use tokens to avoid duplication
- Avoid deep nesting
- Prefer `clamp()` for fluidity

## Browser Support

Supports all modern browsers with CSS Grid, Flexbox, and Custom Properties:
- Chrome/Edge 49+
- Firefox 31+
- Safari 9.1+
- iOS Safari 9.1+

## File Structure Reference

```
assets/
├── css/
│   ├── base.css
│   ├── layout.css
│   ├── components-refactored.css
│   ├── hero-refactored.css
│   ├── cards.css
│   ├── gallery.css
│   ├── home-refactored.css
│   ├── pattern-showcase.css
│   └── construction-banner.css
├── styles/
│   └── tokens.css
└── js/
    ├── main.js
    ├── auto-contrast.js (deprecated)
    ├── contrast.js (deprecated)
    └── dev-overlay.js
```

## Additional Resources

- **Accessibility Guide:** `.github/instructions/accessibility-tools.md`
- **Quality Standards:** `.github/instructions/quality-standards.instructions.md`
- **Design Tokens:** `_sass/base/_tokens.scss`
- **CI Pipeline:** `.github/workflows/ci.yml`

## Summary

This refactored theme system is engineered for technical authority, accessibility, and conversion. Every component, color, and pattern is token-driven, WCAG 2.1 AA compliant, and optimized for performance and legal transparency. Tillerstead’s design system is fully documented, extensible, and built to exceed TCNA and NJ HIC standards.

