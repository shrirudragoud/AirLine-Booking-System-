# Running ASP.NET Web Forms Project with LocalDB

## Important Note
This project is an ASP.NET Web Forms application which is not directly supported in Visual Studio Code. You'll need Visual Studio to run this project.

## Required Software
1. Visual Studio (recommended over VS Code)
   - Download: https://visualstudio.microsoft.com/downloads/
   - Choose Community Edition if you don't have a license
   - During installation, make sure to select:
     * "ASP.NET and web development" workload
     * SQL Server Express LocalDB (usually included with Visual Studio)

## Steps to Run the Project

1. Install Visual Studio with ASP.NET Web Forms support

2. Create App_Data folder:
   - In the GUI folder, create a new folder named "App_Data"
   - This is where the LocalDB database file (AirlineDB.mdf) will be created automatically

3. Open the Project:
   - Open Visual Studio
   - Go to File -> Open -> Web Site
   - Navigate to your project folder and select the GUI folder
   - Click Open

4. Set up Database Schema:
   - Open Server Explorer in Visual Studio (View -> Server Explorer)
   - Expand Data Connections
   - Right-click on Data Connections -> Add Connection
   - Data source: Microsoft SQL Server (SqlClient)
   - Server name: (LocalDB)\MSSQLLocalDB
   - Select "Attach a database file"
   - Click Browse and navigate to the GUI\App_Data folder
   - Give a name like "AirlineDB.mdf"
   - Click OK to create the database

5. Create Database Tables:
   - In Server Explorer, right-click on the database
   - Select "New Query"
   - Copy and paste this SQL script:

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

6. Run the Project:
   - Press F5 or click the "Start Debugging" button in Visual Studio
   - The project should open in your default web browser
   - Navigate to home.aspx to start using the application
   - Use username: 'admin' and password: 'admin123' to log in

## Troubleshooting
1. If the database file isn't created:
   - Make sure the App_Data folder exists
   - Verify you have write permissions to the folder
   - Try running Visual Studio as administrator

2. If you get compilation errors:
   - Ensure .NET Framework 3.5 is installed
   - Clean and rebuild the solution
   - Check for missing dependencies

3. If pages don't load:
   - Verify IIS Express is running properly
   - Enable ASP.NET in Windows Features
   - Check the application pool settings

4. Database Connection Issues:
   - Verify LocalDB is installed (comes with Visual Studio)
   - Check the connection string in web.config points to the correct .mdf file
   - Make sure the database file exists in the App_Data folder