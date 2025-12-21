# Recommended Products Page – Setup & Compliance Guide

## ✅ Amazon Associate Links – Active & Verified

The following Amazon short links are fully integrated with affiliate tracking—no action required:
- [`amzn.to/49rOXIT`](https://amzn.to/49rOXIT) — DGSL Tile Leveling System (TCNA-compliant)
- [`amzn.to/4p6jqBU`](https://amzn.to/4p6jqBU) — Cotton Farm Cheesecloth (ANSI A108.02 compatible)
- [`amzn.to/4atkxIk`](https://amzn.to/4atkxIk) — BOSCH Laser Distance Measure (meets TCNA layout standards)
- [`amzn.to/4qls9kO`](https://amzn.to/4qls9kO) — Room By Room Project Planner

All use Amazon’s short URL format with embedded affiliate tags for accurate commission tracking.

---

## ⚠️ Action Required: Replace Placeholder Tags

**All other product links** still use the placeholder `YOUR-AMAZON-TAG`.  
**You must update these for compliance and commission eligibility:**

### How to Find Your Amazon Associate Tag

1. Log in to [Amazon Associates Central](https://affiliate-program.amazon.com/)
2. Go to **Product Linking** → **Link to Any Page**
3. Locate your Associate ID (format: `yourname-20` or `tillerstead-20`)

### Update All Placeholder Tags

In `/workspaces/Tillerstead-live/pages/recommended-products.html`, search for:

```
tag=YOUR-AMAZON-TAG
```

Replace with your actual tag (e.g., `tillerstead-20`):

```
tag=tillerstead-20
```

#### Example

**Before:**
```html
https://www.amazon.com/dp/B001QUZEEU?tag=YOUR-AMAZON-TAG&linkCode=ogi&th=1
```
**After:**
```html
https://www.amazon.com/dp/B001QUZEEU?tag=tillerstead-20&linkCode=ogi&th=1
```

---

## Product Link Format & Compliance

- All links must use:  
    `https://www.amazon.com/dp/ASIN?tag=YOUR-TAG&linkCode=ogi&th=1`
- `tag=` — Your Amazon Associate ID (required for NJ HIC/FTC compliance)
- `linkCode=ogi` — Organic link code for transparent tracking
- `th=1` — Ensures correct product variation

**If a product is discontinued:**
1. Find a TCNA/ANSI-compliant replacement on Amazon
2. Copy the new ASIN (after `/dp/` in the URL)
3. Update the link, maintaining the affiliate format

---

## FTC & NJ Consumer Protection Compliance

- **Disclosure:** Prominent, above-the-fold affiliate disclosure is required (per FTC & NJ HIC)
- **Link Attributes:** All affiliate links must include `rel="nofollow noopener"` for legal and SEO compliance
- **Transparency:** Clearly state that prices are identical for users and that Tillerstead earns a commission
- **Disclaimer:** No medical/safety claims beyond manufacturer specs; no price guarantees

---

## Pre-Launch Testing Checklist

- [ ] All `YOUR-AMAZON-TAG` placeholders replaced with valid Associate ID
- [ ] Minimum 3 affiliate links tested for correct redirection
- [ ] Page renders and navigates correctly on mobile and desktop
- [ ] Disclosure card visible above the fold
- [ ] All blog and reference links functional
- [ ] HTML passes W3C validation and accessibility checks

---

## Ongoing Maintenance

**Monthly:**
- Audit all Amazon links for breakage or product changes (Amazon frequently updates ASINs)
- Update product notes for availability and compliance with latest TCNA/ANSI standards

**Quarterly:**
- Review and update product recommendations for new releases or code changes
- Confirm all FTC/NJ HIC disclosures and link attributes remain current

---

## Adding New Products

1. **Verify Compliance:** Confirm product meets ANSI/TCNA standards (see manufacturer specs)
2. **Technical Guidance:** Add installation tips or best practices (cite TCNA/ANSI where possible)
3. **Cross-Link:** Reference relevant blog posts or guides for added value
4. **Consistent Structure:** Use the established product-card HTML/CSS for accessibility and clarity

---

## Analytics & Tracking (Optional)

For advanced tracking, append UTM parameters:

```
?tag=tillerstead-20&linkCode=ogi&utm_source=tillerstead&utm_medium=affiliate&utm_campaign=recommended-products
```

---

## Legal & Accessibility Notes

- **Disclosure:** Must appear within 200 words of the first affiliate link (FTC/NJ HIC)
- **Link Attributes:** `rel="nofollow noopener"` required on all affiliate links
- **No Guarantees:** Do not promise pricing, availability, or make unsupported claims
- **Accessibility:** All alt text, labels, and descriptions must meet WCAG 2.1 AA standards

---

**Last Updated:** December 20, 2025  
**Page Location:** `/pages/recommended-products.html`  
**Navigation:** Secondary nav & footer Resources section

---

_Reference: See `/.ai/DOMAIN.md` for TCNA/NJ HIC compliance, `/.ai/COMPLIANCE.md` for legal, and `/.ai/OUTPUT_RULES.md` for formatting._
