# Simplified verification script for Airline Reservation System
Write-Host "Starting verification process..." -ForegroundColor Cyan

# 1. Check Database
Write-Host "`nChecking database..." -ForegroundColor Yellow

$sqlQuery = @"
IF DB_ID('AirlineDB') IS NOT NULL
    SELECT 'Database exists' as Status
ELSE
    SELECT 'Database not found' as Status
"@

$result = Invoke-Expression "sqlcmd -S `"(LocalDB)\MSSQLLocalDB`" -Q `"$sqlQuery`""
if ($result -match "Database exists") {
    Write-Host "✓ Database exists" -ForegroundColor Green
    
    # Check tables with separate queries
    Write-Host "`nChecking tables..." -ForegroundColor Yellow
    
    $tableQueries = @(
        "SELECT COUNT(*) FROM AirlineDB.dbo.Flights",
        "SELECT COUNT(*) FROM AirlineDB.dbo.FlightRoutes",
        "SELECT COUNT(*) FROM AirlineDB.dbo.Seats"
    )
    
    foreach ($query in $tableQueries) {
        $count = Invoke-Expression "sqlcmd -S `"(LocalDB)\MSSQLLocalDB`" -Q `"$query`""
        Write-Host "Count: $count" -ForegroundColor Green
    }
} else {
    Write-Host "× Database not found!" -ForegroundColor Red
    Write-Host "Please run create-database.sql and update-routes.sql first"
}

# 2. Check Files
Write-Host "`nChecking required files..." -ForegroundColor Yellow

$requiredFiles = @(
    "GUI\web.config",
    "GUI\Styles\main.css",
    "GUI\Styles\modern-theme.css",
    "GUI\home.master",
    "GUI\MasterPages\AIRLINE SCHEDULE.aspx",
    "GUI\MasterPages\login.aspx"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✓ Found $file" -ForegroundColor Green
    } else {
        Write-Host "× Missing $file" -ForegroundColor Red
    }
}

# 3. Check Image Directories
Write-Host "`nChecking image directories..." -ForegroundColor Yellow

$imageDirs = @(
    "GUI\Images\backgrounds",
    "GUI\Images\airlines",
    "GUI\Images\destinations"
)

foreach ($dir in $imageDirs) {
    if (Test-Path $dir) {
        $files = Get-ChildItem $dir -Filter *.svg
        Write-Host "✓ $dir exists with $($files.Count) SVG files" -ForegroundColor Green
    } else {
        Write-Host "× Missing $dir" -ForegroundColor Red
    }
}

# 4. Check CSS Files
Write-Host "`nVerifying CSS files..." -ForegroundColor Yellow

$cssFiles = @{
    "GUI\Styles\main.css" = "--primary-color"
    "GUI\Styles\modern-theme.css" = "--primary-gradient"
}

foreach ($css in $cssFiles.GetEnumerator()) {
    if (Test-Path $css.Key) {
        $content = Get-Content $css.Key -Raw
        if ($content -match $css.Value) {
            Write-Host "✓ $($css.Key) contains required styles" -ForegroundColor Green
        } else {
            Write-Host "× $($css.Key) missing required styles" -ForegroundColor Red
        }
    }
}

Write-Host "`nChecks completed!" -ForegroundColor Cyan
Write-Host @"

If any items are marked with ×, please:
1. Run create-database.sql and update-routes.sql for database issues
2. Run create-resources.ps1 for missing images
3. Check CSS file contents if styles are missing
4. Verify web.config connection string

Then:
1. Clear browser cache
2. Restart Visual Studio
3. Set login.aspx as start page
4. Press F5 to run
"@ -ForegroundColor White