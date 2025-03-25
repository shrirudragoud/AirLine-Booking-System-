# Database Setup Guide in Visual Studio

## Step by Step Instructions with Screenshots

1. **Open Server Explorer**
   - In Visual Studio, go to the top menu
   - Click on "View"
   - Select "Server Explorer"
   - The Server Explorer window should appear (usually on the left side)

2. **Create Database Connection**
   - In Server Explorer, right-click on "Data Connections"
   - Select "Add Connection"
   - A "Add Connection" dialog will appear
   - Under "Data source:" select "Microsoft SQL Server (SqlClient)"
   - Click "Continue"

3. **Configure Database**
   - In the "Server name:" field, enter: `(LocalDB)\MSSQLLocalDB`
   - Select "Attach a database file"
   - Click the "Browse" button
   - Navigate to your project's GUI\App_Data folder
   - Type "AirlineDB.mdf" as the filename
   - Click "OK" to create the database

4. **Run SQL Scripts**
   - In Server Explorer, expand "Data Connections"
   - You should see "AirlineDB.mdf"
   - Right-click on "AirlineDB.mdf"
   - Select "New Query"
   - A new SQL query window will open
   - Copy and paste the following SQL script:

```sql
-- Create Users table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL
);

-- Create Flights table
CREATE TABLE Flights (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    FlightNumber VARCHAR(20) NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL
);

-- Create Seats table
CREATE TABLE Seats (
    SeatID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT,
    SeatNumber VARCHAR(10) NOT NULL,
    IsAvailable BIT DEFAULT 1,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

-- Create Bookings table
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT,
    UserID INT,
    SeatID INT,
    BookingDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID)
);

-- Insert sample data
INSERT INTO Users (Username, Password) VALUES ('admin', 'admin123');

INSERT INTO Flights (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime)
VALUES 
('FL001', 'New York', 'London', '2024-03-01 10:00', '2024-03-01 22:00'),
('FL002', 'London', 'Paris', '2024-03-02 09:00', '2024-03-02 11:00');

-- Insert seats for each flight
INSERT INTO Seats (FlightID, SeatNumber)
SELECT 1, 'A' + CAST(number AS VARCHAR) FROM
(VALUES (1),(2),(3),(4),(5)) AS numbers(number);

INSERT INTO Seats (FlightID, SeatNumber)
SELECT 2, 'B' + CAST(number AS VARCHAR) FROM
(VALUES (1),(2),(3),(4),(5)) AS numbers(number);
```

5. **Execute the Script**
   - With the SQL script pasted in the query window
   - Click the green "Execute" button (or press F5)
   - You should see "Command(s) completed successfully" in the output

6. **Verify Setup**
   - In Server Explorer, expand "AirlineDB.mdf"
   - Expand "Tables"
   - You should see:
     * dbo.Users
     * dbo.Flights
     * dbo.Seats
     * dbo.Bookings
   - Right-click on dbo.Users and select "Show Table Data"
   - You should see the admin user you created

7. **Test the Database**
   - Now you can run the application
   - Press F5 to start debugging
   - Go to the login page
   - Use these credentials:
     * Username: admin
     * Password: admin123

## Troubleshooting

If you get an error saying "Cannot create file ... App_Data\AirlineDB.mdf":
1. Close Visual Studio
2. Delete the AirlineDB.mdf file if it exists in App_Data folder
3. Run Visual Studio as Administrator
4. Try the steps again

If you get a "Login failed" error:
1. Make sure you're using `(LocalDB)\MSSQLLocalDB` exactly as written
2. Verify that SQL Server LocalDB is installed (it comes with Visual Studio)
3. Open Command Prompt as Administrator and run: `sqllocaldb start MSSQLLocalDB`