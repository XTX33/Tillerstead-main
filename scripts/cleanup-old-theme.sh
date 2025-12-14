#!/bin/bash
# cleanup-old-theme.sh
# Removes old, unused theme files that interfere with the new modern theme

set -e

echo "🧹 Tillerstead Theme Cleanup Script"
echo "===================================="
echo ""

# Backup flag
BACKUP=false
if [ "$1" = "--backup" ]; then
    BACKUP=true
    BACKUP_DIR="theme-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    echo "📦 Creating backup in: $BACKUP_DIR"
fi

# Function to safely remove with optional backup
safe_remove() {
    local path=$1
    local description=$2
    
    if [ -e "$path" ]; then
        echo "  🗑️  Removing: $path"
        if [ "$BACKUP" = true ]; then
            cp -r "$path" "$BACKUP_DIR/" 2>/dev/null || true
        fi
        rm -rf "$path"
        echo "     ✅ $description removed"
    else
        echo "  ⏭️  Skipping: $path (not found)"
    fi
}

echo ""
echo "1️⃣  Removing old /src/scss directory (duplicate, unused)"
echo "-----------------------------------------------------"
safe_remove "src/scss" "Old SCSS directory"

echo ""
echo "2️⃣  Removing old /src/assets directory (unused)"
echo "-----------------------------------------------------"
safe_remove "src/assets" "Old assets directory"

echo ""
echo "3️⃣  Renaming main-build.scss to main.scss"
echo "-----------------------------------------------------"
if [ -f "assets/css/main-build.scss" ]; then
    echo "  📝 Renaming: assets/css/main-build.scss → assets/css/main.scss"
    if [ "$BACKUP" = true ]; then
        cp "assets/css/main-build.scss" "$BACKUP_DIR/" 2>/dev/null || true
    fi
    mv "assets/css/main-build.scss" "assets/css/main.scss"
    echo "     ✅ Renamed successfully"
else
    echo "  ⏭️  File already named main.scss or not found"
fi

echo ""
echo "4️⃣  Checking for other duplicate/old CSS files"
echo "-----------------------------------------------------"
# Check for any compiled CSS that might interfere
if [ -f "assets/css/theme.css" ]; then
    safe_remove "assets/css/theme.css" "Old compiled theme.css"
fi
if [ -f "assets/css/theme-compiled.css" ]; then
    safe_remove "assets/css/theme-compiled.css" "Old compiled theme-compiled.css"
fi
if [ -f "assets/css/style.css" ]; then
    safe_remove "assets/css/style.css" "Old style.css"
fi

echo ""
echo "5️⃣  Cleaning up old documentation files (if duplicates)"
echo "-----------------------------------------------------"
# Keep main docs but remove any drafts or duplicates
if [ -f "CSS_ARCHITECTURE.OLD.md" ]; then
    safe_remove "CSS_ARCHITECTURE.OLD.md" "Old architecture doc"
fi

echo ""
echo "6️⃣  Removing _site build directory (will be regenerated)"
echo "-----------------------------------------------------"
safe_remove "_site" "Build directory (_site)"

echo ""
echo "✅ Cleanup Complete!"
echo "===================="
echo ""
echo "Summary:"
echo "  • Old /src/scss removed"
echo "  • Old /src/assets removed"
echo "  • main-build.scss → main.scss"
echo "  • Build directory cleaned"
echo ""

if [ "$BACKUP" = true ]; then
    echo "📦 Backup saved to: $BACKUP_DIR"
    echo ""
fi

echo "Next steps:"
echo "  1. Run: ./scripts/run-jekyll.sh build"
echo "  2. Test the site locally"
echo "  3. Check that main.css is being generated"
echo ""
echo "🎉 Your modern theme is ready!"
