# CSS Architecture: Path A

Tillerstead’s CSS architecture is engineered for maintainability, technical transparency, and strict compliance with TCNA 2024 and NJ HIC standards. This “Path A” structure ensures every layer has a clear, auditable responsibility, with all design tokens centralized for consistency and regulatory traceability.

## Directory Structure

- `00-settings`: Centralized design tokens (`_tokens.scss`) for color, typography, spacing, layout, and border radii. All variables are WCAG-compliant and mapped to accessible CSS custom properties.
- `10-base`: Standards-driven resets and typographic defaults, normalizing HTML elements per TCNA guidelines before component styling.
- `20-layout`: Page-level primitives (`_container.scss`, `_grid.scss`, `_tillerstead-theme.scss`) for shells, grids, and themed surfaces. All layout logic references tokens—no hard-coded values.
- `30-components`: Modular UI elements (buttons, cards, hero, header/footer, breadcrumbs, forms, plans, deliverables, social links). Includes a legacy `theme` import shim for backward compatibility.
- `40-utilities`: Single-responsibility helper classes for spacing, display, alignment, and rapid overrides. Utilities are atomic and documented for accessibility.

## Tokenization & Variables

- **Layout Width:**  
    Use `--layout-max`, `--layout-wide`, `--layout-narrow`, and `--container-gutter` for all width constraints. `--shell-width` aliases `--layout-max` for legacy support. No fixed pixel widths outside tokens.
- **Spacing:**  
    All vertical rhythm and block spacing use `--ts-spacing-*` tokens (e.g., `--section-padding-y`, `--section-gap`), mirrored by `--space-*` aliases for clarity. Layout helpers (`--flow-space`, `--stack-gap`, `--cluster-gap`) enable per-block tuning without new utility classes.
- **Typography:**  
    Type ramp is defined by `--heading-*`, `--font-size-*`, `--line-height-*`, and `--font-*` tokens, ensuring consistent, accessible text across all components and layouts.
- **Color & Shadows:**  
    Brand and surface contrast are governed by `--ts-color-*` tokens, gradients, and shadow variables. No ad-hoc hex codes or non-tokenized colors are permitted, ensuring full traceability and compliance.

## Selector & Authoring Strategy

- Flattened selectors for typography (lists, links, blockquotes, `pre code`) keep specificity low and output predictable, maintainable.
- Layout/grid helpers are authored as utility classes—no mixins or functions—so compiled CSS is transparent and easily audited.
- The theme shim (`30-components/_theme.scss`) re-exports layout tokens for legacy imports; all new code must import from `20-layout/_tillerstead-theme.scss`.

## Authoring Principles

- **Prioritize Layout Primitives:**  
    Use `.container`, `.section`, `.stack`, `.cluster`, `.switcher`, `.grid-cols-*` before introducing component-specific layout rules.
- **Token-First Approach:**  
    All new components must reference width (`--layout-*`), spacing (`--ts-spacing-*`), and color tokens. Hard-coded values are prohibited.
- **Incremental Utilities:**  
    Utilities reside in `40-utilities` only. Structural spacing and layout logic remain in `20-layout` to prevent duplication and ensure maintainability.
- **Accessibility & Compliance:**  
    All classes, tokens, and patterns are documented for accessibility and legal compliance per NJ Consumer Fraud Act and WCAG 2.2 AA. Alt text, ARIA labels, and semantic markup are mandatory.

---

**Reference:**  
For all code, naming, and formatting decisions, consult `/.ai/OUTPUT_RULES.md`. For technical authority and compliance, see `/.ai/DOMAIN.md` and `/.ai/COMPLIANCE.md`.  
*This architecture is subject to continuous audit and improvement—report any deviation or ambiguity to the project maintainers.*

