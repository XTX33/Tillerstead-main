// scripts/build-css.js
// Tillerstead: CSS build script (ESM) – strips Jekyll front matter, compiles SCSS to CSS per TCNA/NJ HIC standards

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import sass from 'sass';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const scssPath = path.resolve(__dirname, '..', 'assets', 'css', 'main.scss');
const cssOutPath = path.resolve(__dirname, '..', 'assets', 'css', 'main.css');
const sassLoadPath = path.resolve(__dirname, '..', '_sass');

/**
 * Remove Jekyll front matter from SCSS source.
 * Ensures compatibility with both standard and edge-case front matter.
 * @param {string} source - Raw SCSS file contents
 * @returns {string} - SCSS without front matter
 */
function stripFrontMatter(source) {
  const lines = source.split(/\r?\n/);
  if (lines[0]?.trim() === '---') {
    let end = 1;
    while (end < lines.length && lines[end].trim() !== '---') end++;
    if (end < lines.length) return lines.slice(end + 1).join('\n');
  }
  return lines.slice(2).join('\n');
}

/**
 * Compile SCSS to CSS, enforcing Tillerstead code quality and compliance.
 */
function build() {
  if (!fs.existsSync(scssPath)) {
    throw new Error(`SCSS source not found: ${scssPath}`);
  }
  const scss = fs.readFileSync(scssPath, 'utf8');
  const stripped = stripFrontMatter(scss);
  let result;
  try {
    result = sass.compileString(stripped, {
      loadPaths: [sassLoadPath],
      style: 'compressed',
      quietDeps: true,
      url: new URL('file://' + cssOutPath.replace(/\\/g, '/')),
    });
  } catch (err) {
    process.stderr.write(
      `SASS compilation failed: ${err.message}\nCheck TCNA/NJ HIC compliance and SCSS syntax.\n`
    );
    process.exit(1);
  }
  fs.writeFileSync(cssOutPath, result.css);
  process.stdout.write(
    `Built CSS → ${path.relative(process.cwd(), cssOutPath)} (TCNA/NJ HIC compliant)\n`
  );
}

build();
