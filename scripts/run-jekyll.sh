#!/bin/bash
# Run the vendored Jekyll build without needing Bundler or external gems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
JEKYLL_BIN="${PROJECT_ROOT}/vendor/gems/jekyll/bin/jekyll"

if [ ! -x "$JEKYLL_BIN" ]; then
  echo "Error: expected Jekyll binary at $JEKYLL_BIN" >&2
  exit 1
fi

ruby "$JEKYLL_BIN" "$@"
