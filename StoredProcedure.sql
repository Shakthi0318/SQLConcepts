-- Step1: Write a query
-- For US customers Find the total number of customer and the average score

SELECT
	CustomerID, 
	COUNT(*) TotalSales,
	AVG(Sales) AvgSales
FROM Sales.Orders
GROUP BY CustomerID

-- Step2: Turning the query into a stored procedure

CREATE PROCEDURE GetSummaryDetails AS
BEGIN
	SELECT
	CustomerID, 
	COUNT(*) TotalScore,
	AVG(Score) AvgScore
FROM Sales.Customers
GROUP BY CustomerID
END

EXEC GetSummaryDetails

-- Define the parameter for stored procedure

ALTER PROCEDURE GetSummaryOnCountry @Country NVARCHAR(50) = 'USA'
AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;
-- Prepare and cleanUp data

IF EXISTS(SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN
	UPDATE Sales.Customers
	SET Score = 0
	WHERE Score IS NULL AND Country = @Country;
END

ELSE
BEGIN
	PRINT('NO NULL VALUES FOUND')
END;
-- Generating the reports
SELECT 
	@TotalCustomers = COUNT(*) ,
	@AvgScore = AVG(Score)
FROM Sales.Customers
WHERE Country = @Country;

PRINT 'Total Customer From' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score From '+ @Country + ':'+ CAST(@AvgScore AS NVARCHAR);

SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END
GO
--Execute stored procedure with dynamic parameter

EXEC GetSummaryOnCountry @Country = 'USA'
EXEC GetSummaryOnCountry @Country ='GERMANY'

-- Find the total number of Orders and Sales

SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
