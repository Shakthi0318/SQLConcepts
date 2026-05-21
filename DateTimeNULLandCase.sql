Use SalesDB

SELECT 
FirstName, LastName
FROM Sales.Customers

UNION

SELECT FirstName, LastName
FROM Sales.Employees


SELECT FirstName, LastName
FROM Sales.Employees

UNION

SELECT FirstName, LastName
FROM Sales.Customers


SELECT FirstName, LastName
FROM Sales.Customers

UNION ALL

SELECT FirstName, LastName
FROM Sales.Employees

--- Find the employees who are not customers at the same time
SELECT FirstName, LastName
FROM Sales.Employees
EXCEPT
SELECT FirstName, LastName
FROM Sales.Customers


SELECT FirstName, LastName
FROM Sales.Employees
INTERSECT
SELECT FirstName, LastName
FROM Sales.Customers


SELECT  'Orders' AS SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
      FROM Sales.Orders
UNION 
SELECT 'OrdersArchive' AS SourceTable,
        [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
      FROM Sales.OrdersArchive
ORDER BY OrderID
-----DATE and Time Func

SELECT OrderID, OrderDate, 
ShipDate, CreationTime
FROM Sales.Orders

SELECT OrderID, CreationTime,
'2026=04-09' HardCoded,
GETDATE() Today
FROM
Sales.Orders

SELECT OrderID, 
CreationTime,
YEAR(CreationTime) Year
FROM Sales.Orders

SELECT OrderID,
CreationTime,
MONTH(CreationTime) month
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DAY(CreationTime) day
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATEPART(MONTH, CreationTime) newValue
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATEPART(YEAR, CreationTime) newYearValue
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATEPART(QUARTER, CreationTime) q_value
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATEPART(WEEK, CreationTime)
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATENAME(MONTH, CreationTime) new_monthVal
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATENAME(WEEKDAY, CreationTime) new_weekdy
FROM Sales.Orders

SELECT OrderID,
CreationTime,
DATETRUNC(MINUTE, CreationTime)
new_va
FROM Sales.Orders



SELECT OrderID,
CreationTime,
DATETRUNC(HOUR, CreationTime),
DATETRUNC(YEAR, CreationTime)
FROM Sales.Orders

SELECT OrderID, CreationTime,
EOMONTH(CreationTime) newCol
FROM Sales.Orders

SELECT OrderDate,
OrderID, CreationTime,
YEAR(CreationTime) newVal
FROM Sales.Orders

SELECT 
YEAR(OrderDate), 
COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)


SELECT
MONTH(OrderDate),
COUNT(*) newMonthVal
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

SELECT
DATENAME(MONTH, OrderDate),
COUNT(*) newMonthName
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)

SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

SELECT OrderID,
CreationTime,
FORMAT(CreationTime, 'MM-dd-yyyy') us_Fomr,
FORMAT(CreationTime, 'dd ddd') dd
FROM Sales.Orders

SELECT OrderID,
CreationTime,
'Day' + FORMAT(CreationTime, 'ddd MMM') + ' Q'+ DATENAME(QUARTER, CreationTime)
+ ' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS csuFrt
FROM Sales.Orders


SELECT 
FORMAT(OrderDate, 'MMM yy') OrderDate,
COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')

SELECT 
CONVERT(INT, '123') AS [STRING to INT CONVERT],
CONVERT(DATE, '2026-04-09') AS [STRING to DATE CONVERT]

SELECT 
CAST('123' AS INT) AS [STRING TO INT],
CAST(123 AS VARCHAR) AS [INT TO STRING],
CAST('2025-08-20' AS DATE) AS [STRING TO DATE],
CreationTime,
CAST(CreationTime AS DATE) AS [DATETIME TO DATE]
FROM Sales.Orders

SELECT
OrderID, OrderDate,
DATEADD(month, 3 , OrderDate) AS ThreeMonthsLater,
DATEADD(YEAR, 2, OrderDate) AS TwoYearsLAter
FROM Sales.Orders

SELECT *
FROM Sales.Orders

SELECT
OrderDate, ShipDate
FROM Sales.Orders


SELECT *
FROM Sales.Employees

SELECT EmployeeID,BirthDate,
DATEDIFF(YEAR, BirthDate, GETDATE()) AS age
FROM Sales.Employees


SELECT
MONTH(OrderDate) AS OrderDate,
AVG(DATEDIFF(DAY, OrderDate, ShipDate)) As daVa
FROM Sales.Orders
GROUP BY OrderDate


SELECT
OrderID, OrderDate currentDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) previousOrderDate,
DATEDIFF(day,LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) NrOFdays
FROM Sales.Orders


SELECT
ISDATE(123) DateCheck,
ISDATE('2026-04-09')check2,
ISDATE(GETDATE())check4

