# Create directories
New-Item -ItemType Directory -Force -Path "GUI\Images"
New-Item -ItemType Directory -Force -Path "GUI\Images\backgrounds"
New-Item -ItemType Directory -Force -Path "GUI\Images\airlines"
New-Item -ItemType Directory -Force -Path "GUI\Images\destinations"

# Background image templates
$heroBackground = @"
<svg width="1920" height="1080" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#00509d;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#0066cc;stop-opacity:1" />
        </linearGradient>
    </defs>
    <rect width="100%" height="100%" fill="url(#grad)"/>
    <g fill="#ffffff" fill-opacity="0.1" transform="rotate(45)">
        <path d="M0 0h8v8h-8z"/>
    </g>
</svg>
"@

$airlineLogos = @{
    "air-india" = @"
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
    <circle cx="100" cy="100" r="90" fill="#ffffff"/>
    <text x="100" y="120" font-family="Arial" font-size="24" fill="#00509d" text-anchor="middle">Air India</text>
</svg>
"@
    "jet-airways" = @"
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
    <circle cx="100" cy="100" r="90" fill="#ffffff"/>
    <text x="100" y="120" font-family="Arial" font-size="24" fill="#00509d" text-anchor="middle">Jet Airways</text>
</svg>
"@
}

# Save background image
$heroBackground | Out-File -FilePath "GUI\Images\backgrounds\hero-bg.svg" -Encoding UTF8

# Save airline logos
foreach ($airline in $airlineLogos.Keys) {
    $airlineLogos[$airline] | Out-File -FilePath "GUI\Images\airlines\$airline.svg" -Encoding UTF8
}

# Create destination placeholder images with gradients
$destinations = @(
    @{ name = "delhi"; color1 = "#FF6B6B"; color2 = "#FF8E8E" },
    @{ name = "mumbai"; color1 = "#4ECDC4"; color2 = "#45B7D1" },
    @{ name = "bangalore"; color1 = "#96CEB4"; color2 = "#FFEEAD" },
    @{ name = "chennai"; color1 = "#D4A5A5"; color2 = "#9B59B6" },
    @{ name = "kolkata"; color1 = "#FCE38A"; color2 = "#F38181" },
    @{ name = "hyderabad"; color1 = "#95E1D3"; color2 = "#EAFFD0" },
    @{ name = "dubai"; color1 = "#F9ED69"; color2 = "#F08A5D" },
    @{ name = "singapore"; color1 = "#B83B5E"; color2 = "#F08A5D" }
)

foreach ($dest in $destinations) {
    $svg = @"
<svg width="800" height="400" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:$($dest.color1);stop-opacity:1" />
            <stop offset="100%" style="stop-color:$($dest.color2);stop-opacity:1" />
        </linearGradient>
    </defs>
    <rect width="100%" height="100%" fill="url(#grad)"/>
    <text x="50%" y="50%" font-family="Arial" font-size="48" fill="white" text-anchor="middle" dominant-baseline="middle">$($dest.name.ToUpper())</text>
</svg>
"@
    $svg | Out-File -FilePath "GUI\Images\destinations\$($dest.name).svg" -Encoding UTF8
}

Write-Host "Created image resources in GUI\Images\"
Write-Host "- backgrounds\hero-bg.svg"
Write-Host "- airlines\air-india.svg"
Write-Host "- airlines\jet-airways.svg"
Write-Host "Created destination images for: $($destinations.name -join ', ')"