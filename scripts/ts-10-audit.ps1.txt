# scripts/ts-10-audit.ps1
[CmdletBinding()]
param(
  [string]$RepoRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$reportDir = Join-Path $RepoRoot "docs\reports"
if (-not (Test-Path $reportDir)) { New-Item -ItemType Directory -Path $reportDir | Out-Null }

function Get-TextFile($path) {
  if (Test-Path $path) { Get-Content -Raw -Path $path } else { $null }
}

$cfg = Get-TextFile (Join-Path $RepoRoot "_config.yml")
$hasConfig = [bool]$cfg
$indexHtml = Get-TextFile (Join-Path $RepoRoot "index.html")
$indexMd   = Get-TextFile (Join-Path $RepoRoot "index.md")

$workflows = Get-ChildItem (Join-Path $RepoRoot ".github\workflows") -Filter *.yml -ErrorAction SilentlyContinue
# Always rebuild _site before auditing (prevents stale/fragment output)
Push-Location $RepoRoot
try {
  if (Test-Path ".\_site") { Remove-Item -Recurse -Force ".\_site" -ErrorAction SilentlyContinue }

  if (Test-Path ".\Gemfile") {
    Write-Host "🏗️  Building site with Jekyll (bundle exec jekyll build)..."
    bundle exec jekyll build
  } else {
    Write-Host "⚠️  Gemfile not found; skipping Jekyll build."
  }
} finally {
  Pop-Location
}
# Detect likely stack
$stack = "unknown"
if (Test-Path (Join-Path $RepoRoot "Gemfile")) { $stack = "jekyll" }
elseif (Test-Path (Join-Path $RepoRoot "package.json")) { $stack = "node" }

# Common CSS path problems: absolute /assets vs baseurl, etc.
$cssRefs = @()
Get-ChildItem $RepoRoot -Recurse -Include *.html,*.md,*.liquid -ErrorAction SilentlyContinue |
  ForEach-Object {
    $raw = Get-Content -Raw $_.FullName
    if ($raw -match "href\s*=\s*[""']([^""']+\.css[^""']*)[""']") {
      $matches = [regex]::Matches($raw, "href\s*=\s*[""']([^""']+\.css[^""']*)[""']")
      foreach ($m in $matches) { $cssRefs += [PSCustomObject]@{ file=$_.FullName; href=$m.Groups[1].Value } }
    }
  }

# Check for duplicated/competing headers/nav includes
$headerFiles = Get-ChildItem $RepoRoot -Recurse -Include "header*.html","nav*.html" -ErrorAction SilentlyContinue

# Save report
$report = [PSCustomObject]@{
  RepoRoot           = $RepoRoot
  Stack              = $stack
  HasJekyllConfig     = $hasConfig
  WorkflowFiles       = ($workflows.FullName -join "`n")
  CssRefsCount        = $cssRefs.Count
  CssRefsSample       = ($cssRefs | Select-Object -First 15 | Format-Table -AutoSize | Out-String)
  HeaderNavCandidates = ($headerFiles.FullName -join "`n")
}

$reportPath = Join-Path $reportDir ("audit-{0}.txt" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$report | Format-List | Out-String | Set-Content -Encoding UTF8 $reportPath

Write-Host "Audit written to: $reportPath"
Write-Host "Tip: paste that file back here and I can give you a precise fix plan."
