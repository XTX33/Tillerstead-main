# CSS Architecture Documentation

## Overview

The Tillerstead site uses a modernized, consolidated CSS architecture with clear separation of concerns. This document explains the structure and how to work with it.

## File Structure

```
assets/css/
├── base.css              # Foundation styles (330 lines)
├── layout.css            # Page structure (630 lines)
├── components.css        # Reusable UI components (2,553 lines)
├── home.css              # Homepage-specific styles (520 lines)
├── construction-banner.css  # Special: banner component (78 lines)
└── pattern-showcase.css     # Special: pattern utilities (174 lines)

src/styles/
└── tokens.css            # Design tokens (colors, spacing, typography)
```

## CSS Loading Order

1. **tokens.css** - Design tokens (colors, typography, spacing)
2. **base.css** - Foundation (resets, typography, HTML elements)
3. **layout.css** - Structure (containers, header, footer, navigation)
4. **components.css** - Reusable UI (buttons, cards, forms, hero)
5. **Page-specific CSS** - Only for that page (e.g., home.css)
6. **Special components** - As needed (banner, patterns)

## File Responsibilities

### tokens.css (Design Tokens)
**Location:** `src/styles/tokens.css`

Single source of truth for all visual properties:
- Brand colors (primary, accent, backgrounds)
- Typography (font families, sizes, line heights)
- Spacing scale (space-1 through space-12)
- Border radius values
- Shadows
- Transitions

**When to edit:**
- Changing brand colors
- Adjusting spacing scale
- Modifying typography system
- Updating shadow styles

### base.css (Foundation)
**Location:** `assets/css/base.css`

Foundation styles that apply to raw HTML elements:
- CSS resets and box-sizing
- HTML and body base styles
- Typography (h1-h6, p, ul, ol, code)
- Link styles
- Focus states
- Accessibility helpers (sr-only, skip-link)
- Motion preferences
- Print styles
- High contrast mode support

**When to edit:**
- Changing default heading styles
- Adjusting base link behavior
- Modifying global typography
- Adding new accessibility helpers

**DO NOT add:**
- Layout-specific styles (use layout.css)
- Component styles (use components.css)
- Page-specific styles (use page CSS)

### layout.css (Page Structure)
**Location:** `assets/css/layout.css`

Styles for page structure and major layout regions:
- Site body and main layout (flexbox container)
- Containers and section wrappers
- Header and navigation (mobile and desktop)
- Footer
- Breadcrumbs
- Section spacing and grids
- Page content layouts

**When to edit:**
- Adjusting header/footer layout
- Modifying navigation behavior
- Changing section spacing
- Adding new layout patterns

**DO NOT add:**
- Component styles (use components.css)
- Page-specific layouts (use page CSS)
- Button/card/form styles (use components.css)

### components.css (Reusable UI)
**Location:** `assets/css/components.css`

All reusable UI components that can be used across multiple pages:
- Buttons and CTAs (.btn, .btn-ghost, .btn-outline)
- Cards and panels (.card, .plan-card, .who-card)
- Hero components (.hero-surface, .hero-panel)
- Forms and inputs (.form-group, .form-input)
- Navigation elements
- Stat lists (.stat-list)
- Pills and badges
- Animations and transitions
- Utility classes (spacing, colors, shadows)

**When to edit:**
- Creating new reusable components
- Modifying button styles
- Adjusting card appearances
- Adding new utility classes

**DO NOT add:**
- Page-specific styles (use page CSS)
- Layout structure (use layout.css)
- Base element styles (use base.css)

### home.css (Homepage Only)
**Location:** `assets/css/home.css`

Styles ONLY used on the homepage:
- Hero section layout (.hero__grid, .hero__content)
- Service cards section
- Plans grid section (.plan-grid, .plan-card)
- Process section
- Assurance section
- Contact section

**When to edit:**
- Modifying homepage-specific layouts
- Adjusting homepage section spacing
- Changing homepage-only components

**DO NOT add:**
- Reusable components (use components.css)
- Styles used on other pages (use components.css or layout.css)

### Special Components

