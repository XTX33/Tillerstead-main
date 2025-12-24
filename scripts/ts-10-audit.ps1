# Tillerstead Audit Script
# Comprehensive site-wide audit for SEO, accessibility, performance, and compliance

Write-Host "🔍 Tillerstead Site Audit Starting..." -ForegroundColor Cyan

$auditResults = @{
    TotalPages = 0
    SEOIssues = 0
    A11yIssues = 0
    PerformanceIssues = 0
    ComplianceIssues = 0
    Pages = @()
}

# Find all generated HTML files
$htmlFiles = Get-ChildItem -Path ".\_site" -Filter "*.html" -Recurse -ErrorAction SilentlyContinue

Write-Host "📊 Found $($htmlFiles.Count) pages to audit`n" -ForegroundColor Yellow

foreach ($file in $htmlFiles) {
    $auditResults.TotalPages++
    $pageResult = @{
        Path = $file.FullName
        URL = $file.FullName -replace [regex]::Escape("$PWD\_site"), ""
        SEOIssues = @()
        A11yIssues = @()
        PerformanceIssues = @()
        ComplianceIssues = @()
    }

    $html = Get-Content $file.FullName -Raw

    # SEO Checks
    if ($html -notmatch '<meta\s+name=["\x27]description["\x27]') {
        $pageResult.SEOIssues += "Missing meta description"
        $auditResults.SEOIssues++
    }
    if ($html -notmatch '<title>') {
        $pageResult.SEOIssues += "Missing title tag"
        $auditResults.SEOIssues++
    }
    if ($html -notmatch '<link\s+rel=["\x27]canonical["\x27]') {
        $pageResult.SEOIssues += "Missing canonical link"
        $auditResults.SEOIssues++
    }

    # Accessibility Checks
    $imgMatches = [regex]::Matches($html, '<img[^>]*>')
    foreach ($match in $imgMatches) {
        if ($match.Value -notmatch 'alt=') {
            $pageResult.A11yIssues += "Image missing alt attribute: $($match.Value.Substring(0, 50))"
            $auditResults.A11yIssues++
        }
    }

    if ($html -notmatch '<h1[^>]*>') {
        $pageResult.A11yIssues += "Missing H1 heading"
        $auditResults.A11yIssues++
    }

    # Performance Checks
    $styleMatches = [regex]::Matches($html, '<style[^>]*>', 'IgnoreCase')
    if ($styleMatches.Count -gt 5) {
        $pageResult.PerformanceIssues += "Multiple inline styles detected ($($styleMatches.Count))"
        $auditResults.PerformanceIssues++
    }

    # Compliance Checks (TCNA/NJ HIC)
    if ($html -notmatch 'TCNA|NJ HIC|HIC #13VH12057400') {
        $pageResult.ComplianceIssues += "Missing TCNA/NJ HIC compliance markers"
        $auditResults.ComplianceIssues++
    }
    if ($html -notmatch 'schema.org|structured data' -and $file.Name -eq "index.html") {
        $pageResult.ComplianceIssues += "Missing schema.org structured data"
        $auditResults.ComplianceIssues++
    }

    $auditResults.Pages += $pageResult
}

# Display Results
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "AUDIT SUMMARY" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

Write-Host "`n📄 Pages Audited: $($auditResults.TotalPages)" -ForegroundColor White
Write-Host "🔴 SEO Issues: $($auditResults.SEOIssues)" -ForegroundColor $(if ($auditResults.SEOIssues -gt 0) { "Red" } else { "Green" })
Write-Host "🔴 A11y Issues: $($auditResults.A11yIssues)" -ForegroundColor $(if ($auditResults.A11yIssues -gt 0) { "Red" } else { "Green" })
Write-Host "🔴 Performance Issues: $($auditResults.PerformanceIssues)" -ForegroundColor $(if ($auditResults.PerformanceIssues -gt 0) { "Red" } else { "Green" })
Write-Host "🔴 Compliance Issues: $($auditResults.ComplianceIssues)" -ForegroundColor $(if ($auditResults.ComplianceIssues -gt 0) { "Red" } else { "Green" })

$totalIssues = $auditResults.SEOIssues + $auditResults.A11yIssues + $auditResults.PerformanceIssues + $auditResults.ComplianceIssues
Write-Host "`n📌 Total Issues Found: $totalIssues" -ForegroundColor $(if ($totalIssues -gt 0) { "Yellow" } else { "Green" })

# Detailed issues
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "DETAILED FINDINGS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

foreach ($page in $auditResults.Pages | Where-Object { $_.SEOIssues.Count -gt 0 -or $_.A11yIssues.Count -gt 0 -or $_.PerformanceIssues.Count -gt 0 -or $_.ComplianceIssues.Count -gt 0 }) {
    Write-Host "`n📄 $($page.URL)" -ForegroundColor White
    
    if ($page.SEOIssues.Count -gt 0) {
        Write-Host "  🔍 SEO:" -ForegroundColor Yellow
        $page.SEOIssues | ForEach-Object { Write-Host "    • $_" -ForegroundColor Yellow }
    }
    
    if ($page.A11yIssues.Count -gt 0) {
        Write-Host "  ♿ Accessibility:" -ForegroundColor Yellow
        $page.A11yIssues | ForEach-Object { Write-Host "    • $_" -ForegroundColor Yellow }
    }
    
    if ($page.PerformanceIssues.Count -gt 0) {
        Write-Host "  ⚡ Performance:" -ForegroundColor Yellow
        $page.PerformanceIssues | ForEach-Object { Write-Host "    • $_" -ForegroundColor Yellow }
    }
    
    if ($page.ComplianceIssues.Count -gt 0) {
        Write-Host "  ⚖️ Compliance:" -ForegroundColor Yellow
        $page.ComplianceIssues | ForEach-Object { Write-Host "    • $_" -ForegroundColor Yellow }
    }
}

Write-Host "`n✅ Audit Complete!" -ForegroundColor Green
