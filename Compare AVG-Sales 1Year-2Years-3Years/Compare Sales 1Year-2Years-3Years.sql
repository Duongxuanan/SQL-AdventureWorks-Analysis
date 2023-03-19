WITH CTE AS
(SELECT 
	a.CustomerID,
	a.Min_year,
	a.Max_year,
	MAX(CASE WHEN a.Year_= a.Min_year THEN Total END) as Earliest_amount,
	MAX(CASE WHEN a.Year_= a.Max_year THEN Total END) as Latest_amount
FROM
	(SELECT 
		CustomerID,
		YEAR(OrderDate) AS Year_,
		SUM(SubTotal) AS Total,
		MIN(YEAR(OrderDate)) OVER (PARTITION BY CustomerID) AS Min_year,
		MAX(YEAR(OrderDate)) OVER (PARTITION BY CustomerID) AS Max_year
	FROM Sales.SalesOrderHeader
	GROUP BY 
		CustomerID,
		YEAR(OrderDate)
	) a
WHERE 
	a.Min_year <> a.Max_year
GROUP BY
	a.CustomerID,
	a.Min_year,
	a.Max_year
)

SELECT 
	CTE.Min_year,
	CTE.Max_year,
	AVG(CTE.Earliest_amount) AS AVG_Earliest,
	AVG(CTE.Latest_amount) AS AVG_Latest,
	AVG(CTE.Latest_amount) - AVG(CTE.Earliest_amount) AS AVG_diff,
	COUNT(*) AS num_customers
--INTO #c
FROM 
	CTE
GROUP BY
	CTE.Min_year,
	CTE.Max_year
ORDER BY 
	num_customers


SELECT 
	#c.Min_year,
	#c.Max_year,
	#c.AVG_Earliest,
	#c.AVG_Latest,
	#c.AVG_diff,
	#c.num_customers,
	(CASE WHEN #c.Max_year - #c.Min_year = 1 THEN AVG(#c.AVG_Latest) ELSE NULL END) AS _1Y,
	(CASE WHEN #c.Max_year - #c.Min_year = 2 THEN AVG(#c.AVG_Latest) ELSE NULL END) AS _2Y,
	(CASE WHEN #c.Max_year - #c.Min_year = 3 THEN AVG(#c.AVG_Latest) ELSE NULL END) AS _3Y
--INTO #c1
FROM 
	#c
GROUP BY
	#c.Min_year,
	#c.Max_year,
	#c.AVG_Earliest,
	#c.AVG_Latest,
	#c.AVG_diff,
	#c.num_customers


SELECT * FROM #c