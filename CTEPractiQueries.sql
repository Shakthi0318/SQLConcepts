 -- Find the total sales per customers - Standalone CTE's    [CTE1]

-- Find the last order date for each customer -- this is for multiple CTE's   [CTE2]

--  Rank customers based on total sales per customer -- Nested CTE's    [CTE3]

-- Segment customers based on their total sales -- Nested CTE's     [CTE4]

WITH CTE_Total_Sales AS
(
SELECT
	CustomerID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY CustomerID 
),
	CTE_Last_Order AS
(
	SELECT CustomerID,
	MAX(OrderDate) LastOrder
	FROM Sales.Orders
	GROUP BY CustomerID
),
	CTE_RANK AS(
	SELECT
	CustomerID, TotalSales,
	RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
	FROM CTE_Total_Sales
),
CTE_segment AS
(
	SELECT 
	CustomerID,
	CASE
		WHEN TotalSales > 100 THEN 'HIGH'
		WHEN TotalSales > 50 THEN 'Medium'
		ELSE 'low'
	END CustomerSegment
FROM CTE_Total_Sales
)
SELECT 
c.CustomerID, c.FirstName,ct.TotalSales, 
l.LastOrder, rn.CustomerRank, 
s.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales ct
ON ct.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order l
ON l.CustomerID = c.CustomerID 
LEFT JOIN CTE_RANK rn
ON rn.CustomerID = c.CustomerID
LEFT JOIN CTE_segment s
ON s.CustomerID = c.CustomerID

