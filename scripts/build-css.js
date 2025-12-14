// Cross-platform CSS build: strips Jekyll front matter from SCSS and compiles with sass
const fs = require('fs');
const path = require('path');
const sass = require('sass');

const scssPath = path.resolve(__dirname, '..', 'assets', 'css', 'main.scss');
const cssOutPath = path.resolve(__dirname, '..', 'assets', 'css', 'main.css');
const sassLoadPath = path.resolve(__dirname, '..', '_sass');

function stripFrontMatter(source) {
  const lines = source.split(/\r?\n/);
  // Remove typical two-line Jekyll front matter fence if present
  if (lines[0] && lines[0].trim() === '---') {
    // Find closing fence
    let end = 1;
    while (end < lines.length && lines[end].trim() !== '---') end++;
    if (end < lines.length) {
      return lines.slice(end + 1).join('\n');
    }
  }
  // Fallback: skip first two lines like `tail -n +3`
  return lines.slice(2).join('\n');
}

function build() {
  const scss = fs.readFileSync(scssPath, 'utf8');
  const stripped = stripFrontMatter(scss);
  const result = sass.compileString(stripped, {
    loadPaths: [sassLoadPath],
    style: 'compressed',
    quietDeps: true,
    // Preserve consistent URL handling relative to project root
    url: new URL('file://' + cssOutPath.replace(/\\/g, '/')),
  });
  fs.writeFileSync(cssOutPath, result.css);
  process.stdout.write('Built CSS -> ' + path.relative(process.cwd(), cssOutPath) + '\n');
}

build();
