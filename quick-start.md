# Quick Start Guide for Airline Reservation System

## Step 1: Install Required Software
1. Install Visual Studio Community Edition with these components:
   - ASP.NET and web development
   - Data storage and processing (includes SQL Server Express LocalDB)

## Step 2: Set up LocalDB
1. Open Command Prompt as Administrator
2. Run these commands to verify LocalDB:
   ```cmd
   sqllocaldb info MSSQLLocalDB
   ```
   If it doesn't exist, create it:
   ```cmd
   sqllocaldb create MSSQLLocalDB
   ```
   Start the instance:
   ```cmd
   sqllocaldb start MSSQLLocalDB
   ```

## Step 3: Create Database
1. Open SQL Server Management Studio (SSMS)
2. Connect to: `(LocalDB)\MSSQLLocalDB`
3. Open create-database.sql in SSMS
4. Click Execute (or press F5)
5. Verify in the Messages pane that you see:
   - Users Count: 1
   - Flights Count: 4
   - Seats Count: 80

## Step 4: Open Project
1. Open Visual Studio as Administrator
2. Go to File -> Open -> Web Site...
3. Navigate to and select the GUI folder
4. In Solution Explorer, verify these files exist:

   Master Page Files:
   - GUI/home.master
   - GUI/home.master.cs
   - GUI/Styles/main.css

   Page Files in GUI/MasterPages:
   - login.aspx and login.aspx.cs
   - home.aspx and home.aspx.cs
   - All other .aspx files have corresponding .aspx.cs files

## Step 5: Verify Database Connection
1. Open web.config
2. Verify connection strings are correct:
   ```xml
   <add name="conn" connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=AirlineDB;Integrated Security=True" providerName="System.Data.SqlClient"/>
   ```
3. In Visual Studio's Server Explorer (View -> Server Explorer):
   - Click "Connect to Database"
   - Data source: Microsoft SQL Server
   - Server name: (LocalDB)\MSSQLLocalDB
   - Select or enter database name: AirlineDB
   - Click "Test Connection" - should succeed

## Step 6: Run the Project
1. In Solution Explorer, locate MasterPages/login.aspx
2. Right-click -> Set As Start Page
3. Press F5 or click "Start Debugging"
4. The website should open in your browser

## Login Credentials
- Username: admin
- Password: admin123

## Troubleshooting

1. If you get database errors:
   - Make sure LocalDB is running:
     ```cmd
     sqllocaldb start MSSQLLocalDB
     ```
   - Try deleting and recreating the database:
     - Open SSMS
     - Run create-database.sql again
     - It will drop and recreate the database

2. If login fails:
   - Check the error message shown on the login page
   - Verify database was created successfully in SSMS
   - Try running these queries in SSMS:
     ```sql
     USE AirlineDB;
     SELECT * FROM Users;
     ```
   - You should see the admin user

3. If pages don't load:
   - Make sure all .aspx files have matching .aspx.cs files
   - Verify inheritance names match in both files
   - Clean and rebuild the solution

4. For any other errors:
   - Check the Visual Studio Output window
   - Look at the Error List window
   - Enable detailed errors in web.config:
     ```xml
     <customErrors mode="Off"/>