IF OBJECT_ID('Sales.MonthlyOrders','U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO
SELECT
	DATENAME(MONTH, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)


