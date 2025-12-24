# Tillerstead Bootstrap Script
# Initializes development environment and runs initial setup

Write-Host "🚀 Tillerstead Bootstrap Starting..." -ForegroundColor Cyan

# Step 1: Install dependencies
Write-Host "`n📦 Installing dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ npm install failed" -ForegroundColor Red
    exit 1
}

# Step 2: Run build
Write-Host "`n🔨 Building project..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ npm build failed" -ForegroundColor Red
    exit 1
}

# Step 3: Run linter
Write-Host "`n🔍 Running linter..." -ForegroundColor Yellow
npm run lint
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Linter warnings detected (non-fatal)" -ForegroundColor Yellow
}

# Step 4: Run tests if available
Write-Host "`n🧪 Running tests..." -ForegroundColor Yellow
if (Test-Path "package.json") {
    $packageJson = Get-Content package.json | ConvertFrom-Json
    if ($packageJson.scripts.test) {
        npm test
    } else {
        Write-Host "⏭️  No test script found" -ForegroundColor Gray
    }
}

Write-Host "`n✅ Bootstrap Complete!" -ForegroundColor Green
Write-Host "Environment is ready for development." -ForegroundColor Green
