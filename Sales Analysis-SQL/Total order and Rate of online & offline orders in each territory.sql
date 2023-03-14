--SELECT * FROM Sales.SalesOrderHeader
--Total order and Rate of online order and offline order in each territory
SELECT 
TerritoryID,
COUNT(*) AS Total_Order,
FORMAT(SUM(CASE WHEN OnlineOrderFlag = 1 THEN 1 ELSE 0 END)*1.0/COUNT(*),'P1') AS Onl_Perc,
FORMAT(SUM(CASE WHEN OnlineOrderFlag = 0 THEN 1 ELSE 0 END)*1.0/COUNT(*),'P1') AS Off_Perc
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY TerritoryID
ORDER BY TerritoryID
