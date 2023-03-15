-- Consumer Behaviour
SELECT
a.CustomerID,
a.SalesOrderID,
e.Name ProductType,
c.ProductLine,
c.ProductID
--INTO pv04
FROM Sales.SalesOrderHeader a INNER JOIN Sales.SalesOrderDetail b ON a.SalesOrderID = b.SalesOrderID
INNER JOIN Production.Product c ON b.ProductID = c.ProductID
INNER JOIN Production.ProductSubcategory d ON c.ProductSubcategoryID = d.ProductSubcategoryID
INNER JOIN Production.ProductCategory e ON d.ProductCategoryID = e.ProductCategoryID


SELECT * 
--INTO pv05
FROM
	(SELECT DISTINCT SalesOrderID, ProductType, cnt = 1 FROM pv04) a
PIVOT(COUNT (Cnt) FOR ProductType IN ([Bikes], [Accessories] ,[Clothing], [Components])) b

SELECT 
Bikes,
Accessories,
Clothing,
Components,
COUNT(*) num_orders
FROM pv05
GROUP BY Bikes, Accessories, Clothing, Components
ORDER BY num_orders DESC
