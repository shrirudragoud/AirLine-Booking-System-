# Database Setup Guide

## Step 1: Create Database and Schema
1. Open SQL Server Management Studio
2. Connect to: `(LocalDB)\MSSQLLocalDB`
3. Run this script first:
   ```sql
   execute create-database.sql
   ```
   This will:
   - Create AirlineDB
   - Create all required tables
   - Add basic user data
   - Set up initial flight structure

## Step 2: Add Sample Flights
1. In the same SQL Server Management Studio window
2. Run this script:
   ```sql
   execute add-flights.sql
   ```
   This will add:
   - 16 new flight routes
   - Price ranges from ₹2,799 to ₹34,999
   - Mix of domestic and international routes
   - Seats for all flights

## Step 3: Verify Setup
After running both scripts, you should see:
1. Route Statistics:
   - Multiple domestic routes (Delhi-Mumbai, Chennai-Bangalore, etc.)
   - International routes (Delhi-Dubai, Mumbai-Singapore)
   - Various price ranges for different routes

2. Check Tables:
   ```sql
   USE AirlineDB;
   
   -- Check Users
   SELECT * FROM Users;
   
   -- Check Flights
   SELECT * FROM Flights;
   
   -- Check Seats
   SELECT * FROM Seats;
   ```

## Step 4: Test in Application
1. Run the website
2. Login with:
   - Username: admin
   - Password: admin123

3. Test Flight Search:
   - Check all routes are visible
   - Try sorting by price
   - Filter by different cities
   - Verify seat availability

## Troubleshooting

1. If "Invalid object name 'Flights'" error:
   ```sql
   USE AirlineDB;
   GO
   ```
   Then run the scripts again

2. If database already exists:
   ```sql
   USE master;
   GO
   ALTER DATABASE AirlineDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE AirlineDB;
   GO
   ```
   Then run the scripts in order

3. If no flights appear:
   - Verify create-database.sql ran successfully
   - Check add-flights.sql execution
   - Verify connection string in web.config

## Available Routes

### International Routes:
- Delhi ↔ Dubai
- Mumbai ↔ Singapore

### Domestic Premium Routes:
- Delhi ↔ Mumbai
- Bangalore ↔ Delhi

### Tourist Routes:
- Mumbai ↔ Goa
- Delhi ↔ Jaipur

### Budget Routes:
- Chennai ↔ Bangalore
- Kolkata ↔ Bhubaneswar

Each route includes:
- Multiple flight times
- Different price points
- Varied seat configurations