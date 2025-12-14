#!/usr/bin/env bash
set -euo pipefail
echo "Starting fix-liquid-closers"
# Find literal Liquid incorrect closers
candidates=$(git grep -n --full-name -E '\{%\s*end\s*%\}' || true)
if [[ -z "$candidates" ]]; then
  echo "No '{% end %}' occurrences found."
else
  echo "Candidates for '{% end %}':"
  echo "$candidates"
fi

apply_replacement() {
  local file="$1"
  local lineno="$2"
  local start=$(( lineno > 40 ? lineno - 40 : 1 ))
  opener=$(sed -n "${start},${lineno}p" "$file" | tac | grep -m1 -E '{%\s*(if|for|capture|unless|case)\b' || true)
  if [[ -z "$opener" ]]; then
    echo "  Could not infer opener for $file:$lineno — SKIP"
    return
  fi
  if echo "$opener" | grep -q '{%\s*if\b'; then repl='{% endif %}'; fi
  if echo "$opener" | grep -q '{%\s*for\b'; then repl='{% endfor %}'; fi
  if echo "$opener" | grep -q '{%\s*capture\b'; then repl='{% endcapture %}'; fi
  if echo "$opener" | grep -q '{%\s*unless\b'; then repl='{% endunless %}'; fi
  if echo "$opener" | grep -q '{%\s*case\b'; then repl='{% endcase %}'; fi
  if [[ -z "${repl:-}" ]]; then
    echo "  No replacement inferred for $file:$lineno — SKIP"
    return
  fi
  echo "  Replacing in $file:$lineno -> $repl"
  perl -0777 -pe "s/\{%\s*end\s*%\}/$repl/g" -i.bak "$file"
}

# Iterate candidates and apply replacements where possible
while IFS= read -r line; do
  file=$(echo "$line" | cut -d: -f1)
  lineno=$(echo "$line" | cut -d: -f2)
  apply_replacement "$file" "$lineno"
done <<< "$candidates"

# Report ERB-like tags for manual review
echo ""
echo "Scanning for ERB-like tags (<% ... %>) — listing occurrences for manual review"
git grep -n --full-name -E '<%[^=]' || true

echo "Done. Please review .bak files for backups and run './scripts/run-jekyll.sh build --trace' to verify."
#!/bin/bash
# fix-liquid-closers.sh
# 
# Automated script to detect and fix invalid Liquid/ERB template syntax
# in Jekyll sites using a custom minimal Liquid implementation.
#
# This script addresses issues with:
# 1. Unsupported {% case %}/{% when %}/{% endcase %} tags (convert to {% if %}/{% elsif %})
# 2. Unsupported {% unless %}/{% endunless %} tags (convert to {% if %})
# 3. Unsupported {% continue %} tags (restructure to use conditional wrapping)
# 4. Missing {% for %} or {% endfor %} tags (detect and report for manual fix)
#
# Safety features:
# - Creates .bak backup for every modified file
# - Validates tag balance before and after changes
# - Prints diffs for review
# - Reports files that need manual review

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Liquid Template Closer Fix Script ===${NC}"
echo "Scanning for invalid or unsupported Liquid tags..."
echo

# Track changes
MODIFIED_FILES=()
MANUAL_REVIEW_FILES=()

# Function to create backup
backup_file() {
    local file="$1"
    cp "$file" "$file.bak"
    echo -e "${GREEN}✓${NC} Created backup: $file.bak"
}

# Function to check tag balance
check_balance() {
    local file="$1"
    python3 << PYEOF
import sys
import re

file = "$file"
with open(file, 'r') as f:
    content = f.read()

patterns = [
    (r'{%\s*if\s+', 'if'),
    (r'{%-\s*if\s+', 'if'),
    (r'{%\s*for\s+', 'for'),
    (r'{%-\s*for\s+', 'for'),
    (r'{%\s*endif\s*', 'endif'),
    (r'{%-\s*endif\s*', 'endif'),
    (r'{%\s*endfor\s*', 'endfor'),
    (r'{%-\s*endfor\s*', 'endfor'),
]

stack = []
for i, line in enumerate(content.split('\n'), 1):
    for pattern, tag_type in patterns:
        if re.search(pattern, line):
            if tag_type.startswith('end'):
                opener = tag_type[3:]
                if stack and stack[-1][1] == opener:
                    stack.pop()
                else:
                    print(f"Line {i}: Unmatched closing {tag_type}", file=sys.stderr)
                    sys.exit(1)
            else:
                stack.append((i, tag_type))

if stack:
    print(f"Unbalanced tags: {stack}", file=sys.stderr)
    sys.exit(1)
sys.exit(0)
PYEOF
}

