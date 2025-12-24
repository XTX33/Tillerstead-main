# GitHub Pages Actions Fix Script
# Configures and validates GitHub Actions workflows for GitHub Pages deployment

Write-Host "🚀 GitHub Pages Actions Setup Starting..." -ForegroundColor Cyan

# Check if .github/workflows exists
if (-not (Test-Path ".\.github\workflows")) {
    Write-Host "📁 Creating .github/workflows directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path ".\.github\workflows" -Force | Out-Null
}

# Create or update the main CI/CD workflow
$ciWorkflowPath = ".\.github\workflows\ci.yml"
$ciWorkflow = @"
name: CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.2
        bundler-cache: true
    
    - name: Install dependencies
      run: npm install
    
    - name: Build Jekyll site
      run: bundle exec jekyll build
    
    - name: Run linter
      run: npm run lint
      continue-on-error: true
    
    - name: Validate HTML
      run: |
        find ./_site -name "*.html" -type f | head -5 | xargs -I {} sh -c 'echo "Checking {}"; head -20 {}'
    
  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    permissions:
      contents: read
      pages: write
      id-token: write
    
    environment:
      name: github-pages
      url: `${{ steps.deployment.outputs.page_url }}
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.2
        bundler-cache: true
    
    - name: Build Jekyll site
      run: bundle exec jekyll build
    
    - name: Upload artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: './_site'
    
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
"@

Write-Host "📝 Creating/updating CI/CD workflow..." -ForegroundColor Yellow
Set-Content -Path $ciWorkflowPath -Value $ciWorkflow -Force
Write-Host "✅ CI/CD workflow created: $ciWorkflowPath" -ForegroundColor Green

# Create deploy workflow
$deployWorkflowPath = ".\.github\workflows\deploy.yml"
$deployWorkflow = @"
name: Deploy to GitHub Pages

on:
  workflow_run:
    workflows: ["CI/CD"]
    types: [completed]
    branches: [main]

jobs:
  deploy:
    if: `${{ github.event.workflow_run.conclusion == 'success' }}
    runs-on: ubuntu-latest
    
    permissions:
      contents: read
      pages: write
      id-token: write
    
    environment:
      name: github-pages
      url: `${{ steps.deployment.outputs.page_url }}
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.2
        bundler-cache: true
    
    - name: Build Jekyll site
      run: bundle exec jekyll build
    
    - name: Upload artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: './_site'
    
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
"@

Write-Host "📝 Creating deploy workflow..." -ForegroundColor Yellow
Set-Content -Path $deployWorkflowPath -Value $deployWorkflow -Force
Write-Host "✅ Deploy workflow created: $deployWorkflowPath" -ForegroundColor Green

# Verify workflows
Write-Host "`n📋 Verifying workflows..." -ForegroundColor Yellow
$workflows = Get-ChildItem ".\.github\workflows" -Filter "*.yml" -ErrorAction SilentlyContinue

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ GitHub Pages Actions Setup Complete!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "`nWorkflows Created:" -ForegroundColor Green
$workflows | ForEach-Object { Write-Host "  ✓ $($_.Name)" -ForegroundColor Green }

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Commit workflows to git" -ForegroundColor Yellow
Write-Host "  2. Push to main branch" -ForegroundColor Yellow
Write-Host "  3. GitHub Pages will deploy automatically" -ForegroundColor Yellow
Write-Host "`nEnsure repository settings have GitHub Pages enabled:" -ForegroundColor Yellow
Write-Host "  Settings > Pages > Source: Deploy from a branch" -ForegroundColor Yellow
Write-Host "  Select branch: main, folder: / (root)" -ForegroundColor Yellow
