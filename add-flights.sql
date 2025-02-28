-- Switch to AirlineDB database
USE AirlineDB;
GO

-- Add more sample flights with varied routes and prices
INSERT INTO Flights (FlightNumber, FlightName, Origin, Destination, DepartureTime, ArrivalTime, Capacity, BasePrice)
VALUES 
-- International Routes
('AI301', 'Air India', 'Delhi', 'Dubai', '2024-03-01 01:30', '2024-03-01 04:00', 200, 24999.00),
('AI302', 'Air India', 'Dubai', 'Delhi', '2024-03-01 06:00', '2024-03-01 08:30', 200, 26999.00),
('JA501', 'Jet Airways', 'Mumbai', 'Singapore', '2024-03-02 23:00', '2024-03-03 07:00', 180, 32999.00),
('JA502', 'Jet Airways', 'Singapore', 'Mumbai', '2024-03-03 09:00', '2024-03-03 17:00', 180, 34999.00),

-- Domestic Premium Routes
('AI201', 'Air India', 'Delhi', 'Mumbai', '2024-03-01 06:00', '2024-03-01 08:00', 150, 7999.00),
('AI202', 'Air India', 'Mumbai', 'Delhi', '2024-03-01 09:30', '2024-03-01 11:30', 150, 8499.00),
('JA301', 'Jet Airways', 'Bangalore', 'Delhi', '2024-03-02 07:00', '2024-03-02 09:30', 120, 8999.00),
('JA302', 'Jet Airways', 'Delhi', 'Bangalore', '2024-03-02 11:00', '2024-03-02 13:30', 120, 9499.00),

-- Popular Tourist Routes
('AI401', 'Air India', 'Mumbai', 'Goa', '2024-03-03 08:00', '2024-03-03 09:15', 100, 4499.00),
('AI402', 'Air India', 'Goa', 'Mumbai', '2024-03-03 10:30', '2024-03-03 11:45', 100, 4999.00),
('JA401', 'Jet Airways', 'Delhi', 'Jaipur', '2024-03-04 09:00', '2024-03-04 10:00', 90, 3999.00),
('JA402', 'Jet Airways', 'Jaipur', 'Delhi', '2024-03-04 11:30', '2024-03-04 12:30', 90, 4299.00),

-- Budget Routes
('AI501', 'Air India', 'Chennai', 'Bangalore', '2024-03-05 07:00', '2024-03-05 08:00', 80, 2999.00),
('AI502', 'Air India', 'Bangalore', 'Chennai', '2024-03-05 09:30', '2024-03-05 10:30', 80, 3299.00),
('JA601', 'Jet Airways', 'Kolkata', 'Bhubaneswar', '2024-03-06 08:00', '2024-03-06 09:15', 70, 2799.00),
('JA602', 'Jet Airways', 'Bhubaneswar', 'Kolkata', '2024-03-06 10:30', '2024-03-06 11:45', 70, 2999.00);

-- Add seats for new flights
DECLARE @FlightID int = (SELECT MIN(FlightID) FROM Flights WHERE FlightNumber = 'AI301')
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

-- Display flight count and routes
SELECT 'Total Flights: ' + CAST(COUNT(*) as varchar) as FlightCount,
       'Total Routes: ' + CAST(COUNT(DISTINCT Origin + '-' + Destination) as varchar) as RouteCount,
       'Price Range: ₹' + CAST(MIN(BasePrice) as varchar) + ' - ₹' + CAST(MAX(BasePrice) as varchar) as PriceRange
FROM Flights;

-- Display all routes with prices
SELECT Origin, Destination, 
       MIN(BasePrice) as MinPrice, 
       MAX(BasePrice) as MaxPrice,
       COUNT(*) as FlightsCount
FROM Flights
GROUP BY Origin, Destination
ORDER BY Origin, Destination;