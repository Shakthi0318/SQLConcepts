 --- Subquery Type
-- Result Category -- Scalar SubQuery return single value example

SELECT
AVG(Sales)
FROM Sales.Orders

-- Row SubQuery

SELECT
CustomerID
FROM Sales.Orders   -- Difference here we get two columns one is related to table the other one is bydefault

-- Table SubQuery

SELECT * FROM Sales.Orders -- Returns full table or we can specify the columns to return

-- SubQuery in FROM Clause

-- Find the products that have a price higher than the avg price of all products

SELECT * FROM Sales.Products

SELECT*
FROM
(SELECT
ProductID, Price,
AVG(Price) OVER() AvgPrice
FROM Sales.Products
GROUP BY ProductID, Price) t
WHERE price > AvgPrice

-- Rank Customers based on their total amount sales

SELECT*,
RANK() OVER(ORDER BY TotalSales DESC) rn
FROM (SELECT
CustomerID,
SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY CustomerID)t

-- SELECT Clause SubQuery  * Rule: Only scalar subqueries are allowed
--- Show the products IDs, names, prices and total number of orders


SELECT
ProductID, Product, Price,
(SELECT COUNT(*) TotalOrders FROM Sales.Orders)t
FROM Sales.Products


-- SubQuery in JOINS
-- Used to prepare the data (filtering or aggregation ) before joining it with other tables

-- Show all customers details and find the total orders from each customers

SELECT
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
SELECT
CustomerID,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

--- WHERE clause SubQuery 
-- Comparision and Logical  (RULE: Ony Scalar subqueries are allowed)

--- Used for complex filtering logic and makes query more flexible and dynamic

-- Find the products that have a price higher than the avg price of all the products

SELECT
* FROM Sales.Products
WHERE Price > (SELECT AVG(Price) AvgPric FROM Sales.Products)

-- IN -- Checks whether a value matches any value from a list

-- Show the details of orders made by customers in Germany

SELECT *
FROM Sales.Orders
WHERE OrderID IN (SELECT CustomerID FROM Sales.Customers Where Country = 'GERMANY')

-- Same question with NOT IN Germany

SELECT
* FROM Sales.Orders
WHERE CustomerID NOT IN(SELECT CustomerID FROM Sales.Customers WHERE Country = 'GERMANY')

-- ANY Operator -- checks if a value matches ANY value within a list
-- used to check if a value is true for ATLEAST one of the values in a list

--- Find female employees whose salaries are greater than the salaries of any male employees

SELECT 
EmployeeID, FirstName
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')


-- ALL Operator checks if a value matches all values within a list
-- Find female employees whose salaries are greater than salaries of all male employees

SELECT
EmployeeID, FirstName
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ALL(SELECT Salary FROM Sales.Employees WHERE Gender='M')

-- Show all the Customers details and find the total orders of each customers

SELECT
*,(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID=c.CustomerID) totalSales
FROM Sales.Customers c

SELECT COUNT(*) FROM Sales.Orders

--- Show the details of orders made by customers in germany

SELECT
* FROM Sales.Orders o
	WHERE EXISTS (SELECT
	1 FROM Sales.Customers c
	WHERE Country = 'GERMANY' AND o.CustomerID = c.CustomerID);

-- Show the details of orders not made by customers in germany

SELECT	
	* FROM Sales.Orders o
	WHERE NOT EXISTS (SELECT
	1 FROM Sales.Customers c
	WHERE Country = 'GERMANY' AND o.CustomerID = c.CustomerID);