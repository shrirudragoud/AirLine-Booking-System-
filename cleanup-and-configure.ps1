# Cleanup script for Airline Reservation System

# 1. Remove Visual Studio and VSCode files
Write-Host "Removing VS/VSCode files..."
$foldersToRemove = @(
    ".vs",
    ".vscode",
    "bin",
    "obj"
)

foreach ($folder in $foldersToRemove) {
    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
        Write-Host "Removed $folder"
    }
}

# 2. Create required directories
Write-Host "`nCreating required directories..."
$directories = @(
    "GUI\App_Data",
    "GUI\Images",
    "GUI\Images\backgrounds",
    "GUI\Images\airlines",
    "GUI\Images\destinations",
    "GUI\Styles"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
        Write-Host "Created $dir"
    }
}

# 3. Update web.config
Write-Host "`nUpdating web.config..."
$webConfigPath = "GUI\web.config"
$webConfigContent = @'
<?xml version="1.0"?>
<configuration>
  <connectionStrings>
    <add name="conn" connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=AirlineDB;Integrated Security=True" providerName="System.Data.SqlClient"/>
    <add name="AirlineConnectionString" connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=AirlineDB;Integrated Security=True" providerName="System.Data.SqlClient"/>
  </connectionStrings>
  <system.web>
    <compilation debug="true" targetFramework="4.8"/>
    <httpRuntime targetFramework="4.8"/>
    <customErrors mode="Off"/>
  </system.web>
  <appSettings>
    <add key="ValidationSettings:UnobtrusiveValidationMode" value="None"/>
  </appSettings>
  <system.webServer>
    <staticContent>
      <mimeMap fileExtension=".svg" mimeType="image/svg+xml"/>
    </staticContent>
  </system.webServer>
</configuration>
'@
Set-Content -Path $webConfigPath -Value $webConfigContent -Force
Write-Host "Updated web.config"

# 4. Fix CSS references
Write-Host "`nChecking CSS references..."
$masterPagePath = "GUI\home.master"
$masterContent = Get-Content $masterPagePath -Raw
if (-not ($masterContent -match "modern-theme.css")) {
    Write-Host "Adding modern-theme.css reference to master page..."
    $masterContent = $masterContent -replace '(<link href="~/Styles/main.css".*?>)', '$1`n    <link href="~/Styles/modern-theme.css" rel="stylesheet" type="text/css" />'
    Set-Content -Path $masterPagePath -Value $masterContent -Force
}

# 5. Update Routes
Write-Host "`nUpdating database routes..."
$LocalDB = "(LocalDB)\MSSQLLocalDB"
$Database = "AirlineDB"

# Execute SQL scripts
$sqlcmd = "sqlcmd -S `"$LocalDB`" -d master -Q `"USE [master]; IF EXISTS (SELECT name FROM sys.databases WHERE name = '$Database') DROP DATABASE [$Database]`""
Invoke-Expression $sqlcmd

Write-Host "Executing create-database.sql..."
$sqlcmd = "sqlcmd -S `"$LocalDB`" -i create-database.sql"
Invoke-Expression $sqlcmd

Write-Host "Executing update-routes.sql..."
$sqlcmd = "sqlcmd -S `"$LocalDB`" -d $Database -i update-routes.sql"
Invoke-Expression $sqlcmd

Write-Host "`nSetup complete! Please:"
Write-Host "1. Open the project in Visual Studio"
Write-Host "2. Set login.aspx as start page"
Write-Host "3. Press F5 to run"
Write-Host "4. Login with admin/admin123"
