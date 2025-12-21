# Clean Old Build Artifacts

```bash
rm -rf _site/
rm -f assets/css/main.css
```

# Rebuild CSS & Jekyll

```bash
npm run build
```

# Verify Output

```bash
grep -A5 "min-width.*921px" _site/assets/css/main.css
grep -A20 "ts-services" _site/index.html
```

---

# Tillerstead Repository Refactoring Marathon

**Date:** December 20, 2025  
**Purpose:** Comprehensive, standards-driven repository refactor using centralized AI governance  
**Authority:** All work governed by [`.ai/`](./.ai/) instruction system

---

## 🎯 MISSION STATEMENT

Refactor the Tillerstead LLC repository to achieve:

1. **Code Quality:** 100% compliance with [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md)
2. **Brand Consistency:** Copy aligned with [`/.ai/STYLE.md`](./.ai/STYLE.md)
3. **Technical Accuracy:** All tile/construction content verified against [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md)
4. **Legal Compliance:** All contracts/claims checked against [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) and `_data/compliance.yml`
5. **Build Health:** All scripts functional, tests passing, linters green

---

## 📋 PRE-FLIGHT CHECKLIST

### Before Starting

- [ ] Read [`/.ai/SYSTEM.md`](./.ai/SYSTEM.md) — Behavioral contract
- [ ] Read [`/.ai/COPILOT.md`](./.ai/COPILOT.md) — Copilot adaptation
- [ ] Review [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) — Code quality
- [ ] Confirm branch: `git status` (should be `main` or feature branch)
- [ ] Pull latest: `git pull origin main`
- [ ] Verify dependencies: `npm ci && bundle install`

### Environment Setup

```bash
node --version  # ≥14.x
ruby --version  # ≥2.7.x

npm ci
bundle install

npm run build:css
bundle exec jekyll build
npm run lint
```

---

## 🏃 MARATHON PHASES

### Phase 1: Build System Health

**Goal:** All build scripts functional and compliant

#### 1.1 Audit Build Scripts

```bash
npm run build:css
npm run build
npm run dev
npm run lint
npm run test
```

**Scripts to verify:**

- [ ] `scripts/build-css.js` — SCSS compilation
- [ ] `scripts/run-jekyll.sh` — Jekyll build wrapper
- [ ] `rebuild.sh` — Full clean rebuild
- [ ] `quick-build.sh` — Incremental build

