```md
# Tillerstead LLC – Public Website (Jekyll)

This repository contains the source for **Tillerstead.com**, the public website for  
**Tillerstead LLC** — a licensed South Jersey tile, waterproofing, and remodeling contractor  
serving Atlantic, Ocean, and Cape May Counties.

The site is built on **Jekyll** and deployed through **GitHub Pages** with a structured design  
system, reusable components, and optimized SVG branding assets.

---

## ⚒️ Project Overview

Tillerstead.com provides:

- Professional service pages for tile, waterproofing, remodeling, and repair scopes  
- A structured case & portfolio system using Jekyll Collections  
- Visual documentation of real South Jersey tile installations  
- High-quality logo assets and responsive UI elements  
- A lightweight, fast, SEO-optimized static site

---

## 🏗️ Tech Stack

- **Jekyll** (GitHub Pages-compatible)
- **SCSS** with component-based structure (`_sass/`)
- **Liquid** templating (`_includes/`, `_layouts/`)
- **SVG symbol sprite** for all branding
- **Tokens.css** for centralized color & spacing variables
- **Responsive design** for all mobile/tablet/desktop breakpoints

---

## 📂 Repository Structure

```

.
├── _layouts/        # Page layouts (default, page, post, service, portfolio)
├── _includes/       # Components (header, footer, nav, hero, cards, logos)
├── _sass/           # SCSS design system, tokens, components
├── _cases/          # Case studies (Jekyll collection)
├── _posts/          # Blog posts
├── assets/
│   ├── css/         # Main SCSS entry points (compiled by Pages)
│   ├── js/          # Interactive behavior (header/nav)
│   └── img/
│       └── logo/    # Optimized SVG branding assets + logo sprite
├── _config.yml      # Site configuration
└── README.md        # This file

```

---

## 🎨 Branding & Logo Assets

All Tillerstead logo files are stored in:

```

assets/img/logo/

```

Optimized, token-aware SVGs allow color and theme changes to propagate automatically through  
the site’s design system.

### Primary Logo Files

- `tillerstead-logo-header.svg` – Primary horizontal logo for the site header  
- `tillerstead-logo-header-dark.svg` – Header logo for dark backgrounds  
- `tillerstead-logo-full.svg` – Full logo with tagline + NJ HIC license  
- `tillerstead-logo-stacked.svg` – Vertical/stacked version  
- `tillerstead-logo-mark.svg` – Tile “T” mark  
- `tillerstead-logo-mark-with-word.svg` – Compact lockup  
- `tillerstead-inverse.svg` – Light-on-dark inverse logo  
- `tillerstead-favicon.svg` – Base mark for favicon and app icons  
- `tillerstead-logo-sprite.svg` – Complete SVG symbol sprite (recommended for UI)

A detailed guide lives at:

```

assets/img/logo/README.md

````

---

## 🧩 Using the SVG Sprite

You can reference logos from the sprite like this (cached external reference):

```html
<svg role="img" aria-label="Tillerstead LLC">
  <use href="/assets/img/logo/tillerstead-logo-sprite.svg#logo-full"></use>
</svg>
````

Monochrome (inherits text color):

```html
<svg class="text-primary">
  <use href="/assets/img/logo/tillerstead-logo-sprite.svg#logo-full-mono"></use>
</svg>
```

Mark-only:

```html
<svg width="40" height="40">
  <use href="/assets/img/logo/tillerstead-logo-sprite.svg#logo-mark"></use>
</svg>
```

For inline usage, include:

```liquid
{% include logo-sprite-inline.html %}
```

---

## 🧪 Local Development

Install Jekyll:

```bash
bundle install
```

Run the dev server:

```bash
bundle exec jekyll serve
```

Then open:

```
http://localhost:4000
```

---

## 🚀 Deployment

The site deploys automatically via **GitHub Pages** on updates to the `main` branch.

No manual build steps are required—GitHub handles SCSS compilation and static generation.

---

## 🛡️ License & Ownership

All branding, logos, trademarks, and service descriptions are the property of **Tillerstead LLC**.
Code for the public site is open for review but not for reuse without written permission.

---

## 🤝 Contributions

This is primarily a closed-brand repository; PRs are limited to internal improvements, bug fixes,
and accessibility updates.
