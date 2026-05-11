-- Generate a sequence of numbers 1 to 20

-- Anchor Query
WITH Series AS(
SELECT 1 AS MyNumber

UNION ALL
-- Recursive query
SELECT
	MyNumber + 1 
	FROM Series
	WHERE MyNumber < 100
)
SELECT * FROM Series
OPTION (MAXRECURSION 1000);


--- Show the employees hiearchy by displaying each employees level within the organization

WITH employee_hiearchy AS 
(

	SELECT
		EmployeeID, ManagerID,
		1 AS Level
		FROM Sales.Employees
		WHERE ManagerID IS NULL

UNION ALL

	SELECT
		e.EmployeeID, e.ManagerID,
		Level + 1
		FROM Sales.Employees AS e
		INNER JOIN employee_hiearchy eh
		ON e.ManagerID = eh.EmployeeID

)

SELECT * FROM employee_hiearchy
