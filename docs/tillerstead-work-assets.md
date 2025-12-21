# Tillerstead Work Asset Audit

This document inventories all assets in `assets/img/tillerstead-work`, details their usage, and codifies naming, metadata, and compliance standards for future uploads. All practices reflect TCNA 2024 guidelines, NJ HIC requirements, and Tillerstead’s commitment to technical transparency and accessibility.

## Asset Management Standards

- **Naming:** All files use kebab-case, descriptive, and phase-specific names (see OUTPUT_RULES.md).
- **Formats:** JPEG and WebP variants are maintained for browser compatibility and performance. WebP-only assets are clearly documented.
- **Metadata:** Every asset is registered in `_data/portfolio.yml` with accessible alt text, captions, and tags. All descriptions meet WCAG 2.1 AA and NJ Consumer Fraud Act standards.
- **Categories:** Assets are grouped by project type—bathrooms, remodels, repairs—using explicit tags for filtering and legal clarity.

## Asset Inventory & Usage

| Base Name                          | JPEG | WebP | Usage & Tags                                                                                  | Priority / Notes                                                                                  |
|-------------------------------------|------|------|-----------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| bathroom-accent-wall-progress       | Yes  | Yes  | Portfolio slider (`tags: showers`), services cards                                            | High-visibility; demonstrates waterproofing and substrate prep per TCNA B421.                     |
| bathroom-accent-wall-detail         | Yes  | Yes  | Slider, services cards                                                                        | Retain; highlights grout joint alignment and finish.                                              |
| bathroom-accent-wall-and-shower     | Yes  | Yes  | Slider, hero defaults, services                                                               | Key asset; illustrates full-system integration (membrane, tile, fixtures).                        |
| bathroom-floor-ditra-progress       | Yes  | Yes  | Slider, highlights                                                                            | Shows uncoupling membrane install (TCNA F144); essential for technical credibility.               |
| bathroom-floor-install-progress     | Yes  | Yes  | Slider, highlights                                                                            | Documents substrate prep and tile layout; supports compliance messaging.                          |
| bathroom-marble-floor-finish        | Yes  | Yes  | Slider, hero image, highlight                                                                 | Hero fallback; demonstrates premium material handling and finish.                                 |
| bathroom-marble-shower-niche        | Yes  | Yes  | Slider, highlight, pattern showcase                                                           | Used in preload hooks; showcases waterproofing and custom fabrication.                            |
| bathroom-shower-valve-wall-progress | Yes  | Yes  | Slider                                                                                        | Retain; illustrates valve placement and waterproofing sequence.                                   |
| bathroom-shower-wall-progress       | Yes  | Yes  | Slider                                                                                        | Retain; shows wall prep and tile setting per TCNA B411.                                           |
| bathroom-threshold-leveling-progress| Yes  | Yes  | Slider                                                                                        | Retain; demonstrates substrate leveling and transition detail.                                    |
| ceiling-repair                      | No   | Yes  | Slider (`tags: repairs`)                                                                      | Retain for “Repairs” filter; highlights patching and finish blending.                             |
| bathroom-remodel-progress-1         | No   | Yes  | Slider (`tags: remodels, showers`); alt: “Bathroom remodel—demolition and plumbing prep”      | Added; documents demo and rough-in, supporting transparency.                                      |
| bathroom-remodel-progress-2         | No   | Yes  | Slider (`tags: remodels, floors`); alt: “Bathroom remodel—subfloor and membrane installation” | Added; captures substrate and waterproofing, reinforcing TCNA compliance.                         |
| bathroom-remodel-finished           | No   | Yes  | Slider, highlights, hero defaults (`tags: remodels, showers, floors`); alt: “Completed bathroom remodel—tile, fixtures, and finish” | Added; now default hero image, exemplifies finished scope and code compliance.                    |

## Implementation & Compliance Actions

1. **Renamed remodel assets** to `bathroom-remodel-progress-1.webp`, `bathroom-remodel-progress-2.webp`, and `bathroom-remodel-finished.webp` for clarity and traceability (OUTPUT_RULES.md).
2. **Registered all assets** in `_data/portfolio.yml` with descriptive, accessible alt text and captions per WCAG 2.1 AA and NJ HIC.
3. **Introduced a “Remodels” filter** in `pages/portfolio.html` and updated `TAG_LABELS` for explicit category navigation.
4. **Promoted `bathroom-remodel-finished.webp`** to `_data/portfolio_highlights.yml` and `_config.yml` as the default hero image, maximizing conversion and technical authority.
5. **Ongoing catalog tracking:** This audit is the single source of truth for asset usage, compliance, and onboarding of new images. All future uploads must follow these conventions and be validated against linters, accessibility, and build tools.

## Technical & Legal Notes

- All asset references are validated for path accuracy and build compliance (Jekyll, HTMLHint, ESLint).
- Alt text and captions are reviewed for accessibility and NJ Consumer Fraud Act compliance.
- Categories and tags are explicit, non-overlapping, and mapped to user-facing filters for clarity and conversion.

**For any asset or metadata changes, consult the `.ai/` directory and cite the relevant rule. Zero tolerance for technical debt or non-compliance.**

