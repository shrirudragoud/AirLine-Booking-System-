-- Reset and populate flight data
USE AirlineDB;
GO

-- First clean existing data
DELETE FROM Seats;
DELETE FROM Flights;
GO

-- Add fresh test flights with future dates
INSERT INTO Flights (FlightNumber, FlightName, Origin, Destination, DepartureTime, ArrivalTime, Capacity, BasePrice)
VALUES 
-- Next 7 days flights
('AI101', 'Air India', 'Delhi', 'Mumbai', DATEADD(hour, 25, GETDATE()), DATEADD(hour, 27, GETDATE()), 150, 5999.00),
('AI102', 'Air India', 'Mumbai', 'Delhi', DATEADD(hour, 28, GETDATE()), DATEADD(hour, 30, GETDATE()), 150, 6299.00),
('JA201', 'Jet Airways', 'Bangalore', 'Delhi', DATEADD(hour, 49, GETDATE()), DATEADD(hour, 52, GETDATE()), 180, 7499.00),
('JA202', 'Jet Airways', 'Delhi', 'Bangalore', DATEADD(hour, 53, GETDATE()), DATEADD(hour, 56, GETDATE()), 180, 7699.00),
('AI201', 'Air India', 'Chennai', 'Mumbai', DATEADD(hour, 73, GETDATE()), DATEADD(hour, 75, GETDATE()), 120, 4999.00),
('AI202', 'Air India', 'Mumbai', 'Chennai', DATEADD(hour, 76, GETDATE()), DATEADD(hour, 78, GETDATE()), 120, 5299.00);

-- Add seats for all flights
INSERT INTO Seats (FlightID, SeatNumber, IsAvailable)
SELECT 
    f.FlightID,
    CHAR(65 + ((number-1)/6)) + CAST(((number-1)%6) + 1 AS VARCHAR),
    1
FROM Flights f
CROSS JOIN master..spt_values 
WHERE type = 'P' AND number BETWEEN 1 AND (
    SELECT Capacity FROM Flights WHERE FlightID = f.FlightID
);
GO

-- Verify data
PRINT 'Verifying flight data...';
SELECT 'Total Flights' = COUNT(*) FROM Flights;
SELECT 'Total Seats' = COUNT(*) FROM Seats;
SELECT 'Routes' = COUNT(DISTINCT Origin + '-' + Destination) FROM Flights;

-- Show sample flight data
PRINT 'Sample flights:';
SELECT 
    FlightNumber,
    FlightName,
    Origin,
    Destination,
    FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') as Departure,
    FORMAT(ArrivalTime, 'MMM dd, yyyy hh:mm tt') as Arrival,
    BasePrice,
    (SELECT COUNT(*) FROM Seats s WHERE s.FlightID = f.FlightID) as TotalSeats
FROM Flights f
ORDER BY DepartureTime;

PRINT 'Setup complete. Check the flight schedule page now.';