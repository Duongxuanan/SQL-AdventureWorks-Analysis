--FROM Sales.SalesOrderHeader
--FROM Sales.SalesOrderDetail
--FROM Production.Product
--FROM Production.ProductSubcategory
--FROM Production.ProductCategory

--Total Sales by category by month in 2013
SELECT 
d.Name Subcategory,
e.Name Category,
YEAR(a.OrderDate) _Year,
MONTH(a.OrderDate) _Month,
SUM(b.LineTotal) Sales,
SUM(SUM(b.LineTotal)) OVER() Sales_2013,
SUM(SUM(b.LineTotal)) OVER(PARTITION BY d.Name, e.Name) Sales_Subcate_Cate,
FORMAT(SUM(b.LineTotal)/SUM(SUM(b.LineTotal)) OVER(PARTITION BY d.Name, e.Name),'P2') Perc_of_Sales
FROM Sales.SalesOrderHeader a 
INNER JOIN Sales.SalesOrderDetail b ON a.SalesOrderID = b.SalesOrderID
INNER JOIN Production.Product c ON b.ProductID = c.ProductID
INNER JOIN Production.ProductSubcategory d ON c.ProductSubcategoryID = d.ProductSubcategoryID
INNER JOIN Production.ProductCategory e ON d.ProductCategoryID = e.ProductCategoryID
WHERE YEAR(a.OrderDate) = 2013
GROUP BY 
d.Name,
e.Name,
YEAR(a.OrderDate),
MONTH(a.OrderDate)
ORDER BY MONTH(a.OrderDate),
e.Name
