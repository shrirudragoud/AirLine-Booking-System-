# Create destination placeholder images
$destinations = @(
    @{ name = "delhi"; color = "#FF6B6B" },
    @{ name = "mumbai"; color = "#4ECDC4" },
    @{ name = "bangalore"; color = "#45B7D1" },
    @{ name = "goa"; color = "#96CEB4" },
    @{ name = "agra"; color = "#D4A5A5" },
    @{ name = "chennai"; color = "#9B59B6" }
)

# HTML template for SVG placeholder
$svgTemplate = @"
<svg width="800" height="400" xmlns="http://www.w3.org/2000/svg">
    <rect width="100%" height="100%" fill="{0}"/>
    <text x="50%" y="50%" font-family="Arial" font-size="48" fill="white" text-anchor="middle" dominant-baseline="middle">{1}</text>
</svg>
"@

# Create destinations directory if it doesn't exist
$destinationsPath = "GUI\Images\destinations"
if (-not (Test-Path $destinationsPath)) {
    New-Item -ItemType Directory -Path $destinationsPath -Force
}

# Create SVG files for each destination
foreach ($dest in $destinations) {
    $svg = $svgTemplate -f $dest.color, $dest.name.ToUpper()
    $filePath = Join-Path $destinationsPath "$($dest.name).jpg"
    [System.IO.File]::WriteAllText($filePath, $svg)
    Write-Host "Created placeholder for $($dest.name)"
}