SELECT * 
INTO Sales.DBCustomers
FROM Sales.Customers

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID)

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

-- Composite index -- you need to order the columns as per the query
CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers(Country, Score)