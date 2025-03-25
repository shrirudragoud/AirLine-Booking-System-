# Adding Flights Data in Visual Studio

## Step 1: Open SQL Server Object Explorer
1. In Visual Studio:
   - View -> SQL Server Object Explorer
   - If you don't see this option, install "Data Storage and Processing" workload:
     * Tools -> Get Tools and Features
     * Check "Data Storage and Processing"

## Step 2: Connect to LocalDB
1. In SQL Server Object Explorer:
   - SQL Server -> (LocalDB)\MSSQLLocalDB
   - If you don't see this connection:
     * Right-click "SQL Server"
     * Select "Add SQL Server"
     * Server name: (LocalDB)\MSSQLLocalDB
     * Authentication: Windows Authentication
     * Click "Connect"

## Step 3: Run Create Database Script
1. Right-click on "(LocalDB)\MSSQLLocalDB"
2. Select "New Query"
3. Copy contents of create-database.sql into query window
4. Click "Execute" (or press Ctrl+Shift+E)
5. Verify in Output window that database was created

## Step 4: Run Add Flights Script
1. In SQL Server Object Explorer:
   - Expand "(LocalDB)\MSSQLLocalDB"
   - Right-click on "AirlineDB"
   - Select "New Query"
2. Copy contents of add-flights.sql into query window
3. Click "Execute" (or press Ctrl+Shift+E)
4. You should see results showing:
   - Total Flights count
   - Routes count
   - Price ranges

## Step 5: Verify Data
1. In SQL Server Object Explorer:
   - Expand "(LocalDB)\MSSQLLocalDB"
   - Expand "AirlineDB"
   - Expand "Tables"
2. Right-click on "dbo.Flights" -> "View Data"
   - You should see all flight routes
3. Right-click on "dbo.Seats" -> "View Data"
   - You should see seats for all flights

## Troubleshooting

1. If "Invalid object name" error:
   ```sql
   USE AirlineDB;
   GO
   ```
   Add this at the start of add-flights.sql and run again

2. If database connection fails:
   - Open Command Prompt as Administrator
   - Run:
     ```cmd
     sqllocaldb stop MSSQLLocalDB
     sqllocaldb start MSSQLLocalDB
     ```
   - Try again in Visual Studio

3. If tables are empty:
   - Right-click on AirlineDB
   - Select "New Query"
   - Run this to check counts:
     ```sql
     SELECT 'Flights: ' + CAST(COUNT(*) as varchar) FROM Flights;
     SELECT 'Seats: ' + CAST(COUNT(*) as varchar) FROM Seats;
     ```

4. To start fresh:
   ```sql
   USE master;
   GO
   ALTER DATABASE AirlineDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE AirlineDB;
   GO
   ```
   Then run create-database.sql and add-flights.sql again

## Expected Results
After running both scripts, you should see:
- 16+ flight routes in the Flights table
- Multiple seats for each flight
- Price ranges from ₹2,799 to ₹34,999
- Mix of domestic and international routes

The application should now show these flights in the schedule and booking pages.