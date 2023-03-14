--FROM Sales.SalesOrderHeader
--Total sales each emplyee by year by quarter
SELECT 
SalesPersonID,
YEAR(OrderDate) AS _Year,
DATEPART(QUARTER,OrderDate) AS _Quarter,
SUM(SubTotal) _sales
--INTO task7
FROM Sales.SalesOrderHeader
WHERE SalesPersonID is not null
GROUP BY SalesPersonID,
YEAR(OrderDate),
DATEPART(QUARTER,OrderDate)

--SELECT * from task7 

--Total sales each employee by overtime
SELECT 
a.SalesPersonID,
a._Year,
a._Quarter,
a._sales sales2012,
b._sales sales2013
FROM task7 a INNER JOIN task7 b
ON a.SalesPersonID = b.SalesPersonID AND b._Quarter = a._Quarter AND b._Year = a._Year -1
WHERE a._Year =2012 OR a._Year =2013
ORDER BY 
a.SalesPersonID,
a._Year,
a._Quarter



