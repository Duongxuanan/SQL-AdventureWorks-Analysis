--FROM Sales.SalesOrderHeader

--Customers who bought 3 or more times in 2013---> Potential customers
SELECT 
CustomerID,
Count(*) Number_of_order
INTO A11
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY CustomerID
HAVING Count(*) >3
--Table A11

--Customers who last purchased less than 7 months
SELECT 
CustomerID,
MAX(OrderDate) Last_purchase_date_2013,
DATEDIFF(MONTH,MAX(OrderDate),'2014-02-12') AS Month_period
INTO A12
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY CustomerID
--SELECT * FROM A12 WHERE Month_period <7 -->> Customers who last purchased less than 7 months

-- Listing potentail customers who last purchased less than 7 months
SELECT 
a.CustomerID,
a.Number_of_order,
b.Month_period
FROM A11 a INNER JOIN A12 b
ON a.CustomerID = b.CustomerID
-->> Keep Month period the lower the better