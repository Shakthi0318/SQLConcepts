
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

-- Find customers whose spending is increasing over their last 3 orders

-- Approach should be Order 3 > Order 2 > Order 1 (i.e, Current, previous, 2nd previous)
-- Tips( Whenever questions last 3 orders, 4 orders always think about LAG)

SELECT *
FROM(SELECT
OrderID, CustomerID, OrderDate,Sales,
LAG(Sales, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) prev1,
LAG(Sales, 2) OVER(PARTITION BY CustomerID ORDER BY OrderDate) prev2
FROM Sales.Orders)t
WHERE Sales > prev1 AND prev1 > prev2

-- Identify customers who had a drop in order value compared to their previous order
-- Tips ( LAG --> gives the previous order and (<) gives the drop)
SELECT * 
FROM
(SELECT
OrderID, CustomerID, 
OrderDate, Sales,
LAG(Sales, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS OrVa
FROM Sales.Orders)t
WHERE Sales < OrVa

-- For each customer, find the order where they spent the most compared to their own average
--Tips (Cal Avg, Differen with Avg, Rank Order)

SELECT *
FROM(SELECT
OrderID, CustomerID, Sales, AvgSales,
Sales - AvgSales AS Diff,
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY (Sales - AvgSales) DESC)rn
FROM(
SELECT
OrderID, CustomerID, Sales,
AVG(Sales) OVER(PARTITION BY CustomerID) AvgSales
FROM Sales.Orders)t1
)t2
WHERE rn=1

-- Detect customers who placed multiple orders on consecutive days
-- Tips (Consecutive always go with DATEDIFF and Use LAG(Dates) )

SELECT *
FROM(SELECT
OrderID, CustomerID, OrderDate,
Sales,
LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) prev1
FROM Sales.Orders)t
WHERE DATEDIFF(day, prev1, OrderDate) =1

-- Show each order along with previous order sales per customer
-- Tips (per customer, per user always use partition by and whenever you get previous, next , always use
-- order by sequence )

SELECT
CustomerID, Sales,
LAG(Sales,1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) PreSales
FROM Sales.Orders

-- Show each order along with next order sales per customer

SELECT 
CustomerID, Sales,
LEAD(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) nextOrder
FROM Sales.Orders

-- Find the difference between current and previous order sales per customer

SELECT
CustomerID, Sales CurrentOrder,
Sales - COALESCE(LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate),0) Difference
FROM Sales.Orders

-- Identify orders where sales increased compared to previous order

SELECT
CustomerID, Sales, PrevOrder FROM (
	SELECT
	CustomerID, Sales,
	COALESCE(LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate),0) PrevOrder
	FROM Sales.Orders)t
WHERE Sales > PrevOrder

-- Identify orders where sales dropped compared to previous order

SELECT
CustomerID, Sales, PreOrder
	FROM(SELECT
	CustomerID, Sales,
	LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate)PreOrder
	FROM Sales.Orders)t
WHERE Sales < PreOrder

-- Show gap in days between current and previous order by customer
-- Tips(if the problem mentions time/days/gap ---> always think use date colmn (OrderDate)

SELECT
OrderDate, PrevOrder,
DATEDIFF(day, prevOrder, OrderDate) AS GapDays
	FROM (SELECT
	CustomerID, Sales,
	OrderDate,
	LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) PrevOrder
	FROM Sales.Orders)t
WHERE DATEDIFF(day, prevOrder, OrderDate) >1

--- Find customers who placed orders on consecutive days
-- Tips ( Consecutive Days = Difference of exactly 1 day so, we need to use '=' 1)

SELECT
	CustomerID, 
	OrderDate,
	Sales,
DATEDIFF(DAY, OrdersDays, OrderDate) AS ConsecutiveDays
	FROM (SELECT
	CustomerID, OrderDate, Sales,
	LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) OrdersDays
	FROM Sales.Orders)t
WHERE DATEDIFF(DAY, OrdersDays,OrderDate) = 1

-- Find the customer who skipped more than 5 days between orders
-- Tips(measure the gaps always use DATEDIFF function)

SELECT
CustomerID, OrderDate, prevOrder,
DATEDIFF(DAY, prevOrder, OrderDate) AS skippedOrders
FROM (SELECT
	CustomerID, OrderID, OrderDate, Sales,
	LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) prevOrder
	FROM Sales.Orders)t
WHERE DATEDIFF(DAY, prevOrder, OrderDate) > 5

-- Show each order along with next order date gap in days

SELECT
	CustomerID, OrderDate, nextOrder,
	DATEDIFF(DAY, OrderDate, nextOrder) AS DaysGap
	FROM (SELECT
	CustomerID, OrderID, OrderDate,
	Sales CurrentOrder,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) nextOrder
	FROM Sales.Orders)t
WHERE DATEDIFF(DAY, OrderDate, nextOrder) >1


--- Detect orders where sales are more than double the previous order

