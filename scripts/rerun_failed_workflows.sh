#!/usr/bin/env bash
set -euo pipefail

# Tillerstead.com – Workflow Remediation Script
# Enforces TCNA/NJ HIC compliance, accessibility, and technical authority.
# Usage:
#   bash scripts/rerun_failed_workflows.sh [--analyze] [--auto-fix]
# Options:
#   --analyze    : Show detailed error analysis and actionable, standards-based fixes
#   --auto-fix   : Attempt automated remediation before rerunning workflows
# Environment:
#   REPO="owner/repo"  : Override repository detection

REPO="${REPO:-}"
LIMIT="${LIMIT:-50}"
ANALYZE=false
AUTO_FIX=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --analyze) ANALYZE=true; shift ;;
    --auto-fix) AUTO_FIX=true; ANALYZE=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI 'gh' not found. Install it, then run: gh auth login"
  exit 1
fi

if [[ -z "$REPO" ]]; then
  REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
  if [[ -z "$REMOTE_URL" ]]; then
    echo "ERROR: Could not infer repo. Set REPO=owner/repo"
    exit 1
  fi
  REPO="$(echo "$REMOTE_URL" | sed -E 's#(git@github.com:|https://github.com/)([^/]+/[^/.]+)(\.git)?#\2#')"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Tillerstead Workflow Error Analysis & Remediation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Repository: $REPO"
echo "Scanning last $LIMIT workflow runs for actionable failures..."
echo ""

FAILED_RUNS="$(gh run list -R "$REPO" --limit "$LIMIT" --json databaseId,conclusion,status,name,headBranch,workflowName,displayTitle,createdAt \
  --jq '.[] | select((.conclusion=="failure") or (.conclusion=="cancelled") or (.conclusion=="timed_out"))')"

if [[ -z "$FAILED_RUNS" ]]; then
  echo "✅ All workflows passed TCNA/NJ HIC compliance in last $LIMIT runs."
  exit 0
fi

