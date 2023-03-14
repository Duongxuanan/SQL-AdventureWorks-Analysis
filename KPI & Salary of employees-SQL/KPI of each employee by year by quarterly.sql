--FROM Sales.SalesPersonQuotaHistory
--FROM Sales.SalesOrderHeader
--KPI and sales of each employee quarterly
SELECT 
a.BusinessEntityID AS EmployeeID
a.QuotaDate AS KPI_Date
a.SalesQuota AS KPI
SUM(b.SubTotal) AS Total_Sales
FORMAT(SUM(b.SubTotal)/a.SalesQuota,'P2') AS Perc
INTO table2
FROM Sales.SalesPersonQuotaHistory a LEFT JOIN Sales.SalesOrderHeader b
ON a.BusinessEntityID = b.SalesPersonID
WHERE b.OrderDate >=a.QuotaDate AND b.OrderDate< DATEADD(MONTH,3,a.QuotaDate)
GROUP BY
a.BusinessEntityID,
a.QuotaDate,
a.SalesQuota
ORDER BY 
a.BusinessEntityID

--FROM table2
SELECT * FROM table2
--Total KPI and total sales of each employee yearly
SELECT 
EmployeeID,
YEAR(KPI_Date) AS Year_,
SUM(KPI) AS Total_KPI,
SUM(Total_Sales) AS Total_Sales_Year,
FORMAT(SUM(Total_Sales)/SUM(KPI),'P2') AS Perc_Year
FROM table2
GROUP BY 
EmployeeID,
YEAR(KPI_Date)
ORDER BY EmployeeID,
YEAR(KPI_Date)
