USE AirlineDB;
GO

-- Create FlightRoutes table to store route information
CREATE TABLE FlightRoutes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    IsDirectRoute BIT DEFAULT 1,
    ConnectionCity VARCHAR(50) NULL,
    ApproxDuration INT NOT NULL, -- Duration in minutes
    BasePrice DECIMAL(10,2) NOT NULL,
    RouteType VARCHAR(20) NOT NULL -- 'Domestic', 'International'
);
GO

-- Insert route definitions
INSERT INTO FlightRoutes (Origin, Destination, IsDirectRoute, ConnectionCity, ApproxDuration, BasePrice, RouteType)
VALUES
-- Direct Domestic Routes
('Delhi', 'Mumbai', 1, NULL, 130, 5999.00, 'Domestic'),
('Mumbai', 'Delhi', 1, NULL, 130, 6299.00, 'Domestic'),
('Bangalore', 'Delhi', 1, NULL, 165, 7499.00, 'Domestic'),
('Delhi', 'Bangalore', 1, NULL, 165, 7699.00, 'Domestic'),
('Mumbai', 'Goa', 1, NULL, 60, 3999.00, 'Domestic'),
('Goa', 'Mumbai', 1, NULL, 60, 4299.00, 'Domestic'),
('Chennai', 'Bangalore', 1, NULL, 45, 2999.00, 'Domestic'),
('Bangalore', 'Chennai', 1, NULL, 45, 3299.00, 'Domestic'),

-- Direct International Routes
('Delhi', 'Dubai', 1, NULL, 210, 24999.00, 'International'),
('Dubai', 'Delhi', 1, NULL, 210, 26999.00, 'International'),
('Mumbai', 'Singapore', 1, NULL, 300, 32999.00, 'International'),
('Singapore', 'Mumbai', 1, NULL, 300, 34999.00, 'International'),

-- Connecting Domestic Routes
('Chennai', 'Delhi', 0, 'Mumbai', 240, 9999.00, 'Domestic'),
('Goa', 'Delhi', 0, 'Mumbai', 210, 8999.00, 'Domestic'),
('Kolkata', 'Mumbai', 0, 'Delhi', 270, 8499.00, 'Domestic'),
('Hyderabad', 'Delhi', 0, 'Mumbai', 240, 8999.00, 'Domestic'),

-- Connecting International Routes
('Bangalore', 'Dubai', 0, 'Delhi', 330, 29999.00, 'International'),
('Chennai', 'Singapore', 0, 'Mumbai', 420, 36999.00, 'International'),
('Hyderabad', 'Dubai', 0, 'Mumbai', 360, 31999.00, 'International'),
('Kolkata', 'Singapore', 0, 'Mumbai', 450, 38999.00, 'International');

-- Add new flights based on routes
INSERT INTO Flights (FlightNumber, FlightName, Origin, Destination, DepartureTime, ArrivalTime, Capacity, BasePrice)
SELECT 
    'AI' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY Origin) + 100 AS VARCHAR), 3),
    CASE WHEN BasePrice > 20000 THEN 'Air India International' ELSE 'Air India' END,
    Origin,
    CASE WHEN IsDirectRoute = 0 THEN ConnectionCity ELSE Destination END,
    DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY Origin) % 7), '2024-03-01 06:00'),
    DATEADD(MINUTE, ApproxDuration, DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY Origin) % 7), '2024-03-01 06:00')),
    CASE 
        WHEN RouteType = 'International' THEN 200
        ELSE 150
    END,
    BasePrice
FROM FlightRoutes
WHERE IsDirectRoute = 1 OR ConnectionCity IS NOT NULL;

-- For connecting flights, add the second leg
INSERT INTO Flights (FlightNumber, FlightName, Origin, Destination, DepartureTime, ArrivalTime, Capacity, BasePrice)
SELECT 
    'AI' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY Origin) + 200 AS VARCHAR), 3),
    CASE WHEN BasePrice > 20000 THEN 'Air India International' ELSE 'Air India' END,
    ConnectionCity,
    Destination,
    DATEADD(HOUR, 2, DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY Origin) % 7), '2024-03-01 08:00')),
    DATEADD(MINUTE, ApproxDuration, DATEADD(HOUR, 2, DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY Origin) % 7), '2024-03-01 08:00'))),
    CASE 
        WHEN RouteType = 'International' THEN 200
        ELSE 150
    END,
    BasePrice * 0.6
FROM FlightRoutes
WHERE IsDirectRoute = 0;

-- Add seats for all flights
DECLARE @FlightID int = (SELECT MIN(FlightID) FROM Flights)
WHILE @FlightID <= (SELECT MAX(FlightID) FROM Flights)
BEGIN
    DECLARE @Capacity int = (SELECT Capacity FROM Flights WHERE FlightID = @FlightID)
    DECLARE @SeatNum int = 1
    
    WHILE @SeatNum <= @Capacity
    BEGIN
        INSERT INTO Seats (FlightID, SeatNumber, IsAvailable)
        VALUES (@FlightID, 
                CHAR(65 + (@SeatNum-1)/6) + CAST((@SeatNum-1)%6 + 1 AS VARCHAR),
                1)
        SET @SeatNum = @SeatNum + 1
    END
    
    SET @FlightID = @FlightID + 1
END

-- Show route statistics
SELECT 
    'Direct Routes: ' + CAST(COUNT(CASE WHEN IsDirectRoute = 1 THEN 1 END) AS VARCHAR) as DirectRoutes,
    'Connecting Routes: ' + CAST(COUNT(CASE WHEN IsDirectRoute = 0 THEN 1 END) AS VARCHAR) as ConnectingRoutes,
    'Domestic Routes: ' + CAST(COUNT(CASE WHEN RouteType = 'Domestic' THEN 1 END) AS VARCHAR) as DomesticRoutes,
    'International Routes: ' + CAST(COUNT(CASE WHEN RouteType = 'International' THEN 1 END) AS VARCHAR) as InternationalRoutes
FROM FlightRoutes;

-- Show price ranges
SELECT 
    RouteType,
    MIN(BasePrice) as MinPrice,
    MAX(BasePrice) as MaxPrice,
    COUNT(*) as RouteCount
FROM FlightRoutes
GROUP BY RouteType;