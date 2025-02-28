-- Verify database setup and routes
USE AirlineDB;
GO

-- Check database objects
SELECT 'Table Count' = COUNT(*) 
FROM sys.tables 
WHERE type = 'U';

-- Check Flights table
SELECT 'Flight Routes' = COUNT(*) 
FROM Flights;

-- Check FlightRoutes table
SELECT 'Route Types' = RouteType, 'Count' = COUNT(*)
FROM FlightRoutes
GROUP BY RouteType;

-- Check Seats
SELECT 'Total Seats' = COUNT(*) 
FROM Seats;

-- Sample route data
SELECT TOP 5
    f.FlightNumber,
    f.Origin,
    f.Destination,
    f.DepartureTime,
    f.BasePrice,
    (SELECT COUNT(*) FROM Seats s WHERE s.FlightID = f.FlightID AND s.IsAvailable = 1) as AvailableSeats
FROM Flights f
ORDER BY f.DepartureTime;

-- Check connecting routes
SELECT 
    r.Origin,
    r.ConnectionCity,
    r.Destination,
    r.ApproxDuration as 'Duration (minutes)',
    r.BasePrice
FROM FlightRoutes r
WHERE r.IsDirectRoute = 0;

-- Verify price ranges
SELECT 
    'Minimum Price' = MIN(BasePrice),
    'Maximum Price' = MAX(BasePrice),
    'Average Price' = AVG(BasePrice)
FROM Flights;

-- Check cities coverage
SELECT 
    'Origin Cities' = COUNT(DISTINCT Origin),
    'Destination Cities' = COUNT(DISTINCT Destination)
FROM Flights;

-- Test query for flight search
SELECT TOP 5 
    f.FlightNumber,
    f.Origin,
    f.Destination,
    FORMAT(f.DepartureTime, 'MMM dd, yyyy hh:mm tt') as DepartureTime,
    f.BasePrice,
    (SELECT COUNT(*) FROM Seats s WHERE s.FlightID = f.FlightID AND s.IsAvailable = 1) as AvailableSeats
FROM Flights f
WHERE 
    f.DepartureTime > GETDATE()
    AND f.Origin = 'Delhi'
ORDER BY f.DepartureTime;

GO

PRINT 'If you see results for all queries above, the database is properly configured.'
PRINT 'Make sure flight routes and seats are populated.'
PRINT 'Now run the application and test the flight search functionality.'