#!/bin/bash
# Tillerstead.com – Script Executable Permission Utility
# Ensures all build and asset-generation scripts are executable per TCNA/NJ HIC compliance.
# Reference: /.ai/OUTPUT_RULES.md, /.ai/COMPLIANCE.md

set -euo pipefail

# Grant execute permissions to all critical build scripts
chmod +x /workspaces/Tillerstead-live/rebuild.sh
chmod +x /workspaces/Tillerstead-live/quick-build.sh

# Ensure logo generator is executable (Node.js entry point)
chmod +x /workspaces/Tillerstead-live/scripts/generate-png-logos.js

echo "✅ All Tillerstead build and asset scripts are now executable (per TCNA/NJ HIC standards)."
echo ""
echo "Run these with confidence:"
echo "  ./rebuild.sh         # Full TCNA-compliant clean rebuild"
echo "  ./quick-build.sh     # Fast incremental build with compliance status"
echo "  npm run build:logos  # Generate accessible, standards-based PNG logos"
echo ""
echo "For details, see /.ai/OUTPUT_RULES.md and /.ai/COMPLIANCE.md."
