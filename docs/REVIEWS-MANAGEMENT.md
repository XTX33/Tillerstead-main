# Review Management Guide

## Overview
Homepage client reviews are dynamically rendered from `_data/reviews.yml` using the testimonials component, which displays Thumbtack-verified feedback with accessible, brand-compliant styling. All testimonial workflows and display logic adhere to TCNA 2024 standards and NJ HIC regulations.

## System Architecture
- **Homepage Section:** `_includes/sections/testimonials.html`
- **Component:** `_includes/ts-testimonials.html`
- **Primary Data Source:** `_data/reviews.yml`
- **Staging Data:** `_data/reviews-manual.yml`
- **Styling:** `_sass/30-components/_home.scss`
- **Homepage Display:** Shows the 3 most recent reviews (configurable in `_data/home.yml`)

## Key Features
- **Thumbtack Verification:** Clickable, accessible badge with checkmark icon and external link (opens in new tab, `rel="noopener nofollow"`)
- **Star Ratings:** 1–5 stars, visually and programmatically accessible
- **Metadata:** Author (first name + last initial), NJ location, job type, ISO date
- **Custom Badges:** e.g., “Great Communication”, “On Time”, “Expert”
- **Responsive Layout:** Card grid, mobile-first, WCAG-compliant contrast and focus states
- **Brand Styling:** All elements styled per design tokens and accessibility guidelines

## Review Data Flow

### Automatic Sync (Preferred)
- Run `scripts/sync_thumbtack_reviews.js` to fetch and update `_data/reviews.yml` with verified Thumbtack reviews.
- All synced reviews are validated for required fields and compliance.

### Manual Entry (Fallback)
- Use `_data/reviews-manual.yml` to stage new or unsynced reviews.
- Manual entries must meet all field and formatting requirements before publishing.

## Adding Reviews Manually

### 1. Create Review Entry
Add a new review to `_data/reviews-manual.yml` using this schema:

```yaml
- id: thumbtack-firstname-lastname-YYYY-MM-DD-1
  source: Thumbtack
  platform: Thumbtack
  rating: 5
  rating_max: 5
  quote_html: <p>Review text in semantic HTML.</p>
  author: John D.
  location: Galloway, NJ
  job_type: Bathroom Remodel
  date: '2025-12-20'
  badges:
    - Great Communication
    - On Time
  url: https://www.thumbtack.com/nj/absecon/tile/tillerstead-llc/service/547437618353160199
```

**Field Requirements:**
- `id`: Unique, kebab-case, format: `thumbtack-firstname-lastname-YYYY-MM-DD-#`
- `source`/`platform`: Always “Thumbtack”
- `rating`: Integer 1–5
- `rating_max`: Always 5
- `quote_html`: Semantic HTML (use `<p>`, `<ul>`, etc.); ensure accessibility
- `author`: First name + last initial (privacy-compliant)
- `date`: ISO format, quoted
- `url`: Thumbtack profile link (for verification badge)

**Optional:**
- `location`: NJ city/town
- `job_type`: e.g., “Bathroom Remodel”, “Tile Installation”
- `badges`: Array of descriptors (e.g., “Expert”, “On Time”)

### 2. Validate and Publish
- Confirm all fields are present and valid.
- Copy the entry from `_data/reviews-manual.yml` to the `reviews:` array in `_data/reviews.yml`.
- Ensure no duplicate `id` values.

## Example: Multi-Paragraph Review

```yaml
- id: thumbtack-sarah-m-2025-11-15-1
  source: Thumbtack
  platform: Thumbtack
  rating: 5
  rating_max: 5
  quote_html: |
    <p>Devon’s TCNA-compliant installation exceeded expectations. Every tile was perfectly aligned, and waterproofing was meticulously documented.</p>
    <p>He explained each step, referencing industry standards. Six months later, the shower remains flawless.</p>
  author: Sarah M.
  location: Egg Harbor Township, NJ
  job_type: Master Bath Renovation
  date: '2025-11-15'
  badges:
    - Expert
    - Great Value
    - On Time
  url: https://www.thumbtack.com/nj/absecon/tile/tillerstead-llc/service/547437618353160199
```

## Verification Badge
- **Badge Content:** “Verified on Thumbtack” with checkmark icon
- **Accessibility:** Alt text, keyboard focus, visible label
- **Link:** Opens Thumbtack profile in new tab (`rel="noopener nofollow"`)
- **Styling:** Brand colors, high-contrast, WCAG-compliant

## Styling & Accessibility
All testimonial styles are in `_sass/30-components/_home.scss`:
- `.ts-testimonial`: Card container
- `.ts-testimonial__quote`: Accessible quote text
- `.ts-testimonial__stars`: Star rating (aria-label, visible text fallback)
- `.ts-testimonial__meta`: Author, date, location
- `.ts-testimonial__verify`: Thumbtack badge (focusable, descriptive)
- `.ts-testimonial__badge`: Custom badges (aria-labels for screen readers)

**Accessibility:** All elements must pass aXe and Lighthouse audits. Use semantic HTML and ARIA where appropriate.

## Troubleshooting

### Reviews Not Displaying
1. Confirm `_data/reviews.yml` contains valid `reviews:` entries.
2. Check `_data/home.yml` for correct testimonials config.
3. Validate `testimonials.limit` (default: 3).
4. Run `bundle exec jekyll build` and resolve any build errors.

### Missing Verification Badge
- Ensure `url` and `platform` fields are present and valid.

### Styling Issues
- Confirm `_sass/30-components/_home.scss` is compiled.
- Validate design tokens and CSS custom properties.
- Clear browser cache and rebuild site.

## Testing & Validation

To test reviews locally:
```bash
bundle exec jekyll serve
"$BROWSER" http://localhost:4000
```
- Validate output with HTMLHint, ESLint, and accessibility tools.
- Confirm all links, badges, and metadata render as expected.

## File Reference
- **Live Data:** `_data/reviews.yml`
- **Manual Staging:** `_data/reviews-manual.yml`
- **Component:** `_includes/ts-testimonials.html`
- **Styles:** `_sass/30-components/_home.scss`
- **Homepage Config:** `_data/home.yml`
- **Section Include:** `_includes/sections/testimonials.html`

---

**Support the HTML Development Fund:** Every verified review builds trust and demonstrates Tillerstead’s technical rigor. Visit the Products page to help fund ongoing, standards-driven development.

---

*All review management and display logic must comply with TCNA 2024, NJ HIC, and the operational rules in `/.ai/`. For detailed standards, see `/.ai/DOMAIN.md` and `/.ai/COMPLIANCE.md`.*
