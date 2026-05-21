USE SalesDB

---- Find the total sales for each product, additionally
-- provide details such as orderID and OrderDate

SELECT 
OrderID, OrderDate,
ProductID, SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY OrderID, OrderDate, ProductID

-- Same Question we are using window function

SELECT
	OrderID, OrderDate, ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

--Find the total sales across all orders
--- Additonally provide details such OrderID, OrderDate

SELECT
	OrderID, OrderDate,
	SUM(Sales) OVER() AS TotalSales
FROM Sales.Orders

--- Find the total sales for each prodcut
--- Additonally provide details such OrderID, OrderDate


SELECT
	OrderID, OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSales
FROM Sales.Orders

--- Rank each order based on their sales from highest to lowest
-- additionally provide details such orderID and OrderDate

SELECT
	OrderID, OrderDate,
	RANK() OVER (ORDER BY Sales DESC) AS SalesCou
FROM Sales.Orders

SELECT
	OrderID, OrderDate, ProductID,Sales, OrderStatus,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW 
	AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

SELECT
	OrderID, OrderDate, ProductID, Sales, OrderStatus,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)
FROM Sales.Orders



-- Rank the customers based on their total orders

SELECT
CustomerID,
SUM(Sales) TotalSales,
RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID


--- Aggregate Functions 
---- Find the total number of orders Additionally provide OrderID, OrderDate

SELECT OrderID, OrderDate,
COUNT (*) AS TotalOrder
FROM Sales.Orders
GROUP BY OrderID, OrderDate

-- OR

SELECT 
	OrderID, OrderDate,
	COUNT(*) OVER () TotalOrders
FROM Sales.Orders

-- For the above question adding (each customers order)

SELECT
	OrderID, OrderDate,
	COUNT(*) OVER(PARTITION BY CustomerID) OrderByCustomer
FROM Sales.Orders

--- Find the total number of customer
-- Additionally provide all customers details

SELECT *,
COUNT(*) OVER() TotalCustomers
FROM Sales.Customers

---- WINDOW aggregation USE CASES

--- Check whether the table 'Orders' contains any duplicate rows

SELECT
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Sales.Orders

SELECT *
FROM Sales.OrdersArchive

SELECT *
FROM (
SELECT
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive )t
WHERE CheckPk >1 

--- SUM Window Function
---- Find the total sales acorss all the orders and the total sales
-- for each product Addititonally provide details such as OrderID, and OrderDate

SELECT
OrderID, OrderDate,Sales, ProductID,
SUM(Sales) OVER() TotSales,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSales
FROM Sales.Orders

-- Find the percentage contribution of each product sales to the total sales

SELECT 
OrderID, ProductID, Sales,
SUM(Sales) OVER() TotalSales,
ROUND(CAST(Sales AS FLOAT)/SUM(Sales) OVER()  * 100, 2)PercentageTotal
FROM Sales.Orders

--- AVG WINDOW functions

-- FInd the avergae sales across all orders
-- and the average sales for each product additionally, provide details OrderID and Orderdate

SELECT
OrderID, ProductID,OrderDate,Sales,
AVG(COALESCE(Sales,0)) OVER() AvgSales,
AVG(COALESCE(Sales,0)) OVER(PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders

--- Find the avg score of the customers
-- Additionally, provide details such as CustomerID and LastName


SELECT
* FROM Sales.Customers

SELECT
CustomerID, FirstName, LastName,
AVG(COALESCE(Score, 0)) OVER() AvgScore,
AVG(COALESCE(Score,0)) OVER(PARTITION BY CustomerID) AvgScoreByCustomer
FROM Sales.Customers

---- Find all the orders where Sales are higher than average sales acorss all orders

SELECT *
FROM 
(SELECT 
OrderID, OrderDate, Sales,
AVG(Sales) OVER() AvgSales
FROM Sales.Orders
)t
WHERE Sales > AvgSales


-- Find the highest and lowest sales acorss all orders and the highest and lowest sales
-- for each product additonally provide details ORderID and ORderdate

SELECT
OrderID, OrderDate,ProductID,
MIN(COALESCE(Sales, 0)) OVER () MinimSales,
MIN(COALESCE(Sales,0)) OVER (PARTITION BY ProductID) MinSalesByProduct,
MAX(COALESCE(Sales, 0)) OVER () MaxSales,
MAX(COALESCE(Sales,0)) OVER (PARTITION BY ProductID) MaxSalesByProduct
FROM Sales.Orders


SELECT * FROM Sales.Employees
---- Show the employees who have the highest salary

SELECT *
FROM 
(SELECT
*,
MAX(Salary) OVER() MaxSalary,
MAX(Salary) OVER(PARTITION BY Department) MaxByDepartment
FROM Sales.Employees)t
WHERE Salary = MaxByDepartment

--- Find the deviation of each sales from the minimum and maximum sales amounts

SELECT
	OrderID, OrderDate, ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER() DeviationFromMin,
	MAX(Sales) OVER() - Sales
FROM Sales.Orders

--- Calculate the moving avg of sales for each product over time

SELECT * FROM Sales.Orders

SELECT
OrderID, ProductID, CustomerID, Sales,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS  UNBOUNDED PRECEDING) AvgSales
FROM Sales.Orders

