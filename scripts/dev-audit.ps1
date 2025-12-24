<#
  dev-audit.ps1 — Tillerstead Accessibility & SEO Heuristic Audit (TCNA/NJ HIC Compliant)

  Usage:
    powershell -ExecutionPolicy Bypass -File scripts/dev-audit.ps1

  Checks:
    - Flags <img> missing descriptive alt text (ADA/NJ HIC §13:45A-16.2 compliance)
    - Title length (50–60 chars, per SEO best practice)
    - Meta description length (150–160 chars, conversion-optimized)
    - Canonical link presence (prevents duplicate content, SEO)
    - H1 count (1 per page, TCNA §3.2.1.1 for clarity)
    - Inline color styles (flags for contrast review, WCAG 2.1 AA)
#>

$ErrorActionPreference = 'Stop'
Write-Host '=== Tillerstead Dev Audit (TCNA/NJ HIC/ADA Heuristic) ===' -ForegroundColor Cyan

# Gather HTML files (exclude _site, vendor, node_modules)
$files = Get-ChildItem -Path "$PSScriptRoot/.." -Include *.html -Recurse | Where-Object {
    $_.FullName -notmatch '(_site|vendor|node_modules)'
}

foreach ($f in $files) {
    $html = Get-Content $f.FullName -Raw

    # Title extraction
    $titleMatch = [regex]::Match($html, '<title>([\s\S]*?)</title>', 'IgnoreCase')
    $title = if ($titleMatch.Success) { $titleMatch.Groups[1].Value.Trim() } else { '' }

    # Meta description extraction
    $metaDescMatch = [regex]::Match($html, '<meta\s+name=["\x27]description["\x27]\s+content=["\x27]([^"\']+)["\x27]', 'IgnoreCase')
    $metaDesc = if ($metaDescMatch.Success) { $metaDescMatch.Groups[1].Value.Trim() } else { '' }

    # Canonical link extraction
    $canonicalMatch = [regex]::Match($html, '<link\s+rel=["\x27]canonical["\x27]\s+href=["\x27]([^"\']+)["\x27]', 'IgnoreCase')
    $canonical = if ($canonicalMatch.Success) { $canonicalMatch.Groups[1].Value.Trim() } else { '' }

    # <img> alt attribute check (must be present and descriptive)
    $imgs = [regex]::Matches($html, '<img[^>]*>', 'IgnoreCase')
    $missingAlt = @()
    foreach ($img in $imgs) {
        $altMatch = [regex]::Match($img.Value, 'alt=["'']([^"']*)["'']', 'IgnoreCase')
        if (-not $altMatch.Success -or [string]::IsNullOrWhiteSpace($altMatch.Groups[1].Value)) {
            $missingAlt += $img.Value
        }
    }

    # H1 count (should be exactly 1)
    $h1Count = ([regex]::Matches($html, '<h1[\s>]', 'IgnoreCase')).Count

    # Inline color style check (flag for manual contrast review)
    $inlineColorStyles = ([regex]::Matches($html, 'style=["''][^"''>]*color\s*:\s*#?[0-9a-fA-F]{3,6}', 'IgnoreCase')).Count

    Write-Host "File: $($f.Name)" -ForegroundColor Yellow

    if ($title) {
        Write-Host "  Title length: $($title.Length) — $title"
        if ($title.Length -lt 50 -or $title.Length -gt 60) {
            Write-Host "    ⚠ Title length outside optimal SEO range (50–60 chars)" -ForegroundColor Red
        }
    } else {
        Write-Host '  Title: MISSING' -ForegroundColor Red
    }

    if ($metaDesc) {
        Write-Host "  Meta description length: $($metaDesc.Length)"
        if ($metaDesc.Length -lt 150 -or $metaDesc.Length -gt 160) {
            Write-Host "    ⚠ Meta description outside optimal range (150–160 chars)" -ForegroundColor Red
        }
    } else {
        Write-Host '  Meta description: MISSING' -ForegroundColor Red
    }

    Write-Host "  Canonical present: $([bool]$canonical)"
    if (-not $canonical) {
        Write-Host "    ⚠ Canonical link missing (SEO best practice)" -ForegroundColor Red
    }

    Write-Host "  H1 count: $h1Count"
    if ($h1Count -ne 1) {
        Write-Host "    ⚠ H1 count should be exactly 1 per page (TCNA §3.2.1.1)" -ForegroundColor Red
    }

    if ($missingAlt.Count -gt 0) {
        Write-Host "  Missing or empty alt attributes: $($missingAlt.Count)" -ForegroundColor Red
        foreach ($img in $missingAlt) {
            Write-Host "    $img"
        }
        Write-Host "    ⚠ All images require descriptive alt text (ADA/NJ HIC §13:45A-16.2)" -ForegroundColor Red
    } else {
        Write-Host '  All images have descriptive alt attributes.'
    }

    if ($inlineColorStyles -gt 0) {
        Write-Host "  Inline color styles (manual contrast review needed): $inlineColorStyles" -ForegroundColor Magenta
        Write-Host "    ⚠ Inline color styles must meet WCAG 2.1 AA contrast (see .ai/COMPLIANCE.md)" -ForegroundColor Magenta
    }

    Write-Host ''
}

Write-Host '=== Audit Complete: All findings above must be addressed for TCNA/NJ HIC/ADA compliance. ===' -ForegroundColor Cyan
