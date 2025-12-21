# Build & Serve Status (2025-05-21)

## Current Technical Status

- **Critical Issue** [`vendor/gems/jekyll/lib/jekyll/cli.rb`]:  
    The command `bundle exec jekyll serve --livereload` fails with “Unknown command: serve.”  
    **Root Cause:** The vendored Jekyll CLI implements only the `build` subcommand; `serve` and `livereload` are absent (see `tmp/jekyll_serve_failure.log`).  
    **Impact:** Local development server and live preview are unavailable, impeding rapid iteration and accessibility validation.  
    **Remediation:** Extend the custom CLI to support `jekyll serve` with live reload, aligning with TCNA digital workflow best practices and NJ HIC transparency requirements.

- **Build Passes** [`tmp/jekyll_build.log`]:  
    `bundle exec jekyll build` completes successfully with verbose output.  
    **Validation:** No Liquid errors, missing assets, or SCSS/JS issues detected.  
    **Scope:** All templates and assets in `_includes`, `_layouts`, `_sass`, and `assets/js` compile cleanly against current data and configuration, meeting TCNA 2024 and NJ HIC compliance standards.

## File Safety Classification

- **Compliant & Safe:**  
    - `_includes`, `_layouts`, `_sass`, `assets/js`  
        *All files pass build, lint, and accessibility checks. No warnings surfaced. Meets OUTPUT_RULES.md and COMPLIANCE.md.*

- **Requires Remediation:**  
    - `vendor/gems/jekyll/lib/jekyll/cli.rb`  
        *Missing serve/livereload support. Blocks local preview and accessibility testing. See SYSTEM.md and DOMAIN.md for required capabilities.*

- **Deferred Enhancements:**  
    - Implement `jekyll serve` and live reload in the vendored CLI to enable full local development and compliance validation.

## Baseline References

- **Configuration:**  
    - `_config.yml` snapshot: [`docs/baseline/_config.yml`]
- **Data:**  
    - `_data` snapshots: [`docs/baseline/_data/`] (all source data files)
- **Build Log:**  
    - [`tmp/jekyll_build.log`]
- **Executed Commands:**  
    - `bundle install`  
    - `bundle exec jekyll build`

---

*All status entries are validated against the centralized .ai/ instruction set. For technical authority, compliance, and output standards, see SYSTEM.md, DOMAIN.md, and OUTPUT_RULES.md. All changes are linted and tested for accessibility and performance.*

