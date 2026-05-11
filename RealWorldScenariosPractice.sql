-- Task -- Total revenue

WITH CTE Total_Reve AS(
SELECT
	CustomerID,
	SUM(Sales) TotalRevenue
	FROM Sales.Orders
GROUP BY CustomerID)
