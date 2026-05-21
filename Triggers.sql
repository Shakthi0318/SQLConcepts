-- Triggers

-- Create LOG table

CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
)

-- Create trigger on Employees table

ALTER TRIGGER tri_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeesLogs(EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID, 
		'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END

DROP TRIGGER tri_AfterInsertEmployee;
GO

SELECT * FROM Sales.EmployeeLogs
SELECT * FROM Sales.Employees
INSERT INTO Sales.Employees VALUES
(6, 'Maria', 'DOE', 'HR', '1994-01-12','F',90000,4)