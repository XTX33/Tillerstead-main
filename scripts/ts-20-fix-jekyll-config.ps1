param(
    [string]$SiteUrl = "https://tillerstead.com",
    [string]$BaseUrl = ""
)

Write-Host "🔧 Jekyll Configuration Fix Starting..." -ForegroundColor Cyan
Write-Host "Site URL: $SiteUrl" -ForegroundColor Gray
Write-Host "Base URL: $BaseUrl" -ForegroundColor Gray

# Check if _config.yml exists
if (-not (Test-Path "_config.yml")) {
    Write-Host "❌ _config.yml not found" -ForegroundColor Red
    exit 1
}

# Read current config
$config = Get-Content "_config.yml" -Raw

# Backup original
Copy-Item "_config.yml" "_config.yml.backup" -Force
Write-Host "✅ Backed up _config.yml to _config.yml.backup" -ForegroundColor Green

# Update url and baseurl
if ($config -match "^url:\s*") {
    $config = $config -replace "^url:\s*.*$", "url: `"$SiteUrl`""
} else {
    $config += "`nurl: `"$SiteUrl`""
}

if ($config -match "^baseurl:\s*") {
    $config = $config -replace "^baseurl:\s*.*$", "baseurl: `"$BaseUrl`""
} else {
    $config += "`nbaseurl: `"$BaseUrl`""
}

# Ensure proper SEO settings
if ($config -notmatch "^google_analytics_id:") {
    Write-Host "⚠️  Google Analytics ID not configured" -ForegroundColor Yellow
}

# Update config file
Set-Content "_config.yml" $config
Write-Host "✅ Updated _config.yml" -ForegroundColor Green

# Rebuild Jekyll site
Write-Host "`n🏗️  Rebuilding Jekyll site..." -ForegroundColor Yellow
bundle exec jekyll build

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Jekyll build successful!" -ForegroundColor Green
} else {
    Write-Host "❌ Jekyll build failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Configuration Fixed!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "url: $SiteUrl" -ForegroundColor Green
Write-Host "baseurl: $BaseUrl" -ForegroundColor Green
