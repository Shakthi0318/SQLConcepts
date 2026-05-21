-- Find the running total of sales of each month



CREATE VIEW Sales.V_Monthly_Summary AS
(
SELECT 
	DATETRUNC(MONTH, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantites
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, OrderDate) 
)