--- Calculate moving average of sales for each product over time 
-- including only the next order

SELECT
OrderID, OrderDate, ProductID, 
Sales, 
AVG(Sales) OVER(PARTITION BY ProductID) AvgSales,
AVG(Sales) 
OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS 
BETWEEN CURRENT ROW AND 1 FOLLOWING) NextOrder
FROM Sales.Orders


--- WINDOW RANKING FUNCTIONS
--- Rank the orders based on their sales from highest to lowest

SELECT
OrderID, OrderDate,
Sales,
ROW_NUMBER() OVER(Order BY Sales DESC) RankNumber
FROM Sales.Orders

SELECT
OrderID, Sales,
RANK() OVER(Order BY Sales DESC) SalesRank
FROM Sales.Orders

SELECT
OrderID, Sales,
DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank
FROM Sales.Orders

--- USE Cases (TOP - N - Analysis)

-- Find the top highest sales for each product

SELECT *
FROM(
SELECT
	OrderID, ProductID, Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY ProductID DESC) HighestSalesByProduct
FROM Sales.Orders)t
WHERE HighestSalesByProduct = 1

-- Bottom N Analysis
-- Find the lowest 2 customers based on their total sales

SELECT *
FROM
(SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID)t
WHERE RankCustomers < 3

--- Generate unique IDs -- Assign unique IDs to the rows of the ordes archive table

SELECT * FROM Sales.OrdersArchive

SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqID,
*
FROM Sales.OrdersArchive

-- Remove duplicates
-- Identify duplicate rows in the table 'OrderArchive'
-- and return a clean result withtout any duplicates

SELECT * FROM
(SELECT
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
*
FROM Sales.OrdersArchive) t
WHERE rn = 1

-- NTILE functions and use cases ( Data Segment and Equalisi load processing)

SELECT
OrderID, Sales,
NTILE(1) OVER (ORDER BY Sales DESC) Bucket
FROM Sales.Orders

-- Segment all orders into 3 categories 
-- High, medium and low sales

SELECT
*,
CASE
	WHEN Buckets = 1 THEN 'HIGH'
	WHEN Buckets = 2 THEN 'MEDIUM'
	WHEN Buckets = 3 THEN 'LOW'
END SalesSegments FROM(
	SELECT
	 OrderID, Sales,
	 NTILE(3) OVER(ORDER BY Sales DESC) Buckets
 FROM Sales.Orders) t

-- Equalizing load as Data engineer
-- In order to export the data divide the orders into 2 groups

 SELECT
 NTILE(4) OVER(ORDER BY OrderID) Buckets,
 * FROM Sales.Orders
  
--- Percentage ranking
-- Find the products that fall within the highest 40% of prices

SELECT * FROM Sales.Products

SELECT *, CONCAT(DistRank * 100, '%') DistRankPercentage
FROM(SELECT
Product, Price,
CUME_DIST() OVER(ORDER BY PRICE DESC) DistRank
FROM Sales.Products)t
WHERE DistRank <= 0.4

--- Window value functions 

SELECT * FROM Sales.Orders

--- Analyse the month over month (MoM) performance by finding the percentage
-- changes in sales between the current and previous month

SELECT *,CONCAT(DisPerc * 100, '%')
 FROM
(SELECT
OrderID, OrderDate,
MONTH(OrderDate) OrderMonth,Sales,
LEAD(Sales,1,0) OVER (ORDER BY OrderMonth) LeadResults,
CUME_DIST() OVER(ORDER BY LeadResults) DisPerc
FROM Sales.Orders)t

SELECT *,
CurrentMonthSales - PrevMontSales AS MoMChange
FROM(SELECT
MONTH(OrderDate) OrderMonth,
SUM(Sales) CurrentMonthSales,
LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PrevMontSales
FROM Sales.Orders
GROUP BY 
	MONTH(OrderDate) )t
 


