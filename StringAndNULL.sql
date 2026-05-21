
use MyDatabase

SELECT * FROM customers

INSERT INTO customers VALUES(6,'KIM','France',700)

SELECT country, score FROM customers

SELECT first_name, country, score FROM customers
WHERE score > 500

SELECT first_name, country, score FROM customers
WHERE country = 'USA' and score > 500

SELECT TOP 3 * FROM customers

SELECT TOP 3 * FROM customers ORDER BY score DESC

SELECT TOP 2 * FROM customers ORDER by score ASC

SELECT * FROM orders

SELECT TOP 2 * FROM orders ORDER BY order_date DESC

SELECT * FROM customers;
SELECT * FROM orders;

SELECT 741123 AS static_number
SELECT 'Shakthi' AS static_string

CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(100) NOT NULL,
	birth_date DATE,
	Phone VARCHAR(100) NOT NULL, 
	CONSTRAINT pk_persons PRIMARY KEY(id)
)

SELECT * FROM persons

ALTER TABLE persons ADD phone VARCHAR(50) NOT NULL

ALTER TABLE persons DROP COLUMN Phone

INSERT INTO persons(id, person_name, birth_date, email, phone)
SELECT 
id, first_name, 
NULL, 
'Unknown' AS ema,
'phon' AS phone_ver
FROM customers

SELECT * FROM persons

UPDATE customers SET score = 0 WHERE id=6

UPDATE customers SET score = 10, country= 'UK' 
WHERE id = 6

--Compari OPs

SELECT * FROM customers

SELECT * FROM customers WHERE country = 'Germany';

SELECT * FROM customers WHERE country != 'Germany';

SELECT * FROM customers WHERE score > 500;

SELECT * FROM customers WHERE score >= 500;

SELECT * FROM customers WHERE score < 500;

SELECT * FROM customers WHERE score <= 500;

---Logical Ops

SELECT * FROM customers WHERE country = 'USA' AND score > 500

SELECT * FROM customers WHERE country = 'USA' OR score > 500

SELECT * FROM customers WHERE NOT score > = 500 
--BETWEEN
SELECT * FROM customers WHERE score BETWEEN 100 AND 500

SELECT * FROM customers 
WHERE score >= 100 AND score <=500

--IN and NOT IN
SELECT * FROM customers
WHERE country IN ('Germany','USA')
--LIKE operator
SELECT * FROM customers 
WHERE first_name LIKE 'M%'

SELECT * FROM customers
WHERE first_name LIKE '__r%'

SELECT * FROM customers
WHERE first_name LIKE '%r%'


---JOINS
SELECT * FROM customers;
SELECT * FROM orders;

-- Inner Join
---- THe below query is traditional way of using the query
SELECT customers.id, customers.first_name, 
orders.order_id,
orders.sales
FROM customers
INNER JOIN orders 
ON customers.id = orders.customer_id

SELECT c.id, c.first_name, 
o.order_id,
o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

SELECT c.id, c.first_name, 
o.order_id,o.sales FROM
customers AS c
LEFT JOIN orders AS o
ON c.id=o.customer_id

SELECT c.id, c.first_name, o.order_id, o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

SELECT c.id, c.first_name, c.country, c.score,
o.order_id, o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id=o.customer_id

SELECT c.id, c.first_name, c.country, o.order_id, o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

SELECT c.id, c.first_name, o.order_id, o.sales FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

SELECT * 
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id
WHERE c.id IS NULL

SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

SELECT * 
FROM customers
LEFT JOIN orders
ON id = customer_id
WHERE customer_id IS NOT NULL

SELECT * 
FROM customers
CROSS JOIN orders


----- String Functions

SELECT first_name, country, 
CONCAT(first_name,' ',country) AS name_country
FROM customers

SELECT first_name, LOWER(first_name) AS Lower_FirstName
FROM customers

SELECT first_name, UPPER(first_name) AS upper_firstName
FROM customers

SELECT first_name,
LEN(first_name) len_name,
LEN(TRIM(first_name)) T_len_name,
LEN(first_name)  - LEN(TRIM(first_name)) flag
FROM customers 
WHERE first_name != TRIM(first_name)


SELECT 
'123-45-90-0' AS Repl_col,
REPLACE('123-45-90-0','-','/') AS new_number

SELECT
'report.txt' AS fileExtension,
REPLACE('report.txt','.txt','.csv')
AS new_File

SELECT first_name,
LEN(first_name) AS len_name
FROM customers

SELECT first_name,
LEFT(first_name,2) AS first_2_cha
FROM customers

SELECT first_name,
RIGHT(first_name, 2) AS Last_2_char
FROM customers

SELECT first_name,
SUBSTRING
(TRIM(first_name), 2, LEN(first_name))
AS new_Name
FROM customers

SELECT
3.516 AS numeric_Va,
ROUND(3.516,2) AS round_2,
ROUND(3.516,1) AS round_1,
ROUND(3.516,0) AS round_0


SELECT 
ABS(-10) AS valueASPos

SELECT
ABS(-90.0),
ABS(10),ABS(0)