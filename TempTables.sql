SELECT
* INTO #Orders
FROM Sales.Orders

SELECT * FROM #Orders

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'