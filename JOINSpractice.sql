USE SalesDB

SELECT * 
FROM Sales.Customers;

SELECT *
FROM Sales.Orders;

SELECT 
c.FirstName, c.CustomerID, o.ProductID, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
ORDER BY c.FirstName DESC

SELECT
c.FirstName, c.CustomerID, o.ProductID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID

SELECT
c.FirstName, c.CustomerID, o.Sales
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID


SELECT 
c.Country, o.OrderID, o.ProductID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID

SELECT
c.FirstName, o.OrderID
FROM Sales.Customers AS c
JOIN Sales.Orders AS o
ON c.CustomerID =o.CustomerID
WHERE o.CustomerID > 1


SELECT 
c.FirstName, c.LastName, c.CustomerID,
o.OrderID FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID

SELECT 
c.FirstName, c.CustomerID, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL


SELECT
c.FirstName, c.CustomerID, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NOT NULL

SELECT
c.FirstName, c.LastName, c.CustomerID, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID

SELECT 
c.FirstName, c.CustomerID, o.OrderID
FROM Sales.Customers AS c
RIGHT JOIN Sales.Orders AS o
ON c.CustomerID = o.OrderID

SELECT *
FROM Sales.Customers

SELECT
c.FirstName, c.CustomerID,
SUM(c.Score) Totl
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.CustomerID

SELECT
c.FirstName, c.CustomerID,
AVG(c.Score)
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.CustomerID

SELECT *
FROM Sales.Customers;
SELECT *
FROM Sales.Orders;

SELECT c.CustomerID,c.FirstName, o.ProductID, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID

SELECT c.CustomerID, c.FirstName, o.ProductID, o.OrderID, c.Score
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE c.Score = (
SELECT MAX(Score) Highest
FROM Sales.Customers )

SELECT
c.CustomerID, c.Score, c.Country, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE Score = (
SELECT AVG(Score) FROM Sales.Customers)