SELECT
CustomerID, OrderID, Sales, prevOrders
FROM(
	SELECT
	CustomerID, OrderID, Sales,
	LAG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) prevOrders
	FROM Sales.Orders)t
WHERE Sales > 2 * prevOrders

-- Assign row number to orders per customer by order date

SELECT
CustomerID, OrderDate, Sales,
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) rn
FROM Sales.Orders

--Rank orders per customer based on sales (highest first)

SELECT
	CustomerID, OrderID, Sales,
	DENSE_RANK() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) rn
	FROM Sales.Orders

-- Dense rank orders globally based on sales

SELECT
	CustomerID, OrderID, Sales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) globalSales
FROM Sales.Orders;

SELECT
	CustomerID, OrderID, Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) GlobalRank
FROM Sales.Orders

-- Find top 3 orders per customers
-- Tips(always filter by rank)

SELECT CustomerID, OrderID,Sales, rn
	FROM(SELECT
	 CustomerID, OrderID, Sales,
	 ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) rn
	 FROM Sales.Orders)t
Where rn <= 3

-- Find the second highest order per customer
-- Tips (Second highest or third highest alwys specify the number as = 2 or =3)

SELECT OrderID, Sales
FROM (SELECT
	CustomerID, OrderID, Sales,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales DESC) rn
	FROM Sales.Orders)t
WHERE rn = 2

-- Find the lowest order per customer
-- Tips(Whenever questions says lowest we need to sort by ASC then make it to = 1)

SELECT
CustomerID, OrderID, Sales, rn
	FROM(SELECT
	CustomerID, OrderID, Sales,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Sales ASC) rn
	FROM Sales.Orders)t
WHERE rn =1

-- Rank customers based on total sales
-- Tips(Customer level / total ---> aggregation first, then window function)

SELECT
	CustomerID, OrderID, Sales,
	ROW_NUMBER() OVER(ORDER BY Sales) rn
	FROM Sales.Orders

SELECT
CustomerID,
ROW_NUMBER() OVER(ORDER BY TotalSales DESC) rn
FROM (SELECT
	CustomerID, 
	SUM(Sales)TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID)t

-- Find top 2 employees based on sales handled
-- Tips(based on totals always needs to be aggregated first)

SELECT
EmployeeID, TotalSales
FROM(SELECT
	e.EmployeeID,
	SUM(o.Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(o.Sales) DESC) rn
	FROM Sales.Employees e
	LEFT JOIN Sales.Orders o
	ON e.EmployeeID = o.SalesPersonID
	GROUP BY e.EmployeeID)t
WHERE rn < = 2


-- Find the latest order per customer
-- Tips ( for latest we need to always specify the row like rn = 1 )

SELECT
CustomerID, 
OrderDate, Sales, OrderID, rn
FROM(SELECT
	CustomerID, OrderDate, Sales, OrderID,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) rn
FROM Sales.Orders)t
WHERE rn = 1

-- Identify duplicate orders using row_number()
-- Tips (Use partition by always to identify)

SELECT
CustomerID,
OrderID
FROM(SELECT
	CustomerID, OrderID, 
	ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY OrderID) rn
	FROM Sales.Orders)t
WHERE rn > 1


-- Show total sales per customer

SELECT
	CustomerID, Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID) TotalSales
	FROM Sales.Orders

-- Show avergae order value per customer

SELECT
	CustomerID, Sales,
	AVG(Sales) OVER(PARTITION BY CustomerID) AvgOrderValue
FROM Sales.Orders

-- Show each order with customer's max order value

SELECT
	CustomerID, Sales,
	MAX(Sales) OVER(PARTITION BY CustomerID) CustomerMaxOrderValue
FROM Sales.Orders

-- Show each order with customer's min order value

SELECT
	CustomerID, Sales,
	CASE 
		WHEN Sales = MIN(Sales) OVER(PARTITION BY CustomerID) THEN 1
		ELSE 0
	END MinOrderVal
FROM Sales.Orders

-- Show orders greater than customer average
-- Tips(Always compare same type of colms ex: Sales Vs AvgSales)

SELECT
OrderID, CustomerID,Sales, CustomerAverage
FROM(SELECT
	OrderID, CustomerID, Sales,
	AVG(Sales) OVER(PARTITION BY CustomerID) CustomerAverage
FROM Sales.Orders)t
WHERE Sales > CustomerAverage


-- Show orders less than customers average

SELECT
OrderID, CustomerID, Sales, CustomerAverage
	FROM(SELECT
		OrderID, CustomerID, Sales,
		AVG(Sales) OVER(PARTITION BY CustomerID) CustomerAverage
	FROM Sales.Orders)t
WHERE Sales < CustomerAverage

-- Find the highest order per customer

SELECT
OrderID, CustomerID, HighestOrder
FROM(SELECT
	OrderID, CustomerID, Sales,
	MAX(Sales) OVER(PARTITION BY CustomerID) HighestOrder
FROM Sales.Orders)t
WHERE Sales = HighestOrder

