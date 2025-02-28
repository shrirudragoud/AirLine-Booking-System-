# Visual Guide: Setting Up Database in Visual Studio

## Step 1: Open SQL Server Object Explorer
1. In Visual Studio menu: 
   - Click "View" 
   - Click "SQL Server Object Explorer"
   - It usually appears on the right side

## Step 2: Connect to LocalDB
1. In SQL Server Object Explorer:
   - Right-click "SQL Server" 
   - Select "Add SQL Server"
   - In the "Connect" window:
     * Server Name: (LocalDB)\MSSQLLocalDB
     * Authentication: Windows Authentication
     * Click "Connect"

## Step 3: Execute Database Scripts
1. Right-click on "(LocalDB)\MSSQLLocalDB"
2. Select "New Query"
3. A new query window opens
4. Copy the entire content of create-database.sql into this window
5. Click the green "Execute" button (or press Ctrl+Shift+E)

## Step 4: Add Routes
1. Click "New Query" again
2. Copy the entire content of update-routes.sql
3. Click "Execute"

## Detailed Steps with Menu Options

### If SQL Server Object Explorer is not visible:
1. Tools → Get Tools and Features
2. Check "Data storage and processing"
3. Click "Modify" to install

### If LocalDB is not running:
1. Open Command Prompt as Administrator
2. Run these commands:
   ```cmd
   sqllocaldb stop MSSQLLocalDB
   sqllocaldb start MSSQLLocalDB
   ```

### Alternative Method Using SSMS:
1. Open SQL Server Management Studio
2. Connect to: (LocalDB)\MSSQLLocalDB
3. Open create-database.sql
4. Click Execute (F5)
5. Open update-routes.sql
6. Click Execute (F5)

## Verify Setup Success

After running the scripts:
1. In SQL Server Object Explorer:
   - Expand "(LocalDB)\MSSQLLocalDB"
   - Expand "Databases"
   - You should see "AirlineDB"
   - Expand "Tables"
   - You should see:
     * dbo.Flights
     * dbo.FlightRoutes
     * dbo.Seats
     * dbo.Users

2. Verify data:
   ```sql
   USE AirlineDB;
   GO
   
   -- Check routes
   SELECT COUNT(*) FROM FlightRoutes;
   
   -- Check flights
   SELECT COUNT(*) FROM Flights;
   
   -- Check seats
   SELECT COUNT(*) FROM Seats;
   ```

## Troubleshooting

If "Database 'AirlineDB' already exists":
```sql
USE master;
GO
ALTER DATABASE AirlineDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE AirlineDB;
GO
```
Then run the scripts again.

If "Invalid object name":
```sql
USE AirlineDB;
GO
```
Then run the scripts again.

The database should now be set up with all routes and ready for the enhanced UI.