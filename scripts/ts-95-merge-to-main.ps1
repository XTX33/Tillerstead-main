<#
ts-95-merge-to-main.ps1

Safely merge the current branch into main from repo root.

Behavior:
- Verifies clean working tree
- Fetches latest origin
- Updates main
- Merges current branch -> main
- Pushes main

Run from repo root:
  pwsh .\scripts\ts-95-merge-to-main.ps1

Optional:
  -NoPush   (merge locally only)
#>

[CmdletBinding()]
param(
    [switch]$NoPush
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host "ERROR: $msg" -ForegroundColor Red
    exit 1
}

function Run($cmd) {
    Write-Host "› $cmd" -ForegroundColor DarkGray
    $out = Invoke-Expression $cmd
    if ($LASTEXITCODE -ne 0) {
        Fail "Command failed: $cmd"
    }
    return $out
}

Write-Host "`n=== Git Merge to main ===" -ForegroundColor Cyan

# Ensure we are in a git repo
if (-not (Test-Path ".git")) {
    Fail "Not in repo root (no .git directory found)."
}

# Ensure clean working tree
$status = Run "git status --porcelain"
if ($status) {
    Fail "Working tree is NOT clean. Commit or stash changes first."
}

# Identify current branch
$currentBranch = (Run "git branch --show-current").Trim()
if (-not $currentBranch) {
    Fail "Unable to determine current branch."
}

if ($currentBranch -eq "main") {
    Fail "You are already on main. Checkout the branch you want to merge first."
}

Write-Host "Current branch: $currentBranch" -ForegroundColor Green

# Fetch updates
Run "git fetch origin"

# Switch to main
Run "git checkout main"

# Ensure main is up to date
Run "git pull origin main"

# Merge branch
Write-Host "`nMerging $currentBranch → main" -ForegroundColor Cyan
Run "git merge --no-ff $currentBranch"

# Push
if (-not $NoPush) {
    Write-Host "`nPushing main → origin" -ForegroundColor Cyan
    Run "git push origin main"
}
else {
    Write-Host "`nMerge completed locally (no push)." -ForegroundColor Yellow
}

Write-Host "`n✓ Merge completed successfully." -ForegroundColor Green
