-- Create the database
CREATE DATABASE AirlineDB;
GO

-- Switch to the new database
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