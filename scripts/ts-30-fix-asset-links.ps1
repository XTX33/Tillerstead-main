param(
    [switch]$WhatIf
)

Write-Host "🔗 Asset Links Fix Starting..." -ForegroundColor Cyan
Write-Host "Mode: $(if ($WhatIf) { 'Preview (WhatIf)' } else { 'Apply Changes' })" -ForegroundColor Gray

$issues = @()
$fixes = @()

# Find all HTML files in _site
$htmlFiles = Get-ChildItem -Path ".\_site" -Filter "*.html" -Recurse -ErrorAction SilentlyContinue

Write-Host "📊 Scanning $($htmlFiles.Count) HTML files for broken asset links...`n" -ForegroundColor Yellow

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Fix relative asset paths - ensure they use /assets/ prefix
    $patterns = @(
        @{ Pattern = 'href=["\x27](?!(?:https?:|mailto:|tel:|sms:|#|/))([^"\x27]+)["\x27]'; Replacement = 'href="/assets/$1"'; Type = "Relative href" },
        @{ Pattern = 'src=["\x27](?!(?:https?:|/|#|data:))([^"\x27]+)["\x27]'; Replacement = 'src="/assets/$1"'; Type = "Relative src" },
        @{ Pattern = 'url\(["\x27]?(?!(?:https?:|/|#|data:|%23))([^)"\x27]+)["\x27]?\)'; Replacement = 'url(/assets/$1)'; Type = "CSS url()" }
    )
    
    $modified = $false
    foreach ($pattern in $patterns) {
        $matches = [regex]::Matches($content, $pattern.Pattern)
        if ($matches.Count -gt 0) {
            foreach ($match in $matches) {
                $issues += @{
                    File = $file.FullName -replace [regex]::Escape("$PWD\_site"), ""
                    Type = $pattern.Type
                    Match = $match.Value
                }
                Write-Host "  ⚠️  $($pattern.Type) in $($file.Name)" -ForegroundColor Yellow
                Write-Host "     Found: $($match.Value.Substring(0, [Math]::Min(60, $match.Value.Length)))" -ForegroundColor Gray
                
                if (-not $WhatIf) {
                    $content = $content -replace [regex]::Escape($match.Value), $pattern.Replacement
                    $modified = $true
                }
            }
        }
    }
    
    # Fix broken image srcset paths
    if ($content -match 'srcset=["\x27]([^"]+)["\x27]') {
        $srcsetMatches = [regex]::Matches($content, 'srcset=["\x27]([^"]+)["\x27]')
        foreach ($match in $srcsetMatches) {
            $srcset = $match.Groups[1].Value
            if ($srcset -notmatch '/assets/') {
                $issues += @{
                    File = $file.FullName -replace [regex]::Escape("$PWD\_site"), ""
                    Type = "srcset path"
                    Match = $match.Value
                }
                Write-Host "  ⚠️  srcset path issue in $($file.Name)" -ForegroundColor Yellow
            }
        }
    }
    
    # Save if modified
    if ($modified -and -not $WhatIf) {
        Set-Content $file.FullName $content
        $fixes += $file.FullName
        Write-Host "  ✅ Fixed: $($file.Name)" -ForegroundColor Green
    }
}

# Summary
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

Write-Host "`n📋 Issues Found: $($issues.Count)" -ForegroundColor $(if ($issues.Count -gt 0) { "Yellow" } else { "Green" })

if ($issues.Count -gt 0) {
    Write-Host "`nIssue Details:" -ForegroundColor Yellow
    $issues | Group-Object -Property Type | ForEach-Object {
        Write-Host "  $($_.Name): $($_.Count) occurrences" -ForegroundColor Yellow
    }
}

if ($WhatIf) {
    Write-Host "`n🔍 WhatIf Mode: No changes applied" -ForegroundColor Cyan
    Write-Host "Run without -WhatIf to apply fixes" -ForegroundColor Cyan
} else {
    Write-Host "`n✅ Files Fixed: $($fixes.Count)" -ForegroundColor Green
    if ($fixes.Count -gt 0) {
        Write-Host "Next steps: npm run build && npm run test" -ForegroundColor Green
    }
}
