# Comprehensive verification script for Airline Reservation System

Write-Host "Starting comprehensive verification..." -ForegroundColor Cyan

# 1. Check database
Write-Host "`nChecking database..." -ForegroundColor Yellow

$sqlQuery = @"
IF DB_ID('AirlineDB') IS NOT NULL
BEGIN
    SELECT 'Database exists' as Status;
    SELECT 
        (SELECT COUNT(*) FROM Flights) as FlightCount,
        (SELECT COUNT(*) FROM Users) as UserCount,
        (SELECT COUNT(*) FROM Seats) as SeatCount;
END
ELSE
    SELECT 'Database not found' as Status;
"@

$result = Invoke-Expression "sqlcmd -S `"(LocalDB)\MSSQLLocalDB`" -Q `"$sqlQuery`""
Write-Host $result

# 2. Check file structure
Write-Host "`nChecking file structure..." -ForegroundColor Yellow

$requiredFiles = @(
    "GUI\web.config",
    "GUI\Global.asax",
    "GUI\Styles\main.css",
    "GUI\Styles\modern-theme.css",
    "GUI\Scripts\verify-styles.js",
    "GUI\home.master",
    "GUI\MasterPages\login.aspx",
    "GUI\MasterPages\AIRLINE SCHEDULE.aspx"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✓ Found $file" -ForegroundColor Green
    } else {
        Write-Host "× Missing $file" -ForegroundColor Red
    }
}

# 3. Check web.config
Write-Host "`nChecking web.config..." -ForegroundColor Yellow
$webConfig = Get-Content "GUI\web.config" -Raw

$configChecks = @(
    "connectionString",
    "compilation debug",
    "customErrors mode",
    "staticContent",
    "mimeMap"
)

foreach ($check in $configChecks) {
    if ($webConfig -match $check) {
        Write-Host "✓ Found $check configuration" -ForegroundColor Green
    } else {
        Write-Host "× Missing $check configuration" -ForegroundColor Red
    }
}

# 4. Check CSS content
Write-Host "`nChecking CSS files..." -ForegroundColor Yellow

$cssFiles = @{
    "GUI\Styles\main.css" = @("--primary-color", "form-control", "btn-primary")
    "GUI\Styles\modern-theme.css" = @("--primary-gradient", "login-card", "feature-card")
}

foreach ($css in $cssFiles.GetEnumerator()) {
    if (Test-Path $css.Key) {
        $content = Get-Content $css.Key -Raw
        Write-Host "`nChecking $($css.Key)" -ForegroundColor Yellow
        foreach ($style in $css.Value) {
            if ($content -match $style) {
                Write-Host "✓ Found style: $style" -ForegroundColor Green
            } else {
                Write-Host "× Missing style: $style" -ForegroundColor Red
            }
        }
    }
}

# 5. Test database queries
Write-Host "`nTesting database queries..." -ForegroundColor Yellow

$testQueries = @"
USE AirlineDB;
SELECT TOP 5 * FROM Flights ORDER BY DepartureTime;
SELECT DISTINCT Origin FROM Flights;
SELECT DISTINCT Destination FROM Flights;
"@

Write-Host "Sample flight data:"
Invoke-Expression "sqlcmd -S `"(LocalDB)\MSSQLLocalDB`" -Q `"$testQueries`""

Write-Host "`nVerification complete!" -ForegroundColor Cyan
Write-Host @"

Next steps:
1. If any items are marked with ×, fix those issues first
2. Try these URLs in browser:
   - http://localhost:[port]/GUI/MasterPages/login.aspx
   - http://localhost:[port]/GUI/Styles/css-test.html

3. Login with:
   Username: admin
   Password: admin123

4. If issues persist:
   - Clear browser cache
   - Restart Visual Studio
   - Check IIS Express is running
   - Verify web.config settings
"@ -ForegroundColor White