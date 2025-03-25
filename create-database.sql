-- Drop database if it exists and create new
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'AirlineDB')
BEGIN
    ALTER DATABASE AirlineDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AirlineDB;
END
GO

CREATE DATABASE AirlineDB;
GO

USE AirlineDB;
GO

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
    FlightName VARCHAR(50) NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Capacity INT NOT NULL,
    BasePrice DECIMAL(10,2) NOT NULL
);

-- Create directory for destination images
EXEC xp_cmdshell 'mkdir "c:\Users\HP\OneDrive\Documents\3dG\Airline-Reservation-System-master\GUI\Images\destinations"'

-- Insert sample flight data with prices
INSERT INTO Flights (FlightNumber, FlightName, Origin, Destination, DepartureTime, ArrivalTime, Capacity, BasePrice)
VALUES
('AI101', 'Air India', 'Delhi', 'Mumbai', '2024-03-01 10:00', '2024-03-01 12:00', 100, 5999.00),
('AI102', 'Air India', 'Mumbai', 'Delhi', '2024-03-01 14:00', '2024-03-01 16:00', 100, 6299.00),
('JA201', 'Jet Airways', 'Delhi', 'Bangalore', '2024-03-02 09:00', '2024-03-02 11:30', 80, 7499.00),
('JA202', 'Jet Airways', 'Bangalore', 'Delhi', '2024-03-02 13:00', '2024-03-02 15:30', 80, 7699.00),
('AI103', 'Air India', 'Mumbai', 'Goa', '2024-03-03 08:00', '2024-03-03 09:30', 90, 4999.00),
('JA203', 'Jet Airways', 'Goa', 'Mumbai', '2024-03-03 11:00', '2024-03-03 12:30', 90, 5299.00);

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
    PassengerName VARCHAR(100) NOT NULL,
    FlightId VARCHAR(20) NOT NULL,
    FlightName VARCHAR(50) NOT NULL,
    FromStation VARCHAR(50) NOT NULL,
    ToStation VARCHAR(50) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    TravelDateTime VARCHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE()
);

-- Insert admin user
INSERT INTO Users (Username, Password) VALUES ('admin', 'admin123');

-- Insert sample flights
INSERT INTO Flights (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime, Capacity)
VALUES 
('FL001', 'Delhi', 'Mumbai', '2024-03-01 10:00', '2024-03-01 12:00', 100),
('FL002', 'Mumbai', 'Delhi', '2024-03-01 14:00', '2024-03-01 16:00', 100),
('FL003', 'Delhi', 'Agra', '2024-03-02 09:00', '2024-03-02 10:00', 80),
('FL004', 'Agra', 'Mumbai', '2024-03-02 12:00', '2024-03-02 14:00', 80);

-- Insert sample seats for each flight
DECLARE @FlightID int = 1;
WHILE @FlightID <= 4
BEGIN
    DECLARE @SeatNum int = 1;
    WHILE @SeatNum <= 20
    BEGIN
        INSERT INTO Seats (FlightID, SeatNumber, IsAvailable)
        VALUES (@FlightID, 'A' + CAST(@SeatNum as varchar), 1);
        SET @SeatNum = @SeatNum + 1;
    END
    SET @FlightID = @FlightID + 1;
END

-- Create ContactMessages table
CREATE TABLE ContactMessages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Subject VARCHAR(50) NOT NULL,
    Message TEXT NOT NULL,
    SubmittedOn DATETIME DEFAULT GETDATE()
);

-- Verify data
SELECT 'Users Count: ' + CAST(COUNT(*) as varchar) FROM Users;
SELECT 'Flights Count: ' + CAST(COUNT(*) as varchar) FROM Flights;
SELECT 'Seats Count: ' + CAST(COUNT(*) as varchar) FROM Seats;
GO