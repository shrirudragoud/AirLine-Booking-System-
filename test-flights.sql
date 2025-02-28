-- First, verify database and tables exist
USE master;
GO
IF DB_ID('AirlineDB') IS NULL
BEGIN
    RAISERROR ('AirlineDB database does not exist. Please run create-database.sql first.', 16, 1);
    RETURN;
END
GO

USE AirlineDB;
GO

-- Check if tables exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Flights')
BEGIN
    RAISERROR ('Flights table does not exist. Please run create-database.sql first.', 16, 1);
    RETURN;
END
GO

-- Check if there are any flights
SELECT COUNT(*) as TotalFlights FROM Flights;

-- Display sample flights
SELECT TOP 10 
    FlightID,
    FlightNumber,
    FlightName,
    Origin,
    Destination,
    FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') as DepartureTime,
    FORMAT(ArrivalTime, 'MMM dd, yyyy hh:mm tt') as ArrivalTime,
    BasePrice,
    Capacity
FROM Flights
ORDER BY DepartureTime;

-- Check routes
SELECT 
    Origin,
    Destination,
    COUNT(*) as FlightCount,
    MIN(BasePrice) as MinPrice,
    MAX(BasePrice) as MaxPrice
FROM Flights
GROUP BY Origin, Destination
ORDER BY Origin, Destination;

-- Check seats
SELECT 
    f.FlightNumber,
    f.Origin,
    f.Destination,
    COUNT(s.SeatID) as TotalSeats,
    SUM(CASE WHEN s.IsAvailable = 1 THEN 1 ELSE 0 END) as AvailableSeats
FROM Flights f
LEFT JOIN Seats s ON f.FlightID = s.FlightID
GROUP BY f.FlightNumber, f.Origin, f.Destination;

-- Insert sample flights if none exist
IF NOT EXISTS (SELECT TOP 1 1 FROM Flights)
BEGIN
    INSERT INTO Flights (FlightNumber, FlightName, Origin, Destination, DepartureTime, ArrivalTime, Capacity, BasePrice)
    VALUES 
    ('AI101', 'Air India', 'Delhi', 'Mumbai', DATEADD(day, 1, GETDATE()), DATEADD(day, 1, DATEADD(hour, 2, GETDATE())), 150, 5999.00),
    ('AI102', 'Air India', 'Mumbai', 'Delhi', DATEADD(day, 1, DATEADD(hour, 4, GETDATE())), DATEADD(day, 1, DATEADD(hour, 6, GETDATE())), 150, 6299.00),
    ('JA201', 'Jet Airways', 'Bangalore', 'Delhi', DATEADD(day, 2, GETDATE()), DATEADD(day, 2, DATEADD(hour, 3, GETDATE())), 180, 7499.00),
    ('JA202', 'Jet Airways', 'Delhi', 'Bangalore', DATEADD(day, 2, DATEADD(hour, 5, GETDATE())), DATEADD(day, 2, DATEADD(hour, 8, GETDATE())), 180, 7699.00);

    -- Add seats for these flights
    INSERT INTO Seats (FlightID, SeatNumber, IsAvailable)
    SELECT 
        f.FlightID,
        CHAR(65 + ((number-1)/6)) + CAST(((number-1)%6) + 1 AS VARCHAR),
        1
    FROM Flights f
    CROSS JOIN master..spt_values 
    WHERE type = 'P' AND number BETWEEN 1 AND 180;

    PRINT 'Sample flights and seats added successfully.';
END

-- Verify data again
SELECT 'Total Flights' = COUNT(*) FROM Flights;
SELECT 'Total Seats' = COUNT(*) FROM Seats;
SELECT 'Available Seats' = COUNT(*) FROM Seats WHERE IsAvailable = 1;