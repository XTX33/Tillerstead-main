#!/bin/bash
# Complete rebuild script - use this when homepage looks wrong

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "🧹 Cleaning old build..."
rm -rf _site
rm -f assets/css/main.css

echo ""
echo "🎨 Compiling SCSS to CSS..."
npm run build:css

echo ""
echo "🏗️  Building Jekyll site..."
./scripts/run-jekyll.sh build

echo ""
echo "✅ Build complete!"
echo ""
echo "📁 Output directory: _site/"
echo "🌐 Open _site/index.html in browser to preview"
echo ""
echo "Or run 'npm run dev' for live reload server"
