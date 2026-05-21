-- Show top 2 Orders per customer along with running total of sales
-- Tips( ranking is by sales, running total by time(date or month)

SELECT
rn, runningTotal FROM (
SELECT
	CustomerID, Sales,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) rn,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER  BY OrderDate) AS runningTotal
FROM Sales.Orders)t
WHERE rn<=2

-- Find employees whose latest handled order is their highest order
-- Question can split into two -- latest and Highest
-- latest order --> Based on OrderDate , Highest Order ---> Based on Sales DESC

SELECT * FROM Sales.Employees;
SELECT * FROM Sales.Orders;

SELECT
EmployeeID, FullName, OrderID, Sales
FROM
(SELECT
	e.EmployeeID,e.FirstName+' '+e.LastName AS FullName,o.CustomerID, o.OrderID,o.Sales,
	o.OrderDate,
	ROW_NUMBER() OVER(PARTITION BY e.EmployeeID ORDER BY o.OrderDate DESC) AS LatestOrder,
	ROW_NUMBER() OVER(PARTITION BY e.EmployeeID ORDER BY o.Sales DESC) AS HighestOrder
FROM Sales.Employees e
LEFT JOIN Sales.Orders o
ON o.SalesPersonID = e.EmployeeID)t
WHERE LatestOrder = 1 AND HighestOrder = 1


-- Show moving average of last 3 orders only for customer whose sales are increasing
-- Tips (Last orders always mean sequence time - need to use FRAME clause)

SELECT
CustomerID, Sales, MovingAvg
FROM (SELECT
	CustomerID, Sales,
	LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) preSales,
	AVG(Sales) OVER(PARTITION BY CustomerID ORDER BY Sales DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) MovingAvg
FROM Sales.Orders)t
WHERE Sales > preSales

-- Identify customers who placed consecutive orders where each order value increased

SELECT
CustomerID, conOrder, Sales
FROM (SELECT
	CustomerID, OrderDate, Sales,
	LAG(Sales, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) conOrder
FROM Sales.Orders)t
WHERE Sales > conOrder


-- Find the products whose current sale is lower than previous sale but still above the product average

SELECT
	p.ProductID, p.Product, o.Sales, o.Quantity,
	LAG(o.Sales) OVER(PARTITION BY p.ProductID ORDER BY o.OrderDate) preSales,
	AVG(o.Quantity) OVER(PARTITION BY p.ProductID ORDER BY o.Quantity) avgSales
FROM Sales.Products p
LEFT JOIN Sales.Orders o 
ON o.ProductID = p.ProductID
