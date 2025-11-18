# 🌿 Tillerstead.com — Static Site

A clean, fast, and accessible static website for **Tillerstead LLC**
> _Tile • Bath • Remodel — Built on trust, carried out with care._

This repo powers **[tillerstead.com](https://tillerstead.com)** — a New Jersey–licensed home improvement business providing tile, bath, and remodel craftsmanship across Atlantic County and South Jersey.
Optimized for **GitHub Pages** and **Netlify**, using pure **HTML/CSS/JS** for speed and maintainability.

---

## 🚀 Quick Start

### Local Development (Simple HTTP Server)
⚠️ **WARNING**: Serving files directly from the root will NOT work correctly.

```bash
# ❌ DO NOT DO THIS - will show blank page with raw Liquid templates
python3 -m http.server
```

### Production Build (Recommended for Local Testing)
The site uses Jekyll for templating and MUST be built before viewing:

```bash
# 1. Install Node dependencies and build CSS
npm install
npm run build

# 2. Install Ruby dependencies (vendored Jekyll)
bundle config set --local path 'vendor/bundle'
bundle install

# 3. Build the site to ./_site
JEKYLL_ENV=production bundle exec jekyll build

# 4. Serve the BUILT site (not the root directory!)
cd _site && python3 -m http.server 8000
# Open http://localhost:8000
```

### Automatic Deployment
The site deploys automatically when changes are pushed to `main`:

- **GitHub Pages**: `.github/workflows/pages.yml` builds Jekyll and deploys to Pages
  - Builds CSS from SCSS
  - Processes Jekyll templates
  - Deploys `_site/` directory to GitHub Pages
  - **CRITICAL**: GitHub Pages must be configured to deploy from GitHub Actions (not branch)

- **Netlify** (if configured): Uses build command from `netlify.toml` or deploy settings

---

## 🎨 Building CSS from SCSS

The site uses a modular SCSS structure for maintainability. CSS must be compiled before deployment.

### Compile SCSS
```bash
# Install npm dependencies (includes sass compiler)
npm install

# Compile SCSS to CSS (one-time)
npm run build:css

# Watch mode for development (auto-compile on changes)
npm run watch:css
```

This compiles `src/scss/theme.scss` into `assets/css/theme-compiled.css`.

### SCSS Structure
- `src/scss/_common.scss` - Base styles, reset, typography
- `src/scss/components/` - UI components (buttons, cards, header, footer, etc.)
- `src/scss/layouts/` - Page and section layouts
- `src/scss/utilities/` - Spacing and text utilities

### Theme building blocks

- **`components/_hero.scss`** – token-driven hero with pattern overlays, CTA pairs, and KPI grid.
- **`components/_cards.scss`** – shared card shell powering plan cards, reviews, services, and about sections.
- **`layouts/_sections.scss`** – global section spacing, eyebrows, and CTA alignment for any page.
- **`src/styles/tokens.css`** – master list of color, spacing, and typography tokens consumed by every module.

See `src/scss/README.md` for detailed documentation.

---

## 🎨 Design assets
- `assets/img/patterns/sacred-tile.svg` — geometric tile used for the hero surface texture. Adjust scale and opacity via the `.hero-surface::before` rule in `assets/css/theme.css`.

---

## 🎨 Theme & Design Tokens

The Tillerstead site uses a **token-driven stylesheet** for easy theme customization. All colors, spacing, typography, and visual properties are defined once in design tokens and used throughout the site.

### How to Edit the Theme

**All design tokens are defined in:** `src/styles/tokens.css`

#### Quick Start: Change the Primary Color

1. Open `src/styles/tokens.css`
2. Find the `--color-primary` token (around line 12)
3. Change the color value:
   ```css
   --color-primary: #3b82f6;  /* Change from #1ac87a to blue */
   ```
4. Save and refresh your browser

**That's it!** The primary color will update across:
- All buttons and links
- Hero section accents
- Border highlights
- Call-to-action elements

#### Available Token Categories

| Category | Location | Examples |
|----------|----------|----------|
| **Colors** | `:root` block | `--color-primary`, `--color-accent`, `--color-surface` |
| **Gradients** | Gradient section | `--gradient-primary`, `--gradient-surface` |
| **Typography** | Typography section | `--font-sans`, `--heading-1`, `--font-size-base` |
| **Spacing** | Spacing scale | `--space-1` through `--space-12` |
| **Shadows** | Shadows section | `--shadow-soft`, `--shadow-lift` |
| **Borders** | Border radius section | `--radius-sm`, `--radius-pill` |

#### View All Tokens

Open `public/theme-demo.html` in your browser to see:
- Every token value displayed with visual examples
- Live samples of colors, gradients, typography, and spacing
- All utility classes in action
- Instructions for making changes

```bash
# Serve locally
python3 -m http.server
# then open http://localhost:8000/public/theme-demo.html
```

#### Common Customizations

**Change heading fonts:**
```css
--font-sans: "Your Font", system-ui, sans-serif;
```

**Adjust spacing throughout site:**
```css
--space-4: 1.25rem;  /* Increase from 1rem */
```

**Modify the back-splash gradient:**
```css
--gradient-primary: linear-gradient(135deg, #your-color-1 0%, #your-color-2 100%);
```

**Update shadow intensity:**
```css
--shadow-soft: 0 20px 35px rgba(2, 6, 23, 0.5);
```

#### Utility Classes

The token system includes utility classes for rapid development:

```html
<!-- Typography -->
<p class="text-primary">Primary colored text</p>
<h2 class="heading-2">Consistent heading style</h2>

<!-- Backgrounds -->
<div class="bg-gradient">Gradient background</div>
<div class="bg-surface-elevated">Elevated surface</div>

<!-- Spacing -->
<div class="mt-4 mb-6 p-5">Margin & padding utilities</div>

<!-- Borders & Shadows -->
<div class="rounded-lg shadow-lift">Styled card</div>
```

See `public/theme-demo.html` for the complete list of utility classes.

#### Browser Support

The token system uses CSS Custom Properties (CSS variables), which are supported in:
- Chrome/Edge 49+
- Firefox 31+
- Safari 9.1+
- All modern mobile browsers

For older browsers, the site will use fallback values defined in the CSS.

---

## Unified Hero Component

All pages now use `{% include unified-hero.html %}`.  
Front‑matter fields supported:

| Field | Description |
|-------|-------------|
| `hero_eyebrow` | Small upper‑text line |
| `hero_title` | Main headline (falls back to `page.title`) |
| `hero_summary` | Lead paragraph |
| `hero_cred_line_1` / `hero_cred_line_2` | Optional credential lines |
| `hero_primary_url` / `hero_primary_label` | Primary CTA |
| `hero_secondary_url` / `hero_secondary_label` | Secondary CTA |
| `hero_kpis` (array) | KPI cards – each item needs `label` & `text` |
| `hero_bg_pattern` | Slug of a pattern file in `assets/img/patterns/` (e.g. `sacred-tile`). If omitted, `default` is used. |
| `hide_hero: true` | Skip the hero on a page. |

### Adding a new background pattern

1. Drop the SVG/PNG into `assets/img/patterns/` (e.g. `my‑pattern.svg`).  
2. Add a class to `assets/css/_hero-patterns.css`:  

```css
.hero-bg-my-pattern .hero-surface::before {
  background-image: 
    url('/assets/img/patterns/my-pattern.svg'),
    radial-gradient(
      circle at 85% 25%,
      rgba(26, 200, 122, 0.35),
      transparent 55%
    );
}
```

3. Reference the slug in front‑matter: `hero_bg_pattern: "my-pattern"`.

## CI & Deployment

Every PR runs ESLint, HTMLHint, and a full Jekyll build. Fix any lint errors before merging.

### GitHub Pages Configuration

**CRITICAL**: GitHub Pages must be configured to deploy from **GitHub Actions**, not directly from a branch.

To verify/configure:
1. Go to repository Settings → Pages
2. Under "Build and deployment"
3. Set **Source** to "GitHub Actions" (not "Deploy from a branch")

If set to deploy from a branch, the site will serve raw source files and show a blank page.

### Troubleshooting Blank Page

If you see a blank page with just a loading screen:

**Symptom**: Page shows white space with loading animation that never disappears.

**Cause**: Site is being served without Jekyll processing (raw source files).

**Fix**: 
1. Ensure GitHub Pages is set to deploy from "GitHub Actions" (see above)
2. Push to `main` branch to trigger `.github/workflows/pages.yml`
3. Wait for deployment to complete
4. Clear browser cache and reload

**Local Testing**:
```bash
# ✅ CORRECT - Build and serve _site/
npm install && npm run build
bundle install
bundle exec jekyll build
cd _site && python3 -m http.server

# ❌ WRONG - Serves raw files, shows blank page
python3 -m http.server  # from repo root
```

---

## Changelog

### 2025-11-17: Website Restructure
**Major improvements to code organization and header styling**

#### Cleanup
- ✅ Removed `index.backup.html` (redundant backup file)
- ✅ Removed `_archive/` directory (old theme demos and documentation)
- ✅ Consolidated CSS loading to reduce HTTP requests

#### CSS Modernization
- ✅ Created modular SCSS structure in `src/scss/`:
  - `_common.scss` - Base styles, reset, typography
  - `components/` - Buttons, cards, header, footer, hero, forms
  - `layouts/` - Page and section layouts
  - `utilities/` - Spacing and text utilities
- ✅ Compiled SCSS to `assets/css/theme-compiled.css`
- ✅ Replaced multiple CSS imports with single compiled file
- ✅ Added npm build scripts: `npm run build:css` and `npm run watch:css`
- ✅ Maintained backward compatibility with legacy `--ts-*` tokens

#### Header Enhancement
- ✅ **Professional gradient background** with transparency (no more "ugly solid background")
- ✅ **Backdrop blur** for modern glass effect
- ✅ **Improved color contrast** with primary color (#1ac87a) accents
- ✅ **Professional shadows** for elevation and depth
- ✅ **Enhanced hover states** with smooth transitions
- ✅ **Better mobile responsiveness** with refined breakpoints

#### Documentation
- ✅ Added `src/scss/README.md` with full SCSS structure documentation
- ✅ Updated main README.md with changelog
- ✅ Documented build process for CSS compilation

#### Build Process
```bash
# Install dependencies
npm install

# Compile SCSS to CSS
npm run build:css

# Watch for SCSS changes (development)
npm run watch:css

# Run linters
npm run lint
```

**Note**: The homepage requires Jekyll processing to render properly. Either:
1. Build with Jekyll: `bundle exec jekyll build` (requires Ruby/Bundler)
2. Deploy to GitHub Pages or Netlify (automatic Jekyll processing)
3. Serve locally: `python3 -m http.server` after Jekyll build