**Reference:** [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §6

#### 1.2 Fix Build Script Issues

- Ensure `chmod +x` on all shell scripts
- Paths must be repo-root relative
- All dependencies declared in `package.json` and `Gemfile`

#### 1.3 Update Build Documentation

- [ ] `README.md` — Build instructions
- [ ] `.github/instructions/build-troubleshooting.md` — Add findings

---

### Phase 2: Code Quality Compliance

**Goal:** 100% compliance with [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md)

#### 2.1 HTML Semantic Audit

```bash
find . -name "*.html" ! -path "./node_modules/*" ! -path "./_site/*"
```

- [ ] Semantic HTML5 (`<header>`, `<nav>`, `<main>`, `<footer>`)
- [ ] Unique `<title>` (50–60 chars)
- [ ] Meta description (150–160 chars)
- [ ] Open Graph tags
- [ ] Proper heading hierarchy
- [ ] Descriptive `alt` text
- [ ] Explicit `<label>` for forms
- [ ] `aria-label` for icon-only buttons

**Reference:** [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §1

#### 2.2 CSS Token Migration

```bash
grep -r "color:" _sass/ assets/css/ | grep -v "var(--"
```

- [ ] Replace hard-coded colors, spacing, fonts, shadows, border-radius with tokens

**Reference:** [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §2.2

#### 2.3 JavaScript Modernization

```bash
find assets/js scripts/ -name "*.js" ! -path "./node_modules/*"
```

- [ ] ES6+ syntax
- [ ] Error handling
- [ ] Modern DOM methods
- [ ] JSDoc for complex functions
- [ ] Passes ESLint

**Reference:** [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §3

#### 2.4 Accessibility Compliance

```bash
npx htmlhint '**/*.html' --config .htmlhintrc
```

- [ ] Keyboard navigation
- [ ] Color contrast ≥ 4.5:1 (normal), ≥ 3:1 (large)
- [ ] Landmarks/roles
- [ ] Form validation feedback
- [ ] Focus indicators

**Reference:** [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §1.3

---

### Phase 3: Content Alignment

**Goal:** Copy matches [`/.ai/STYLE.md`](./.ai/STYLE.md), technical accuracy per [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md)

#### 3.1 Homepage Hero Audit

- [ ] Bold, specific headline (Law 6: Court Attention)
- [ ] Addresses pain point (Law 33: Thumbscrew)
- [ ] Technical specificity, contrast pattern
- [ ] No generic claims

**Reference:** [`/.ai/STYLE.md`](./.ai/STYLE.md) §4

#### 3.2 Service Descriptions Rewrite

- [ ] Technical specificity (TCNA, ANSI, ISO)
- [ ] Contrast patterns
- [ ] HIC license (#13VH10808800)
- [ ] Realistic timelines

**Reference:** [`/.ai/STYLE.md`](./.ai/STYLE.md) §4, [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md) §2

#### 3.3 About/Process Pages Personality

- [ ] Self-aware humor
- [ ] Directly address client frustrations
- [ ] Show technical competence
- [ ] Values alignment

**Reference:** [`/.ai/STYLE.md`](./.ai/STYLE.md) §3–4

#### 3.4 Blog Post Technical Accuracy

- [ ] Technical claims match [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md)
- [ ] Standards cited
- [ ] Material specs accurate
- [ ] Safety warnings, disclaimers

**Reference:** [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md), [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) §9

---

### Phase 4: Legal Compliance Verification

**Goal:** All content and claims comply with [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) and `_data/compliance.yml`

#### 4.1 HIC License Display Audit

```bash
grep -rn "13VH10808800" . --include="*.html" --include="*.md"
```

- [ ] Footer, contact, about, service, contract templates

**Reference:** [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) §1.1

#### 4.2 Marketing Claims Review

```bash
grep -ri "guarantee\|fastest\|best\|lowest" . --include="*.html" --include="*.md"
```

- [ ] No unsubstantiated or prohibited claims

**Reference:** [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) §2.2

#### 4.3 Disclaimer Audit

- [ ] DIY, estimates, blog, pre-1978 homes

**Reference:** [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) §3.3

#### 4.4 Payment Terms Compliance

- [ ] Deposit ≤ 10% or $1,000 (whichever less)
- [ ] 3-day rescission notice
- [ ] Progress-based schedule, itemized costs, change order procedures

**Reference:** [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) §2.2

---

### Phase 5: File Organization & Naming

**Goal:** All files follow [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) conventions

#### 5.1 File Naming Audit

```bash
find . -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" \) ! -path "./node_modules/*" ! -path "./_site/*"
```

- [ ] HTML/CSS/JS: kebab-case
- [ ] JS variables: camelCase
- [ ] Images: kebab-case

**Reference:** [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §1

#### 5.2 Directory Structure Verification

- Ensure structure matches OUTPUT_RULES.md and README.md

---

### Phase 6: Performance Optimization

**Goal:** Lighthouse scores per [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §5

#### 6.1 Lighthouse Audit

- [ ] Performance ≥ 90 (desktop), ≥ 85 (mobile)
- [ ] Accessibility ≥ 95
- [ ] Best Practices ≥ 95
- [ ] SEO ≥ 95

#### 6.2 Image Optimization

- [ ] WebP conversion
- [ ] `loading="lazy"`, `srcset`, compression, hero preload

#### 6.3 CSS Optimization

- [ ] Critical CSS inlined
- [ ] Async load non-critical CSS
- [ ] Minified, no unused CSS

#### 6.4 JavaScript Optimization

- [ ] `defer`/`async` for non-critical scripts
- [ ] No blocking scripts in `<head>`
- [ ] ES6 modules, deferred analytics

---

### Phase 7: Testing & Validation

**Goal:** All tests passing, linters green

#### 7.1 Linter Marathon

```bash
npm run lint
npx htmlhint '**/*.html'
npx eslint .
npx stylelint "**/*.{css,scss}"
```

#### 7.2 Jekyll Build Verification

```bash
rm -rf _site
npm run build
echo $?  # Should be 0
```

#### 7.3 Link Checking

```bash
npm run test
node scripts/check-links.js
```

#### 7.4 Browser Testing

- Chrome, Safari, Firefox, iOS, Android
- Navigation, forms, images, no console errors

---

### Phase 8: Git Hygiene & Commit

**Goal:** Clean, atomic commit history per [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md) §8

#### 8.1 Review Changes

```bash
git status
git diff
git add _sass/
git diff --staged
```

#### 8.2 Atomic Commits

- Separate commits for CSS, HTML, content, scripts
- Use Conventional Commits format

#### 8.3 Pre-Push Checklist

```bash
npm run lint
npm run build
npm run test
git log --oneline -10
```

#### 8.4 Push to GitHub

```bash
git push origin main
# or for feature branch
git push origin feature/refactor-marathon
```

---

## 🎯 SUCCESS CRITERIA

- [ ] **Phase 1:** Build scripts working, no errors
- [ ] **Phase 2:** Code 100% compliant
- [ ] **Phase 3:** Copy aligned, technical accuracy verified
- [ ] **Phase 4:** Legal compliance verified
- [ ] **Phase 5:** File naming conventions enforced
- [ ] **Phase 6:** Lighthouse targets met
- [ ] **Phase 7:** All tests/linters pass
- [ ] **Phase 8:** Clean commit history, CI passing

**Repository Health Metrics:**

- HTMLHint/ESLint/Stylelint errors: 0
- Lighthouse: Performance ≥ 90, Accessibility ≥ 95
- Broken links: 0
- Hard-coded colors: 0 (all tokens)
- Generic copy: 0 (all STYLE.md patterns)
- Unverified TCNA claims: 0 (all verified)

---

## 📊 MONITORING & MAINTENANCE

### Ongoing

```bash
npm run lint && npm run build && npm run test
```

### Quarterly

- Audit copy for tone drift
- Verify TCNA standards current
- Review Lighthouse scores
- Check for broken links

### Annual

- Update [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md) for TCNA changes
- Review [`/.ai/STYLE.md`](./.ai/STYLE.md) positioning
- Audit [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md) for NJ law

---

## 🚨 EMERGENCY ROLLBACK

```bash
git log --oneline -10
git revert <commit-hash>
git reset --hard <commit-hash>
git push origin main --force
npm run build
```

---

## 📚 REFERENCE DOCUMENTS

- [`/.ai/README.md`](./.ai/README.md)
- [`/.ai/SYSTEM.md`](./.ai/SYSTEM.md)
- [`/.ai/OUTPUT_RULES.md`](./.ai/OUTPUT_RULES.md)
- [`/.ai/STYLE.md`](./.ai/STYLE.md)
- [`/.ai/DOMAIN.md`](./.ai/DOMAIN.md)
- [`/.ai/COMPLIANCE.md`](./.ai/COMPLIANCE.md)
- [`.AI_GOVERNANCE.md`](.AI_GOVERNANCE.md)
- [`README.md`](README.md)
- [`.github/instructions/build-troubleshooting.md`](.github/instructions/build-troubleshooting.md)
- [`docs/AI-GOVERNANCE-IMPLEMENTATION.md`](docs/AI-GOVERNANCE-IMPLEMENTATION.md)

---

## 💡 TIPS FOR AI AGENTS

1. Complete one phase at a time
2. Test and lint after each logical group of changes
3. Commit atomically
4. Cite `.ai/` rules if unsure
5. Document non-obvious decisions

---

**Last Updated:** December 20, 2025  
**Estimated Duration:** 8–16 hours  
**Complexity:** High  
**Priority:** High

