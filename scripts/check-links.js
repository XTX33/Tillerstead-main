#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const cheerio = require('cheerio');

const siteDir = path.join(__dirname, '..', '_site');
if (!fs.existsSync(siteDir)) {
  console.error('Missing _site directory. Run `npm run build` first.');
  process.exit(1);
}

const allowMissing = new Set(['/favicon.ico']);

function isExternal(link) {
  return /^(https?:)?\/\//i.test(link) || /\/?mailto:/i.test(link) || /\/?tel:/i.test(link) || /\/?sms:/i.test(link) || link.startsWith('#');
}

function stripFragmentsAndQuery(ref) {
  const [pathPart] = ref.split('#');
  return pathPart.split('?')[0];
}

function normalizeTarget(href) {
  const cleaned = stripFragmentsAndQuery(href);
  let target = cleaned;

  if (target.startsWith('/')) {
    target = target.slice(1);
  }

  const ext = path.extname(target);
  if (!ext) {
    target = path.join(target, 'index.html');
  }

  const primary = path.join(siteDir, target);
  if (fs.existsSync(primary)) return primary;

  if (ext === '.html') {
    const fallback = path.join(siteDir, target.replace(/\.html$/, '/index.html'));
    if (fs.existsSync(fallback)) return fallback;
  }

  return primary;
}

function collectHtmlFiles(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  return entries.flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      return collectHtmlFiles(fullPath);
    }
    return entry.name.endsWith('.html') ? [fullPath] : [];
  });
}

const missing = [];
for (const file of collectHtmlFiles(siteDir)) {
  const html = fs.readFileSync(file, 'utf8');
  const $ = cheerio.load(html);
  const links = $('a[href], link[href]');
  const images = $('img[src], source[src], video[src], audio[src], script[src]');

  links.each((_, el) => {
    const href = $(el).attr('href');
    if (!href || isExternal(href)) return;
    const target = normalizeTarget(href);
    if (!fs.existsSync(target) && !allowMissing.has(stripFragmentsAndQuery(href))) {
      missing.push({ source: path.relative(siteDir, file), ref: href });
    }
  });

  images.each((_, el) => {
    const src = $(el).attr('src');
    if (!src || isExternal(src)) return;
    const target = normalizeTarget(src);
    if (!fs.existsSync(target) && !allowMissing.has(stripFragmentsAndQuery(src))) {
      missing.push({ source: path.relative(siteDir, file), ref: src });
    }
  });
}

if (missing.length) {
  console.error('Broken internal links/assets found:');
  for (const issue of missing) {
    console.error(`- ${issue.source} -> ${issue.ref}`);
  }
  process.exit(1);
}

console.log('Link check passed: all internal references resolved.');