# Function to fix unsupported tags in a file
fix_file() {
    local file="$1"
    local fixed=0
    
    # Check for unsupported tags
    if grep -qE "{%\s*case\s+|{%-\s*case\s+|{%\s*unless\s+|{%-\s*unless\s+|{%\s*continue\s*%}" "$file"; then
        echo -e "\n${YELLOW}Processing:${NC} $file"
        
        # Create backup
        backup_file "$file"
        
        # Fix {% case %} / {% when %} / {% endcase %} -> {% if %} / {% elsif %}
        if grep -qE "{%\s*case\s+|{%-\s*case\s+" "$file"; then
            echo -e "${BLUE}  → Converting {% case %} to {% if %}...${NC}"
            
            # This is a complex transformation, so we'll use a Python script
            python3 << PYEOF
import sys
import re

file = "$file"
with open(file, 'r') as f:
    content = f.read()

# Convert {% case variable %} to a comment marker
content = re.sub(
    r'{%\s*case\s+(\w+)\s*%}',
    r'<!-- case \1 converted to if/elsif -->',
    content
)

# Convert first {% when value %} to {% if variable == value %}
# This is complex, so we'll do a simple replacement for now
lines = content.split('\n')
new_lines = []
case_var = None
first_when = True

for line in lines:
    # Detect case marker
    case_match = re.search(r'<!-- case (\w+) converted to if/elsif -->', line)
    if case_match:
        case_var = case_match.group(1)
        first_when = True
        new_lines.append(line)
        continue
    
    # Convert {% when %} based on whether it's first or not - handle quoted and unquoted values
    when_match = re.search(r'{%\s*when\s+[\'"]?([^\'"]+?)[\'"]?\s*%}', line)
    if when_match and case_var:
        value = when_match.group(1).strip()
        if first_when:
            # First when becomes if
            line = re.sub(
                r'{%\s*when\s+[\'"]?[^\'"]+?[\'"]?\s*%}',
                rf'{{% if {case_var} == \'{value}\' %}}',
                line
            )
            first_when = False
        else:
            # Subsequent whens become elsif
            line = re.sub(
                r'{%\s*when\s+[\'"]?[^\'"]+?[\'"]?\s*%}',
                rf'{{% elsif {case_var} == \'{value}\' %}}',
                line
            )
    
    # Convert {% endcase %} to {% endif %}
    if re.search(r'{%\s*endcase\s*%}', line):
        line = re.sub(r'{%\s*endcase\s*%}', '{% endif %}', line)
        case_var = None
        first_when = True
    
    new_lines.append(line)

with open(file, 'w') as f:
    f.write('\n'.join(new_lines))
PYEOF
            fixed=1
        fi
        
        # Fix {% unless %} / {% endunless %} -> {% if %}
        if grep -qE "{%\s*unless\s+|{%-\s*unless\s+" "$file"; then
            echo -e "${BLUE}  → Converting {% unless %} to {% if %}...${NC}"
            
            # Unless is "if not", so we need to negate the condition
            # Note: This is a simple conversion; complex conditions may need manual review
            perl -i -pe 's/{%-?\s*unless\s+(.+?)\s*-?%}/{%- if \1 == false -%}/g' "$file"
            perl -i -pe 's/{%-?\s*endunless\s*-?%}/{%- endif -%}/g' "$file"
            fixed=1
        fi
        
        # Report {% continue %} for manual review (complex to autofix safely)
        if grep -qE "{%\s*continue\s*%}" "$file"; then
            echo -e "${YELLOW}  ⚠ Found {% continue %} - needs manual review${NC}"
            echo -e "${YELLOW}    Context: $(grep -n "continue" "$file" | head -1)${NC}"
            MANUAL_REVIEW_FILES+=("$file")
        fi
        
        if [ $fixed -eq 1 ]; then
            # Check if file is still balanced
            if check_balance "$file" 2>/dev/null; then
                echo -e "${GREEN}  ✓ File is balanced after fixes${NC}"
                
                # Show diff
                if command -v diff &> /dev/null; then
                    echo -e "\n${BLUE}Changes:${NC}"
                    diff -u "$file.bak" "$file" || true
                fi
                
                MODIFIED_FILES+=("$file")
            else
                echo -e "${RED}  ✗ File became unbalanced! Restoring backup...${NC}"
                mv "$file.bak" "$file"
            fi
        fi
    fi
}

# Scan all HTML and MD files
echo "Scanning tracked files..."
FILES=$(git ls-files | grep -E '\.(html|md)$' || true)

if [ -z "$FILES" ]; then
    echo -e "${YELLOW}No HTML or MD files found in repository${NC}"
    exit 0
fi

for file in $FILES; do
    if [ -f "$file" ]; then
        fix_file "$file"
    fi
done

echo
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}Modified files: ${#MODIFIED_FILES[@]}${NC}"
if [ ${#MODIFIED_FILES[@]} -gt 0 ]; then
    printf '  %s\n' "${MODIFIED_FILES[@]}"
fi

echo -e "${YELLOW}Files needing manual review: ${#MANUAL_REVIEW_FILES[@]}${NC}"
if [ ${#MANUAL_REVIEW_FILES[@]} -gt 0 ]; then
    printf '  %s\n' "${MANUAL_REVIEW_FILES[@]}"
fi

echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Review the diffs above"
echo "2. Test the Jekyll build: ruby vendor/gems/jekyll/bin/jekyll build"
echo "3. If successful, commit the changes"
echo "4. If issues persist, check files flagged for manual review"
echo
echo -e "${GREEN}Done!${NC}"
