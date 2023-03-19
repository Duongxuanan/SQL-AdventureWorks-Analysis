--Recency
SELECT 
	CustomerID,
	DATEDIFF(day, MAX(OrderDate), '2014-01-01') AS Recency
FROM 
	Sales.SalesOrderHeader
WHERE 
	YEAR(OrderDate) = 2013
GROUP BY 
	CustomerID

--Frequency
SELECT 
	CustomerID,
	COUNT(*) AS Frequency
FROM 
	Sales.SalesOrderHeader
WHERE 
	YEAR(OrderDate) = 2013
GROUP BY 
	CustomerID

--Monetary
SELECT 
	CustomerID,
	SUM(SubTotal) AS Monetary
FROM 
	Sales.SalesOrderHeader
WHERE 
	YEAR(OrderDate) =2013
GROUP BY 
	CustomerID

WITH RFM_Customers AS (
	SELECT 
		CustomerID,	
		DATEDIFF(day, MAX(OrderDate), '2014-01-01') AS Recency,
		COUNT(*) AS Frequency,
		ROUND(SUM(SubTotal),2) AS Monetary
	FROM 
		Sales.SalesOrderHeader
	WHERE 
		YEAR(OrderDate) = 2013
	GROUP BY
		CustomerID
)
--SELECT * FROM RFM_Customers
--Computing the quintile value (split 20%/each) for Recency, Frequency, Monetary
SELECT
	CustomerID,
	NTILE(5) OVER (ORDER BY Recency DESC) AS Recency_Quintile,
	NTILE(5) OVER (ORDER BY Frequency) AS Frequency_Quintile,
	NTILE(5) OVER (ORDER BY Monetary) AS Monetary_Quintile
--INTO RFM_Score
FROM 
	RFM_Customers

SELECT 
	RFM_Score.CustomerID,
	RFM_Score.Recency_Quintile*100 + RFM_Score.Frequency_Quintile*10 + RFM_Score.Monetary_Quintile AS RFM_Scores,
	CASE 
		WHEN RFM_Score.Recency_Quintile >=4 AND RFM_Score.Frequency_Quintile >=4 AND RFM_Score.Monetary_Quintile >=4 THEN 'Best Customers'
		WHEN RFM_Score.Recency_Quintile >=3 AND RFM_Score.Frequency_Quintile >=3 AND RFM_Score.Monetary_Quintile >=3 THEN 'Loyal'
		WHEN RFM_Score.Recency_Quintile >=3 AND RFM_Score.Frequency_Quintile >=1 AND RFM_Score.Monetary_Quintile >=2 THEN 'Potentail Loyallist'
		WHEN RFM_Score.Recency_Quintile >=3 AND RFM_Score.Frequency_Quintile >=1 AND RFM_Score.Monetary_Quintile >=1 THEN 'Promising'
		WHEN RFM_Score.Recency_Quintile >=2 AND RFM_Score.Frequency_Quintile >=2 AND RFM_Score.Monetary_Quintile >=2 THEN 'Customers Needing Attention'
		WHEN RFM_Score.Recency_Quintile >=1 AND RFM_Score.Frequency_Quintile >=2 AND RFM_Score.Monetary_Quintile >=2 THEN 'At Risk'
		WHEN RFM_Score.Recency_Quintile >=1 AND RFM_Score.Frequency_Quintile >=1 AND RFM_Score.Monetary_Quintile >=2 THEN 'Hibernating'
		ELSE 'Lost'
	END AS segment
--INTO RFM_Segment
FROM RFM_Score
--Grouping segment and count number of customers
SELECT 
	RFM_Segment.segment,
	COUNT(*) AS NUM_Customers
FROM RFM_Segment
GROUP BY 
	RFM_Segment.segment

