
-- Show total number of orders 
-- per customers using window functions

SELECT
OrderID, 
CustomerID, 
Sales,
SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY Sales) TotalSals
FROM Sales.Orders

-- Highest Order per Customer

SELECT
OrderID, 
CustomerID, Sales,
MAX(Sales) OVER(PARTITION BY CustomerID ORDER BY Sales)
FROM Sales.Orders

--- Assign a Row number for each order per customer ordered by date
SELECT
OrderID, CustomerID,
Sales,
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) rn
FROM Sales.Orders

-- Show total number of order per customers using window functions

SELECT
OrderID, CustomerID,
Sales,
COUNT(Sales) OVER(PARTITION BY CustomerID ORDER BY Sales) total
FROM Sales.Orders

-- Assign a rank to orders based on Sales

SELECT * FROM Sales.Orders

SELECT
OrderID, CustomerID,
Sales,
DENSE_RANK() OVER(ORDER BY Sales) rn
FROM Sales.Orders

--- Assign a rank to orders based on sales(higher first)

SELECT
OrderID, Sales,
FIRST_VALUE(Sales) OVER (ORDER BY Sales DESC) highestVal
FROM Sales.Orders

---Calculate running total of order amount ordered by order_date.

SELECT
OrderID,
Sales,
SUM(Sales) OVER(ORDER BY Sales ) AS RunningTotal
FROM Sales.Orders

--Show each order with customer's average order value

SELECT
OrderID, CustomerID, Sales,
AVG(Sales) OVER(PARTITION BY CustomerID) avgsales
FROM Sales.Orders

-- Find difference between current order and previous order per customer

SELECT
OrderID, OrderDate CurrentDate,
LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderID) NextOrder
FROM Sales.Orders

-- Show first order amount per customer

SELECT
OrderID, CustomerID, Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate)
FROM Sales.Orders

-- OR

SELECT
OrderID, CustomerID,
Sales,
MAX(Sales) OVER(ORDER BY Sales)
FROM Sales.Orders

-- Show top 3 orders per customer based on sales

SELECT TOP 3 
OrderID, CustomerID, Sales
FROM Sales.Orders

SELECT
OrderID, CustomerID, Sales
FROM (SELECT
OrderID, CustomerID, Sales,
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) rn
FROM Sales.Orders) t
WHERE rn <=3

--Calculate moving average of last 3 orders per customer

SELECT
OrderID, CustomerID, Sales,
AVG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) avgSales
FROM Sales.Orders

-- Show each order along with previous order sales per customer

SELECT
OrderID, CustomerID, Sales,
LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) PrevSales
FROM Sales.Orders

-- Find difference between current and previous order sales per customer

SELECT
OrderID, OrderDate CurrentDate, CustomerID, Sales,
LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder
FROM Sales.Orders