

SELECT * FROM SalesLT.Customer

SELECT FirstName, MiddleName
FROM SalesLT.Customer

SELECT FirstName, MiddleName,
CONCAT(FirstName,'-',LastName) FullName
FROM SalesLT.Customer