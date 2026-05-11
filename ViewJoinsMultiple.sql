-- Provide a view that combines details from orders, products, customers and employees

--SELECT * FROM Sales.Orders
-- SELECT * FROM Sales.Customers

CREATE VIEW Sales.OrderDetails AS 
(SELECT
o.OrderID, o.OrderDate, o.Sales, o.Quantity,
p.Product, p.Category, 
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
e.Department
FROM Sales.Orders o 
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID)
SELECT * FROM Sales.OrderDetails

--- Provide a view for the EU sales team that combines details from all tables and exclude data related to the USA

CREATE VIEW Sales.OrderDetails_EU AS 
(SELECT
o.OrderID, o.OrderDate, o.Sales, o.Quantity,
p.Product, p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
e.Department
FROM Sales.Orders o 
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID
WHERE c.Country != 'USA' )

SELECT * FROM Sales.OrderDetails_EU

