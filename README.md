# Tillerstead Site

## Ruby environment (Windows via RubyInstaller)
- Install [RubyInstaller 3.1+ with MSYS2](https://rubyinstaller.org/downloads/) and select option 3 to run `ridk install` when prompted so the DevKit and build tooling are configured.
- From a PowerShell terminal in the project root, run `powershell -ExecutionPolicy Bypass -File scripts/activate-ruby.ps1`. The helper locates your RubyInstaller installation, sources `ridk`/`setrbvars`, and installs Bundler `2.4.19` if it is missing.
- Re-run `scripts/activate-ruby.ps1` any time you open a fresh shell so the Ruby toolchain is on your `PATH` before invoking Bundler or Jekyll.
- If Ruby is installed in a non-standard directory, provide the path manually: `powershell -ExecutionPolicy Bypass -File scripts/activate-ruby.ps1 -RubyRoot 'D:\Tools\Ruby32-x64'`.

### Typical workflow
```powershell
# Activate Ruby (installs Bundler on first run)
powershell -ExecutionPolicy Bypass -File scripts/activate-ruby.ps1

# Install Ruby gems / Node dependencies once
bundle install
npm install

# Build the site
npm run build        # runs Sass build + bundle exec jekyll build
```

If `scripts/activate-ruby.ps1` cannot find RubyInstaller it will stop with a helpful message that includes the download URL. Once activated, the terminal echoes the Ruby version so you know the environment is ready.
# Tillerstead.com

A fast, client-safe static site for Tillerstead LLC, built with Jekyll and a handcrafted design system. The repo is tuned for long-term maintainability, SEO, and straightforward authoring by developers or content editors.

## At a Glance
- **Platform:** Jekyll static site with custom layouts and includes—no third-party themes.
- **Styling:** SCSS sources in [`src/scss`](src/scss) compiled to [`assets/css`](assets/css).
- **Content:** Markdown posts and pages in [`_posts`](./_posts) and [`pages`](./pages) with data-driven sections in [`_data`](./_data).
- **Templates:** Layouts and shared fragments live in [`_layouts`](./_layouts) and [`_includes`](./_includes).
- **Performance & SEO:** Minified CSS, sitemap, robots directives, and tightly written meta data in [`_config.yml`](./_config.yml) and [`manifest.webmanifest`](./manifest.webmanifest).
- **Deployment:** Suitable for static hosting (Netlify/GitHub Pages); build artifacts live in `_site/` when generated.

## Prerequisites
- **Ruby & Bundler** for Jekyll (`bundle install`).
- **Node.js & npm** for tooling (`npm ci` preferred for reproducibility).
- **Sass** and **Sharp** are installed via `npm ci`; no global installs required.

## Local / Codespaces dev
- **Codespaces:** Opening the repo in GitHub Codespaces auto-builds a dev container with Ruby 3.2 and Node 20. Dependencies install via `bundle install` + `npm ci` after the container is created.
- **Local machines:** Install Ruby 3.2 and Node 20, then run `bundle install && npm ci` in the project root.
- **Run the dev server:** `npm run dev` serves Jekyll on `http://127.0.0.1:4000` with LiveReload (`4000`/`35729` forwarded in Codespaces).
- **Build once:** `npm run build` compiles CSS and runs `bundle exec jekyll build`.
- **Test locally:** `npm run test` rebuilds the site and runs an internal link/asset check to verify the generated `_site` output. External link checks are skipped to keep runs offline-friendly.
- **Note:** Playwright/browser-based screenshot tooling is not installed in Codespaces for this repo—skip any screenshot capture steps.

## Getting Started
1. Install dependencies:
   - `bundle install`
   - `npm install`
2. Build CSS once:
   - `npm run build:css`
3. Start a local site:
   - `bundle exec jekyll serve`
4. Visit `http://127.0.0.1:4000` to preview.

## Development Workflow
- **Style changes:** Edit `src/scss/theme.scss` (and partials) then run `npm run watch:css` during development or `npm run build:css` for a one-off build.
- **Content updates:** Add or edit Markdown files in `_posts/` for dated content or `pages/` for evergreen pages. Use `_data/` YAML/JSON for repeatable content blocks.
- **Templates:** Modify `_layouts/` for page-level wrappers and `_includes/` for reusable fragments (headers, footers, CTAs).
- **Images:** Use `npm run images:webp` to generate WebP variants in-place under `assets/`.

## Quality & Linting
- Run `npm run lint` before committing to check JavaScript, HTML, and front-end conventions.
- Use `npm run format` to apply Prettier formatting across the project.
- The `build` script keeps compiled CSS compressed for fast page loads.

## SEO & Accessibility Practices
- Page metadata defaults live in `_config.yml`; keep titles, descriptions, and keyword lists relevant to South Jersey property services.
- Prefer semantic HTML in `_layouts/` and `_includes/` for accessibility; linting flags common ARIA issues.
- Keep image alt text descriptive and leverage WebP output for performance.

## Production Build
- Generate a full site (including CSS compilation) with:
  ```sh
  npm run build
  ```
- The built site appears in `_site/` and is ready to deploy to any static host (Netlify config is available in `netlify.toml`).

## Automation
- **CI:** GitHub Actions (`.github/workflows/ci.yml`) runs `npm run lint` plus `npm run test` on every push/PR and uploads `_site` as an artifact.
- **Pages + previews:** `.github/workflows/pages.yml` builds the site for production pushes to `main` and publishes preview deployments for pull requests. Preview URLs show up on the PR checks tab; forked PRs may skip previews if repository permissions restrict deployments.

## Project Structure
```
assets/           # Compiled and static assets (CSS, images, fonts)
src/scss/         # Source SCSS for the design system
_includes/        # Reusable HTML partials (navigation, footer, CTAs)
_layouts/         # Page and post layout templates
_posts/           # Blog or update entries (Markdown)
pages/            # Standalone pages (Markdown/HTML)
_data/            # YAML/JSON data powering dynamic sections
scripts/          # Utility scripts (e.g., image conversion)
test/             # Automated tests or fixtures
```

## Contributing
1. Create a feature branch.
2. Keep commits focused and linted (`npm run lint`).
3. Open a pull request with a clear summary and testing notes.

## License
This project is licensed under the MIT License; see [`LICENSE`](LICENSE) for details.
