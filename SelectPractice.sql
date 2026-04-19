use MyDatabase

SELECT * FROM customers

INSERT INTO customers VALUES(7,'Rish','India',1000)

DELETE FROM customers WHERE id=6

SELECT country, SUM(score) AS total_sum FROM customers 
GROUP BY country

SELECT * FROM customers

SELECT first_name, country from customers

SELECT * FROM customers WHERE country = 'USA'

SELECT DISTINCT country FROM customers

SELECT first_name FROM customers 
WHERE first_name LIKE '%n'


SELECT * 
FROM customers

SELECT first_name
FROM customers 
WHERE first_name LIKE 'M%'

SELECT
UPPER(first_name)
FROM customers

SELECT
LOWER(first_name)
FROM customers

SELECT first_name, score
FROM customers
WHERE score > 500

SELECT first_name, score
FROM customers
WHERE score <= 500

SELECT first_name, score
FROM customers
WHERE score = 0

SELECT first_name,
country, score
FROM customers
WHERE country = 'GERMANY' and score > 

SELECT first_name, country
FROM customers
WHERE country = 'GERMANY' OR country = 'INDIA'

SELECT * 
FROM customers 
WHERE country NOT IN ('USA')

SELECT first_name,
score 
FROM customers
WHERE score BETWEEN 300 AND 800

SELECT * FROM customers 
WHERE first_name= ' John'

SELECT * FROM customers
WHERE NOT first_name = 'Maria'

SELECT first_name, country
FROM customers
WHERE country  IN ('India', 'UK')


SELECT score
FROM customers
ORDER BY score ASC

SELECT score
FROM customers
ORDER BY score DESC

SELECT country, score
FROM customers
ORDER BY country, score ASC

SELECT first_name
FROM customers
ORDER BY first_name ASC

SELECT first_name,
LEN(first_name) AS newName
FROM customers ORDER BY LEN(first_name) ASC
WHERE first_name = LEN(first_name)

SELECT 
SUM(score) AS total
FROM customers

SELECT AVG(score)
avgScoe
FROM customers

SELECT 
MAX(score) ms
FROM customers

SELECT 
MIN(score) MS
FROM customers

SELECT
COUNT(*) totalcoun
FROM customers

SELECT DISTINCT 
COUNT(country) uniCounty
FROM customers

SELECT country,
SUM(score) total
FROM customers 
GROUP BY country

SELECT country,
AVG(score)
FROM customers
GROUP BY country

SELECT country,
COUNT(*) as new
FROM customers
GROUP BY country

SELECT country,
MAX(score)
FROM customers
GROUP BY country

SELECT country,
MIN(score)
FROM customers
GROUP BY country

SELECT country,
SUM(score)
FROM customers 
GROUP BY country HAVING SUM(score) > 500


SELECT country,
SUM(score)
FROM customers
GROUP BY country HAVING SUM(score) > 1000

SELECT country,
COUNT(*)
FROM customers
GROUP BY country HAVING COUNT(*) > 1


SELECT country,
SUM(score)
FROM customers
GROUP BY country 

SELECT country,
SUM(score)
FROM customers 
 WHERE score >= 0 
 GROUP BY country


 SELECT country,
 SUM(score) totalsum,
 AVG(score) avgT
 FROM customers
 GROUP BY country

 SELECT first_name,country,
 SUM(score)
 FROM customers
 WHERE first_name LIKE 'M%'
 GROUP BY first_name, country

 SELECT country,
 COUNT(*)
 FROM customers
 WHERE NOT country = 'USA'
 GROUP BY country


 SELECT DISTINCT country,
 SUM(score)
 FROM customers
 GROUP BY country

 SELECT country,
 COUNT(*)
 FROM customers
 GROUP BY country HAVING COUNT(*) > 1

 SELECT country,
 MAX(score)
 FROM customers
 GROUP BY country HAVING MAX(score) > 800

 SELECT country,
 MIN(score)
 FROM customers
 GROUP BY country HAVING MIN(score) < 100

 SELECT country,
 SUM(score)
 FROM customers
 GROUP BY country HAVING SUM(score) BETWEEN 100 AND 1000

 SELECT country,
 COUNT(*)
 FROM customers
 GROUP BY country HAVING COUNT(*) = 2

 SELECT country,
 AVG(score)
 FROM customers
 GROUP BY country HAVING AVG(score) != 500

 SELECT country,
 SUM(score)
 FROM customers
 GROUP BY country HAVING SUM(score) < 1000

 SELECT country,
 COUNT(*)
 FROM customers
 GROUP BY country HAVING COUNT(*) > 100


SELECT country,
SUM(score)
FROM customers
GROUP BY country 
ORDER BY  SUM(score) ASC


SELECT country,
SUM(score)
FROM customers
GROUP BY country
ORDER BY SUM(score) DESC

SELECT country
FROM customers 
ORDER by country ASC

SELECT country,
AVG(score) 
FROM customers
GROUP BY country 
ORDER BY AVG(score)

SELECT country, 
SUM(score)
FROM customers
GROUP BY country  ORDER BY SUM(score) ASC


SELECT country,
SUM(score) newamt
FROM customers
GROUP BY country HAVING SUM(score) > 500
ORDER BY SUM(score) DESC

SELECT country,
COUNT(*)
FROM customers 
GROUP BY country HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC


SELECT country,
SUM(score)
FROM customers
GROUP BY country HAVING SUM(score) > 500
ORDER BY SUM(score) DESC

SELECT country,
COUNT(*) allCount
FROM customers
GROUP BY country HAVING COUNT(*) > 1
ORDER BY allCount DESC