-- Find the difference between max and min sales per customers

SELECT
	CustomerID, Sales,
	MAX(Sales) OVER(PARTITION BY CustomerID)  - 
	MIN(Sales) OVER(PARTITION BY CustomerID) SalesDifference
FROM Sales.Orders


-- Show the total orders per customer

SELECT
	CustomerID, Sales,
	COUNT(*) OVER(PARTITION BY CustomerID) TotalOrders
FROM Sales.Orders

-- Show each order contribution compared to customer total

SELECT
OrderID, CustomerID, Sales, CustomerTotal,
ROUND(Sales * 1.0 / CustomerTotal,2) AS Contribution
	FROM(SELECT
		OrderID, CustomerID, Sales,
		SUM(Sales) OVER(PARTITION BY CustomerID) CustomerTotal
	FROM Sales.Orders)t

-- Calculate running total of sales per customer
-- Tips(running totl should always be sequence/time like OrderDate)

SELECT 
	CustomerID, Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) RunningTotal
	FROM Sales.Orders

-- Calculate running total of sales overall

SELECT
	CustomerID, Sales,
	SUM(Sales) OVER(ORDER BY OrderDate) RunningTotal
FROM Sales.Orders

-- Show cumulative count of orders per customer

SELECT
	CustomerID, Sales,
	COUNT(*) OVER(PARTITION BY CustomerID ORDER BY OrderDate) CumulativeCount
FROM Sales.Orders


-- Show cumulative sales per product
-- Tips ( Cumulative sales -- use SUM and Cumulative Orders -- use COUNT)

SELECT
	ProductID, Sales,
	SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) CumulativeProduct
FROM Sales.Orders

SELECT * FROM Sales.Orders

-- Show running avg sales per customer

SELECT
	CustomerID, Sales,
	AVG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AvgRunningSale
FROM Sales.Orders

-- Show cumulative max sales per customer

SELECT
	CustomerID, Sales,
	MAX(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) MaxCumulativeSales
FROM Sales.Orders

-- Show cumulative min sales per Customers

SELECT
	CustomerID, Sales,
	MIN(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate, OrderID) MinCumulativeSales
FROM Sales.Orders

-- Identify the order where cumulative sales crossed 100

SELECT
CustomerID, Sales, CumOrder
FROM(SELECT
	CustomerID, Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderID, OrderDate) CumOrder
FROM Sales.Orders)t
WHERE CumOrder > 100

-- Show cumulative percentage contribution of each order

SELECT
CustomerID, OrderID, TotalSales,
1.0 * CumSales / TotalSales AS PercentageContributio
FROM (SELECT
	CustomerID, OrderID, Sales,
	SUM(Sales) OVER(ORDER BY OrderDate)CumSales,
	SUM(Sales) OVER() TotalSales
FROM Sales.Orders)t

-- Show running total reset for each customer

SELECT
	CustomerID, Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderID, OrderDate) TotalRunning
FROM Sales.Orders


-- Calculate moving average of last 3 orders per customers
-- Tips ( Moving window will always be --> ROWS BETWEEN N PRECEDING AND CURRENT ROW)

SELECT
	CustomerID, Sales,
	AVG(Sales) OVER
	(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) movingAvg
FROM Sales.Orders

-- Calculate moving sum of last 5 orders per customers

SELECT
	CustomerID, Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate
					ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) SumofLastOrders
FROM Sales.Orders


-- Show avg of current and previous orders

SELECT
	CustomerID, Sales,
	AVG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate, OrderID
					ROWS BETWEEN 1 PRECEDING  AND CURRENT ROW) AvgSa
FROM Sales.Orders

-- Show sum of current and next 2 orders
-- Tips(Always use FOLLOWING for Next to orders)

SELECT
	CustomerID, Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate, OrderID
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) SumOftwo
	FROM Sales.Orders


-- Show max sales in last 3 orders per customers

SELECT
	CustomerID, Sales,
	MAX(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) MaxSales
FROM Sales.Orders

-- Show min sales in last 3 orders per customers

SELECT
	CustomerID, Sales,
	MIN(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate, OrderID
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) MinSales
FROM Sales.Orders

-- Show moving count of last 4 orders

SELECT
	CustomerID, Sales,
	COUNT(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate, OrderId
				ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) CountOrder
FROM Sales.Orders


-- Find customers whose current order is higher than their customer average and also higher than previous order

SELECT
    CustomerID,
    Sales AS CurrentOrder,
    PrevOrder,
    AvgSales
FROM (
    SELECT
        CustomerID,
        Sales,
        LAG(Sales) OVER( PARTITION BY CustomerID  ORDER BY OrderDate
        ) AS PrevOrder,
        AVG(Sales) OVER(PARTITION BY CustomerID) AS AvgSales
    FROM Sales.Orders
) t
WHERE Sales > AvgSales
  AND Sales > PrevOrder






