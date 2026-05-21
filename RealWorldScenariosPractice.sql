-- Task -- Total revenue

WITH Total_Reve AS(
SELECT
	CustomerID,
	SUM(Sales) TotalRevenue
	FROM Sales.Orders
GROUP BY CustomerID)

SELECT TotalRevenue FROM Total_Reve

SELECT 
DATE1 AS date


