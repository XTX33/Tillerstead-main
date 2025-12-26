# Image Optimization Script
# Converts large JPEG images to optimized WebP format

# Note: Requires imagemagick or similar tool
# Install: choco install imagemagick (Windows)
# Or use online converter: https://www.online-convert.com/

Write-Host "Image Optimization Report"
Write-Host "=========================="
Write-Host ""

$images = Get-ChildItem -Path "assets\img\tillerstead-work\bathrooms" -Include "*.jpg", "*.jpeg" -Recurse

foreach ($img in $images) {
    $sizeMB = [math]::Round($img.Length / 1MB, 2)
    $hasWebP = Test-Path ($img.FullName -replace '\.(jpg|jpeg)$', '.webp')
    
    Write-Host "$($img.Name)"
    Write-Host "  Size: $sizeMB MB"
    Write-Host "  WebP: $(if ($hasWebP) { '✓ Exists' } else { '✗ Missing' })"
    
    if ($sizeMB -gt 1 -and -not $hasWebP) {
        Write-Host "  Action: CREATE WebP version (target: < 500 KB)"
    }
    
    Write-Host ""
}

Write-Host "Recommendations:"
Write-Host "1. Convert JPEGs > 1MB to WebP format"
Write-Host "2. Target size: < 500 KB per image"
Write-Host "3. Quality setting: 80-85%"
Write-Host "4. Maintain aspect ratio and dimensions"
Write-Host ""
Write-Host "Tools:"
Write-Host "  - ImageMagick: magick convert input.jpg -quality 85 output.webp"
Write-Host "  - Online: https://squoosh.app/"
Write-Host "  - Batch: https://www.xnview.com/en/xnconvert/"
