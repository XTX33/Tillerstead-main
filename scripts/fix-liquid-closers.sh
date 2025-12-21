#!/usr/bin/env bash
# fix-liquid-closers.sh
#
# Automated Liquid/ERB template fixer for Jekyll sites.
# - Enforces TCNA/NJ HIC compliance (.ai/DOMAIN.md, .ai/COMPLIANCE.md)
# - Follows naming, backup, and reporting rules (.ai/OUTPUT_RULES.md)
# - Accessible, actionable output for technical transparency

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Color output (accessible contrast)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Liquid Template Closer Fix Script ===${NC}"
echo "Scanning for invalid or unsupported Liquid tags per TCNA/NJ HIC standards..."
echo

MODIFIED_FILES=()
MANUAL_REVIEW_FILES=()

# Backup utility (OUTPUT_RULES.md: always create .bak before modifying)
backup_file() {
    local file="$1"
    cp "$file" "$file.bak"
    echo -e "${GREEN}✓${NC} Backup created: $file.bak"
}

# Tag balance check (prevents technical debt, .ai/OUTPUT_RULES.md)
check_balance() {
    local file="$1"
    python3 << PYEOF
import sys, re
with open("$file") as f: content = f.read()
patterns = [
    (r'{%\s*if\s+', 'if'), (r'{%-\s*if\s+', 'if'),
    (r'{%\s*for\s+', 'for'), (r'{%-\s*for\s+', 'for'),
    (r'{%\s*endif\s*', 'endif'), (r'{%-\s*endif\s*', 'endif'),
    (r'{%\s*endfor\s*', 'endfor'), (r'{%-\s*endfor\s*', 'endfor'),
]
stack = []
for i, line in enumerate(content.split('\n'), 1):
    for pat, tag in patterns:
        if re.search(pat, line):
            if tag.startswith('end'):
                opener = tag[3:]
                if stack and stack[-1][1] == opener:
                    stack.pop()
                else:
                    print(f"Line {i}: Unmatched closing {tag}", file=sys.stderr)
                    sys.exit(1)
            else:
                stack.append((i, tag))
if stack:
    print(f"Unbalanced tags: {stack}", file=sys.stderr)
    sys.exit(1)
sys.exit(0)
PYEOF
}

# Main fixer (enforces .ai/OUTPUT_RULES.md and .ai/COMPLIANCE.md)
fix_file() {
    local file="$1"
    local fixed=0

    if grep -qE "{%\s*case\s+|{%-\s*case\s+|{%\s*unless\s+|{%-\s*unless\s+|{%\s*continue\s*%}" "$file"; then
        echo -e "\n${YELLOW}Processing:${NC} $file"
        backup_file "$file"

        # Convert {% case %} to {% if %}, {% when %} to {% if/elsif %}, {% endcase %} to {% endif %}
        if grep -qE "{%\s*case\s+|{%-\s*case\s+" "$file"; then
            echo -e "${BLUE}  → Converting {% case %} to {% if %}...${NC}"
            python3 << PYEOF
import sys, re
file = "$file"
with open(file) as f: content = f.read()
content = re.sub(r'{%\s*case\s+(\w+)\s*%}', r'<!-- case \1 converted to if/elsif -->', content)
lines, new_lines, case_var, first_when = content.split('\n'), [], None, True
for line in lines:
    m = re.search(r'<!-- case (\w+) converted to if/elsif -->', line)
    if m: case_var, first_when = m.group(1), True; new_lines.append(line); continue
    w = re.search(r'{%\s*when\s+[\'"]?([^\'"]+?)[\'"]?\s*%}', line)
    if w and case_var:
        value = w.group(1).strip()
        tag = '{% if ' if first_when else '{% elsif '
        line = re.sub(r'{%\s*when\s+[\'"]?[^\'"]+?[\'"]?\s*%}', f"{tag}{case_var} == '{value}' %}", line)
        first_when = False
    if re.search(r'{%\s*endcase\s*%}', line):
        line = re.sub(r'{%\s*endcase\s*%}', '{% endif %}', line)
        case_var, first_when = None, True
    new_lines.append(line)
with open(file, 'w') as f: f.write('\n'.join(new_lines))
PYEOF
            fixed=1
        fi

        # Convert {% unless %} to {% if ... == false %}, {% endunless %} to {% endif %}
        if grep -qE "{%\s*unless\s+|{%-\s*unless\s+" "$file"; then
            echo -e "${BLUE}  → Converting {% unless %} to {% if ... == false %}...${NC}"
            perl -i -pe 's/{%-?\s*unless\s+(.+?)\s*-?%}/{%- if \1 == false -%}/g' "$file"
            perl -i -pe 's/{%-?\s*endunless\s*-?%}/{%- endif -%}/g' "$file"
            fixed=1
        fi

        # Flag {% continue %} for manual review (complex logic, see .ai/OUTPUT_RULES.md)
        if grep -qE "{%\s*continue\s*%}" "$file"; then
            echo -e "${YELLOW}  ⚠ Found {% continue %} - manual review required${NC}"
            echo -e "${YELLOW}    Context: $(grep -n "continue" "$file" | head -1)${NC}"
            MANUAL_REVIEW_FILES+=("$file")
        fi

        if [ $fixed -eq 1 ]; then
            if check_balance "$file" 2>/dev/null; then
                echo -e "${GREEN}  ✓ File is balanced after fixes${NC}"
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

# Scan all HTML and MD files (OUTPUT_RULES.md: only tracked files)
echo "Scanning tracked HTML and Markdown files..."
FILES=$(git ls-files | grep -E '\.(html|md)$' || true)
if [ -z "$FILES" ]; then
    echo -e "${YELLOW}No HTML or MD files found in repository${NC}"
    exit 0
fi

for file in $FILES; do
    [ -f "$file" ] && fix_file "$file"
done

echo
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}Modified files: ${#MODIFIED_FILES[@]}${NC}"
[ ${#MODIFIED_FILES[@]} -gt 0 ] && printf '  %s\n' "${MODIFIED_FILES[@]}"
echo -e "${YELLOW}Files needing manual review: ${#MANUAL_REVIEW_FILES[@]}${NC}"
[ ${#MANUAL_REVIEW_FILES[@]} -gt 0 ] && printf '  %s\n' "${MANUAL_REVIEW_FILES[@]}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Review the above diffs for accuracy and compliance."
echo "2. Test the Jekyll build: ruby vendor/gems/jekyll/bin/jekyll build"
echo "3. If successful, commit the changes (see .ai/OUTPUT_RULES.md for commit conventions)."
echo "4. Address any files flagged for manual review."
echo
echo -e "${GREEN}Done!${NC}"