SELECT 
CustomerID,
Score,
COALESCE(Score,0) score2,
AVG(Score) OVER() AvgScores,
AVG(COALESCE(Score,0)) OVER () AvgScore2
FROM Sales.Customers

SELECT
CustomerID, FirstName, LastName, 
FirstName + ' ' + COALESCE(LastName,'') AS FULLName, 
Score, COALESCE(Score, 0) + 10 AS ScoreWithBonus
FROM Sales.Customers


SELECT CustomerID, Score
FROM Sales.Customers
ORDER BY Score ASC

---- NULL USE CASE 1
SELECT CustomerID,
Score,
COALESCE(Score, 9999) updatedColn
FROM Sales.Customers
ORDER BY COALESCE(Score, 9999) ASC


--- USE CASE 2
SELECT 
CustomerID, Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END Flag
FROM Sales.Customers
ORDER BY COALESCE(Score, 9999) ASC


-- ANOTHER WAY OF USING NULL


SELECT
CustomerID, Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

-- FIND THE SALES PRICE for EACH ORDER BY DIVIDING SALES BY QUANTITY

SELECT OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity,0) AS Price
FROM Sales.Orders

-- LIST THE CUSTOMERS WHO DOES NOT HAVE SCORES
SELECT CustomerID,
Score
FROM Sales.Customers
WHERE Score IS NULL

-- LIST ALL THE CUSTOMERS WHO HAS SCORES

SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL

SELECT *
FROM Sales.Customers;

SELECT *
FROM Sales.Orders;

SELECT
c.CustomerID, c.FirstName, o.ProductID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL



WITH Orders AS(

SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
) SELECT * ,
DATALENGTH(Category) LengthCa,
DATALENGTH(TRIM(Category)) POLICY1 ,
NULLIF(TRIM(Category), '') polc2,   ---Use this while inserting and most commonly used
COALESCE(NULLIF(TRIM(Category), ''),'unkown') polic3 --- While preparing the data will use this method 
FROM Orders 

--- Generate the report showing the total sales for each category
-- High: If the sales higher than 50
-- Medium : If the sales between 20 and 50
-- Low : if the sales equal or lower
---- sort it highest to lowest 
SELECT
Category,
SUM(Sales) AS totalSales
FROM
(SELECT 
OrderID, Sales,
CASE
    WHEN Sales > 50 THEN 'HIGH'
    WHEN Sales > 20 THEN 'Medium'
    ELSE 'LOW'
END Category
FROM Sales.Orders
)t
GROUP BY Category
ORDER BY totalSales DESC


--- Retrive employee details with gender displayed as full text

SELECT *
FROM Sales.Employees

SELECT
*,
    CASE
        WHEN Gender= 'M' THEN 'MALE'
        WHEN Gender ='F' THEN 'FEMALE'
    END NewGenderCol
FROM Sales.Employees

--- Retrive customer details with abberivated country code

SELECT*
FROM Sales.Customers

SELECT 
CustomerID, FirstName,
Country,
CASE
    WHEN Country = 'GERMANY' THEN 'DE'
    WHEN Country = 'USA' THEN 'US'
    ELSE NULL
END CountryAbbrivation
FROM Sales.Customers

--- QUICK form --- Same logic as above with other format

SELECT
CustomerID,
FirstName, Country,
CASE Country
    WHEN 'GERMANY' THEN 'DE'
    WHEN 'USA' THEN 'US'
    ELSE 'n/a'
END NewColn
FROM Sales.Customers

--- Find the average score of customers and treat NULLS as 0
--- Additionally provide details such Customer ID and LastName

SELECT *
FROM Sales.Customers

SELECT CustomerID,
FirstName, Score,
CASE 
    WHEN Score IS NULL THEN 0
    ELSE Score
END ScoreClean,
AVG(
CASE
    WHEN Score IS NULL THEN 0
    ELSE Score
  END ) OVER() AvgCustomersCleanValue,
AVG(Score) OVER() AvgCustmV
FROM Sales.Customers

--- Count how many times each customer has made an order with sales greater than 30

SELECT *
FROM Sales.Orders

SELECT
CustomerID,
SUM(CASE
    WHEN Sales > 30 THEN 1
    ELSE 0
END) NewSalesRecord,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID


SELECT 
CustomerID,
OrderID, Sales
FROM Sales.Orders
ORDER BY CustomerID

--- Find the total sales across all the orders

SELECT
CustomerID, OrderID,
COUNT(Sales) as Toal
FROM Sales.Orders
GROUP BY CustomerID, OrderID
ORDER BY Toal

SELECT
SUM(Sales)
FROM Sales.Orders

--- Find the total sales for each product
---- Find the total sales for each product, additionally
-- provide details such as orderID and Or

SELECT
    OrderID, OrderDate
    ProductID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
GROUP BY ProductID



