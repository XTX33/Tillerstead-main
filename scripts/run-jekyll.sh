#!/bin/bash
# Tillerstead LLC – Jekyll Build Script
# Runs the vendored Jekyll binary in strict compliance with TCNA and NJ HIC standards.
# References: /.ai/SYSTEM.md, /.ai/DOMAIN.md, /.ai/COMPLIANCE.md, /.ai/OUTPUT_RULES.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
JEKYLL_BIN="${PROJECT_ROOT}/vendor/gems/jekyll/bin/jekyll"

# Minimum Ruby version required for TCNA/NJ HIC compliance
REQUIRED_RUBY_VERSION="2.7.0"

function check_ruby_version() {
  local current_version
  current_version="$(ruby -e 'print RUBY_VERSION')"
  if [[ "$(printf '%s\n' "$REQUIRED_RUBY_VERSION" "$current_version" | sort -V | head -n1)" != "$REQUIRED_RUBY_VERSION" ]]; then
    echo "Error: Ruby $REQUIRED_RUBY_VERSION or newer is required (found $current_version)." >&2
    echo "Remediation: Update Ruby to meet TCNA/NJ HIC compliance." >&2
    exit 2
  fi
}

function check_jekyll_binary() {
  if [ ! -x "$JEKYLL_BIN" ]; then
    echo "Error: Jekyll binary not found or not executable at $JEKYLL_BIN" >&2
    echo "Remediation: Run 'npm run setup' or consult /.ai/DOMAIN.md for dependency instructions." >&2
    exit 1
  fi
}

function main() {
  check_ruby_version
  check_jekyll_binary

  # Run Jekyll with all arguments passed through
  ruby "$JEKYLL_BIN" "$@"
}

main "$@"
