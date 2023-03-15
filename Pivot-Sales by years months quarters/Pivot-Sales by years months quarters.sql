--- 01 Sales by years
SELECT 
	YEAR(OrderDate) year,
	SUM(SubTotal) total_sales
--INTO pv01
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)

-- Pivot static --
SELECT * FROM pv01
PIVOT(SUM(total_sales) FOR year IN ([2011],[2012],[2013],[2014])) AS pvot

-- Pivot dynamic --
DECLARE @queryString AS NVARCHAR(MAX)
DECLARE @column AS NVARCHAR(MAX)
SELECT @column= ISNULL(@column + ',','') + QUOTENAME(year)
FROM (SELECT DISTINCT year FROM pv01) AS Years
SET @queryString = 
  N'SELECT * FROM pv01
    PIVOT(SUM(total_sales) FOR year IN (' + @column + ')) AS pvot'
EXEC sp_executesql @queryString


--- 02  Sales by quarters
SELECT 
	YEAR(OrderDate) year,
	DATEPART(QUARTER,OrderDate) quarter, 
	SUM(SubTotal) total_sales
--INTO pv02
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), DATEPART(QUARTER,OrderDate)
ORDER BY YEAR(OrderDate), DATEPART(QUARTER,OrderDate)

-- 02  pivot static --
SELECT * FROM pv02
PIVOT( SUM(total_sales)  FOR quarter IN ([1],[2],[3],[4])) AS pvot

-- 02  pivot dynamic --
DECLARE @queryString AS NVARCHAR(MAX)
DECLARE @column AS NVARCHAR(MAX)
SELECT @column= ISNULL(@column + ',','') + QUOTENAME(quarter)
FROM (SELECT DISTINCT quarter FROM pv02) AS Quarters
SET @queryString = 
  N'SELECT year, ' + @column + '
    FROM pv02
    PIVOT(SUM(total_sales) FOR quarter IN (' + @column + ')) AS pvot'
EXEC sp_executesql @queryString


--- 03  Sales by months
SELECT 
	YEAR(OrderDate) year,
	DATENAME(MONTH,OrderDate) month,
	SUM(SubTotal) total_sales
--INTO pv03
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY YEAR(OrderDate), DATENAME(MONTH, OrderDate)

-- 03  Pivot static --
SELECT * FROM pv03
PIVOT(SUM(total_sales)  FOR month IN ([January],[February],[March],[April],[May], [June],[July],[August],[September],[October],[November],[December])) AS pvot

-- 03  Pivot dynamic --
DECLARE @queryString AS NVARCHAR(MAX)
DECLARE @column AS NVARCHAR(MAX)
SELECT @column= ISNULL(@column + ',','') + QUOTENAME(month)
FROM (SELECT DISTINCT month FROM pv03) AS Months
SET @queryString = 
  N'SELECT year, ' + @column + '
    FROM pv03
    PIVOT(SUM(total_sales) FOR month IN (' + @column + ')) AS pvot'
EXEC sp_executesql @queryString
