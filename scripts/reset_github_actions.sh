#!/usr/bin/env bash
# Tillerstead LLC – GitHub Actions Reset Utility
# Purpose: Cancel all in-progress GitHub Actions workflow runs and delete workflow run history.
# Compliance: TCNA 2024, NJ HIC, GitHub API Terms, .ai/OUTPUT_RULES.md

set -euo pipefail

# Validate required tools
for cmd in gh jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required tool '$cmd' not found in PATH. Aborting." >&2
    exit 10
  fi
done

REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
if [[ -z "$REPO" ]]; then
  echo "Error: Unable to determine repository context. Ensure 'gh' is authenticated and in a valid repo." >&2
  exit 11
fi

echo "Repository: $REPO"
echo "Fetching workflow runs (GitHub Actions)..."

# Cancel all currently running workflows
echo "Cancelling all in-progress workflow jobs for $REPO..."
gh run list --repo "$REPO" --status in_progress --json databaseId \
  | jq -r '.[].databaseId' \
  | while read -r run_id; do
      if [[ -n "$run_id" ]]; then
        echo "→ Cancelling run ID: $run_id"
        gh run cancel "$run_id" --repo "$REPO" || echo "Warning: Failed to cancel run $run_id"
      fi
    done

# Delete ALL workflow run history (paginated)
echo "Deleting all workflow run history for $REPO..."
gh api -X GET "repos/$REPO/actions/runs?per_page=100" --paginate \
  | jq -r '.workflow_runs[].id' \
  | while read -r run_id; do
      if [[ -n "$run_id" ]]; then
        echo "→ Deleting run ID: $run_id"
        gh api -X DELETE "repos/$REPO/actions/runs/$run_id" || echo "Warning: Failed to delete run $run_id"
      fi
    done

echo "✅ GitHub Actions workflow history cleared for $REPO."
echo "Note: This operation does not modify source code, workflow definitions, or repository settings."
echo "All actions comply with TCNA/NJ HIC standards and GitHub API terms. For audit logs, consult GitHub Actions UI."

# Accessibility: All output is plain text for screen reader compatibility.
# Legal: Do not use this script on repositories you do not own or administer.
