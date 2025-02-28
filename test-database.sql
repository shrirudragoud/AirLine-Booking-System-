-- Database Testing Script
USE AirlineDB;
GO

-- 1. Verify Tables Exist
PRINT 'Checking tables...'
IF OBJECT_ID('Flights', 'U') IS NOT NULL 
    PRINT '✓ Flights table exists'
ELSE 
    PRINT '× Flights table missing';

IF OBJECT_ID('FlightRoutes', 'U') IS NOT NULL 
    PRINT '✓ FlightRoutes table exists'
ELSE 
    PRINT '× FlightRoutes table missing';

IF OBJECT_ID('Seats', 'U') IS NOT NULL 
    PRINT '✓ Seats table exists'
ELSE 
    PRINT '× Seats table missing';

-- 2. Check Data
PRINT CHAR(13) + 'Checking data counts...';
SELECT 
    (SELECT COUNT(*) FROM Flights) as FlightCount,
    (SELECT COUNT(*) FROM FlightRoutes) as RouteCount,
    (SELECT COUNT(*) FROM Seats) as SeatCount;

-- 3. Check Routes
PRINT CHAR(13) + 'Checking routes...';
SELECT DISTINCT Origin + ' → ' + Destination as Route,
       COUNT(*) as FlightCount,
       MIN(BasePrice) as MinPrice,
       MAX(BasePrice) as MaxPrice
FROM Flights
GROUP BY Origin, Destination
ORDER BY Origin, Destination;

-- 4. Check Seat Availability
PRINT CHAR(13) + 'Checking seat availability...';
SELECT f.FlightNumber,
       f.Origin,
       f.Destination,
       f.DepartureTime,
       COUNT(s.SeatID) as TotalSeats,
       SUM(CASE WHEN s.IsAvailable = 1 THEN 1 ELSE 0 END) as AvailableSeats
FROM Flights f
LEFT JOIN Seats s ON f.FlightID = s.FlightID
GROUP BY f.FlightNumber, f.Origin, f.Destination, f.DepartureTime
ORDER BY f.DepartureTime;

-- 5. Test Sample Queries
PRINT CHAR(13) + 'Testing sample queries...';

-- Test Query 1: Find flights from Delhi
PRINT CHAR(13) + 'Flights from Delhi:';
SELECT TOP 5 FlightNumber, Destination, FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') as Departure
FROM Flights 
WHERE Origin = 'Delhi'
AND DepartureTime > GETDATE();

-- Test Query 2: Check connecting flights
PRINT CHAR(13) + 'Connecting flights:';
SELECT r.Origin, r.ConnectionCity, r.Destination, r.BasePrice
FROM FlightRoutes r
WHERE r.IsDirectRoute = 0;

-- 6. Price Range Analysis
PRINT CHAR(13) + 'Price analysis:';
SELECT 
    'Domestic' as RouteType,
    MIN(BasePrice) as MinPrice,
    MAX(BasePrice) as MaxPrice,
    AVG(BasePrice) as AvgPrice,
    COUNT(*) as FlightCount
FROM Flights
WHERE Origin IN ('Delhi', 'Mumbai', 'Bangalore', 'Chennai')
  AND Destination IN ('Delhi', 'Mumbai', 'Bangalore', 'Chennai')
UNION ALL
SELECT 
    'International',
    MIN(BasePrice),
    MAX(BasePrice),
    AVG(BasePrice),
    COUNT(*)
FROM Flights
WHERE Origin IN ('Dubai', 'Singapore')
   OR Destination IN ('Dubai', 'Singapore');

-- 7. Data Integrity Check
PRINT CHAR(13) + 'Checking data integrity...';
SELECT 'Orphaned Seats' as Issue, COUNT(*) as Count
FROM Seats s
LEFT JOIN Flights f ON s.FlightID = f.FlightID
WHERE f.FlightID IS NULL
UNION ALL
SELECT 'Invalid Routes', COUNT(*)
FROM Flights
WHERE Origin = Destination
UNION ALL
SELECT 'Invalid Prices', COUNT(*)
FROM Flights
WHERE BasePrice <= 0;

GO

PRINT CHAR(13) + 'Database testing complete.'
PRINT 'If you see no data or errors above, run update-routes.sql again.'