#### construction-banner.css
**Location:** `assets/css/construction-banner.css`

Styles for the construction/update banner displayed at the top of pages.

#### pattern-showcase.css
**Location:** `assets/css/pattern-showcase.css`

Utilities for displaying and managing background patterns.

## How to Add New Styles

### Adding a New Component
If the component will be used on multiple pages:

1. Add styles to `components.css`
2. Add a clear comment block describing the component
3. Use design tokens from `tokens.css`
4. Follow the existing naming conventions

Example:
```css
/* ============================================
   YOUR COMPONENT NAME
   ============================================ */

.your-component {
  padding: var(--space-4);
  border-radius: var(--radius-lg);
  background: var(--color-surface);
  /* ... more styles ... */
}
```

### Adding Page-Specific Styles
If the styles are ONLY for one page:

1. Create a new CSS file (e.g., `about.css`)
2. Add the file to the page's front matter:
   ```yaml
   ---
   styles:
     - /assets/css/about.css
   ---
   ```
3. Keep page-specific files focused and minimal

### Modifying Design Tokens
To change colors, spacing, or typography across the entire site:

1. Edit `src/styles/tokens.css`
2. Changes will automatically apply throughout the site
3. Test all pages to ensure consistency

## Best Practices

### DO:
✅ Use design tokens (CSS custom properties) instead of hardcoded values
✅ Add clear comment blocks for new sections
✅ Follow the existing naming conventions
✅ Keep specificity low (avoid deep nesting)
✅ Use utility classes for common patterns
✅ Test changes across all pages
✅ Run linters before committing

### DON'T:
❌ Add layout styles to components.css
❌ Add component styles to layout.css
❌ Add page-specific styles to shared files
❌ Use hardcoded colors/spacing (use tokens)
❌ Create deep selector nesting
❌ Duplicate existing styles

## Naming Conventions

- **BEM-style for components:** `.component__element--modifier`
- **Utility classes:** `.mt-4`, `.text-center`, `.bg-surface`
- **State classes:** `.is-active`, `.is-open`, `.is-loading`
- **Layout classes:** `.container`, `.section`, `.grid`

## Development Workflow

1. **Before making changes:**
   ```bash
   npm run lint
   ```

2. **After making changes:**
   ```bash
   npm run lint
   vendor/gems/jekyll/bin/jekyll build
   ```

3. **Test locally:**
   ```bash
   cd _site
   python3 -m http.server 8000
   # Visit http://localhost:8000
   ```

4. **Commit with descriptive message:**
   ```bash
   git add assets/css/
   git commit -m "feat: add new component styles"
   ```

## Migration from Old Structure

### Old File Mapping:
- `theme.css` → Split into `base.css`, `layout.css`, `components.css`
- `theme-compiled.css` → Removed (replaced by new structure)
- `boss-enhancements.css` → Merged into `components.css`
- `premium-hero.css` → Merged into `components.css`
- `premium-forms.css` → Merged into `components.css`
- `_hero-patterns.css` → Merged into `components.css`

### Benefits of New Structure:
- 62.5% fewer CSS files (16 → 6)
- 30% less total CSS (5,748 → 4,030 lines)
- Clear separation of concerns
- Easier to find and modify styles
- Better maintainability
- Faster development

## Troubleshooting

### Styles not applying?
1. Check the CSS loading order in `_includes/head.html`
2. Verify the file is in the correct location
3. Clear browser cache
4. Check for typos in class names
5. Verify Jekyll built successfully

### Build failing?
1. Run `npm run lint` to check for syntax errors
2. Check for missing CSS files
3. Verify all `@import` statements are removed
4. Check Jekyll build output for errors

### Unexpected styling?
1. Check if styles are being overridden by more specific selectors
2. Use browser DevTools to inspect computed styles
3. Verify design tokens are defined in `tokens.css`
4. Check for conflicting utility classes

## Support

For questions about the CSS architecture:
1. Check this documentation first
2. Review existing code for patterns
3. Test changes locally before committing
4. Follow the linting and build process

---

**Last Updated:** November 2025
**Maintained By:** Tillerstead Development Team