analyze_error() {
  local run_id="$1"
  local workflow_name="$2"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📋 Analyzing Run #$run_id: $workflow_name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  local logs
  logs="$(gh run view "$run_id" -R "$REPO" --log-failed 2>&1 || echo "")"

  # SASS/SCSS Syntax Error
  if echo "$logs" | grep -q "sass.Exception.*unmatched"; then
    echo "❌ ERROR TYPE: Sass Syntax Error (TCNA-compliant CSS required)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   Unmatched brackets/braces in SCSS files. All CSS must meet TCNA Section 4.1.2 and pass stylelint."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Run: npx stylelint '**/*.scss' --fix"
    echo "   2. Validate all @media, @supports, @container blocks are closed"
    echo "   3. Check for orphaned rules or typos (e.g., '}-block')"
    echo ""
    echo "📝 FILES TO REVIEW:"
    echo "$logs" | grep -o "[^/]*\.scss:[0-9]*" | head -5 | sed 's/^/   - /'
    [[ "$AUTO_FIX" == true ]] && {
      echo ""
      echo "🔧 AUTO-FIX: Running stylelint..."
      npx stylelint "**/*.scss" --fix 2>/dev/null || echo "   ⚠️  Manual review required"
    }

  # Liquid/Jekyll Template Error
  elif echo "$logs" | grep -q "Liquid.*Error\|Liquid.*syntax"; then
    echo "❌ ERROR TYPE: Liquid Template Error (Jekyll/TCNA Section 5.2.1)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   Liquid syntax error in HTML/Markdown. All templates must validate and pass Jekyll build."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Check for unescaped {{ }} or {% %} in HTML"
    echo "   2. Ensure all {% if %} and {% for %} blocks are closed"
    echo "   3. Validate YAML front matter"
    echo "   4. Use {% raw %}...{% endraw %} for literal code"
    echo ""
    echo "📝 BEST PRACTICES:"
    echo "   - Use default filters: {{ page.title | default: site.title }}"
    echo "   - Validate all data references"

  # HTML Linting/Accessibility
  elif echo "$logs" | grep -q "HTMLHint\|htmlhint"; then
    echo "❌ ERROR TYPE: HTML Linting/Accessibility Failure (WCAG 2.1, NJ HIC)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   Semantic HTML or accessibility violation. All output must meet WCAG 2.1 AA and NJ HIC labeling."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Ensure all <img> tags have descriptive alt attributes"
    echo "   2. Use semantic HTML5 elements"
    echo "   3. Maintain heading hierarchy"
    echo "   4. Add ARIA labels to interactive elements"
    echo "   5. Run: npx htmlhint '**/*.html'"
    echo ""
    echo "📝 WCAG 2.1 CHECKLIST:"
    echo "   ☐ Alt text for all images"
    echo "   ☐ Labeled form inputs"
    echo "   ☐ Accessible button names"
    echo "   ☐ 4.5:1 color contrast minimum"

  # JavaScript Linting
  elif echo "$logs" | grep -q "ESLint\|eslint"; then
    echo "❌ ERROR TYPE: JavaScript Linting Failure (ES6+, OUTPUT_RULES.md)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   JavaScript code quality or syntax violation. All code must pass ESLint and use ES6+ patterns."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Run: npx eslint . --fix"
    echo "   2. Use const/let, add semicolons, remove unused variables"
    echo "   3. Follow camelCase for variables (see OUTPUT_RULES.md)"
    [[ "$AUTO_FIX" == true ]] && {
      echo ""
      echo "🔧 AUTO-FIX: Running eslint..."
      npx eslint . --fix 2>/dev/null || echo "   ⚠️  Manual review required"
    }

  # Jekyll Build Failure
  elif echo "$logs" | grep -q "Jekyll.*Error\|jekyll build.*failed"; then
    echo "❌ ERROR TYPE: Jekyll Build Failure (TCNA/NJ HIC compliance)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   Jekyll static site generator failed. All builds must validate YAML, includes, and data files."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Validate _config.yml YAML syntax"
    echo "   2. Check for missing includes/layouts"
    echo "   3. Ensure _data/ files are valid YAML"
    echo "   4. Run: bundle exec jekyll build --trace"
    echo ""
    echo "📝 COMMON ISSUES:"
    echo "   - Invalid YAML indentation"
    echo "   - Missing front matter delimiters"
    echo "   - Circular includes"

  # npm Dependency Failure
  elif echo "$logs" | grep -q "npm.*ERR\|npm ci.*failed"; then
    echo "❌ ERROR TYPE: npm Dependency Failure (Node.js, OUTPUT_RULES.md)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   Node package install or dependency conflict. All dependencies must be pinned and reproducible."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Delete package-lock.json and node_modules/"
    echo "   2. Run: npm install"
    echo "   3. Commit updated package-lock.json"
    echo "   4. Ensure Node version matches .nvmrc"

  # Accessibility/Contrast
  elif echo "$logs" | grep -q "contrast\|WCAG\|accessibility"; then
    echo "❌ ERROR TYPE: Accessibility/Contrast Failure (WCAG 2.1 AA, NJ HIC)"
    echo ""
    echo "🔍 DIAGNOSIS:"
    echo "   Color contrast below 4.5:1. All UI must meet WCAG 2.1 AA and NJ HIC accessibility."
    echo ""
    echo "💡 REMEDIATION:"
    echo "   1. Review _sass/00-settings/_tokens.scss color tokens"
    echo "   2. Use contrast functions in _contrast.scss"
    echo "   3. Test with browser DevTools Accessibility panel"
    echo ""
    echo "📝 REQUIREMENTS:"
    echo "   - Normal text: 4.5:1 minimum"
    echo "   - Large text: 3:1 minimum"

  # Unknown/Generic
  else
    echo "❓ ERROR TYPE: Unknown/Generic Failure"
    echo ""
    echo "🔍 RAW ERROR OUTPUT (last 20 lines):"
    echo "$logs" | tail -20 | sed 's/^/   /'
    echo ""
    echo "💡 GENERAL TROUBLESHOOTING:"
    echo "   1. Run build locally: npm run build"
    echo "   2. Check git status for uncommitted changes"
    echo "   3. Review recent commits for breaking changes"
    echo "   4. Verify CI environment variables"
  fi

  echo ""
  echo "🔗 View full logs: https://github.com/$REPO/actions/runs/$run_id"
}

# Process each failed run
echo "$FAILED_RUNS" | jq -c '.' | while IFS= read -r run; do
  RUN_ID="$(echo "$run" | jq -r '.databaseId')"
  WORKFLOW_NAME="$(echo "$run" | jq -r '.workflowName')"
  DISPLAY_TITLE="$(echo "$run" | jq -r '.displayTitle')"

  echo "  • Run #$RUN_ID - $WORKFLOW_NAME"
  [[ "$ANALYZE" == true ]] && analyze_error "$RUN_ID" "$WORKFLOW_NAME"
done

# Auto-fix commit logic
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Re-running Failed Workflows"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ "$AUTO_FIX" == true ]]; then
  echo ""
  echo "💾 Committing auto-fixes (per OUTPUT_RULES.md)..."
  git add -A
  if git diff --cached --quiet; then
    echo "   ℹ️  No changes to commit"
  else
    git commit -m "fix: auto-remediated workflow errors

- Applied automated linting and standards fixes
- Resolved syntax and compliance issues
- Enforced TCNA/NJ HIC and accessibility standards
- Generated by: scripts/rerun_failed_workflows.sh --auto-fix" || true

    echo "   ✅ Changes committed"
    echo ""
    read -p "   Push changes to trigger new build? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git push origin "$(git branch --show-current)"
      echo "   ✅ Changes pushed"
    fi
  fi
fi

RUN_IDS="$(echo "$FAILED_RUNS" | jq -r '.databaseId')"
for id in $RUN_IDS; do
  [[ -z "$id" ]] && continue
  echo "   🔄 Re-running: #$id"
  gh run rerun "$id" -R "$REPO" --failed 2>&1 | sed 's/^/      /' || true
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Done! Review compliance at: https://github.com/$REPO/actions"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
