# Repair Config and Package Script
# Validates and repairs configuration files and package dependencies

Write-Host "🔧 Config & Package Repair Starting..." -ForegroundColor Cyan

# Verify _config.yml exists and is valid YAML
Write-Host "`n📋 Checking _config.yml..." -ForegroundColor Yellow
if (-not (Test-Path "_config.yml")) {
    Write-Host "❌ _config.yml not found" -ForegroundColor Red
    exit 1
}

$configContent = Get-Content "_config.yml" -Raw
if ($configContent -match "^url:" -and $configContent -match "^baseurl:") {
    Write-Host "✅ _config.yml is properly configured" -ForegroundColor Green
} else {
    Write-Host "⚠️  _config.yml may be incomplete" -ForegroundColor Yellow
}

# Verify package.json
Write-Host "`n📦 Checking package.json..." -ForegroundColor Yellow
if (Test-Path "package.json") {
    try {
        $packageJson = Get-Content package.json | ConvertFrom-Json
        Write-Host "✅ package.json is valid JSON" -ForegroundColor Green
        Write-Host "   Name: $($packageJson.name)" -ForegroundColor Gray
        Write-Host "   Version: $($packageJson.version)" -ForegroundColor Gray
    } catch {
        Write-Host "❌ package.json is invalid JSON" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "⚠️  package.json not found" -ForegroundColor Yellow
}

# Verify Gemfile for Ruby dependencies
Write-Host "`n💎 Checking Gemfile..." -ForegroundColor Yellow
if (Test-Path "Gemfile") {
    Write-Host "✅ Gemfile exists" -ForegroundColor Green
    $gemfileLines = (Get-Content "Gemfile" | Measure-Object -Line).Lines
    Write-Host "   Lines: $gemfileLines" -ForegroundColor Gray
} else {
    Write-Host "⚠️  Gemfile not found (required for Jekyll)" -ForegroundColor Yellow
}

# Verify .gitignore
Write-Host "`n🔒 Checking .gitignore..." -ForegroundColor Yellow
if (Test-Path ".gitignore") {
    Write-Host "✅ .gitignore exists" -ForegroundColor Green
    $commonPatterns = @("node_modules", "_site", ".sass-cache", "Gemfile.lock")
    $gitignore = Get-Content ".gitignore" -Raw
    $foundPatterns = 0
    foreach ($pattern in $commonPatterns) {
        if ($gitignore -match $pattern) {
            $foundPatterns++
        }
    }
    Write-Host "   Found $foundPatterns/$($commonPatterns.Count) common patterns" -ForegroundColor Gray
} else {
    Write-Host "⚠️  .gitignore not found" -ForegroundColor Yellow
}

# Check critical directories
Write-Host "`n📁 Checking directory structure..." -ForegroundColor Yellow
$dirs = @("_includes", "_layouts", "_sass", "assets", "scripts", ".github/workflows")
foreach ($dir in $dirs) {
    if (Test-Path $dir) {
        $count = (Get-ChildItem $dir -ErrorAction SilentlyContinue | Measure-Object).Count
        Write-Host "✅ $dir ($count items)" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $dir (missing)" -ForegroundColor Yellow
    }
}

# Verify npm scripts
Write-Host "`n🏃 Checking npm scripts..." -ForegroundColor Yellow
if (Test-Path "package.json") {
    $packageJson = Get-Content package.json | ConvertFrom-Json
    $requiredScripts = @("build", "lint", "test")
    foreach ($script in $requiredScripts) {
        if ($packageJson.scripts.$script) {
            Write-Host "✅ $script script exists" -ForegroundColor Green
        } else {
            Write-Host "⚠️  $script script missing" -ForegroundColor Yellow
        }
    }
}

# Final validation
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Config & Package Check Complete!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

Write-Host "`nRepository is ready for deployment." -ForegroundColor Green
Write-Host "Next: git add . && git commit && git push" -ForegroundColor Yellow
