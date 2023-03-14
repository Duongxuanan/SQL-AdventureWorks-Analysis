--SELECT * FROM HumanResources.EmployeePayHistory
--Comparision of emplpoyee's salary change over time
SELECT 
BusinessEntityID AS Employee_ID,
RateChangeDate,
Rate AS Salary,
ROW_NUMBER() OVER(PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC) AS Rnk
INTO task1
FROM HumanResources.EmployeePayHistory
--task1
SELECT 
a.Employee_ID,
a.Salary AS Old_Salary,
b.Salary AS Recent_Salary,
FORMAT((b.Salary - a.Salary)/a.Salary,'P2') AS Perc
FROM task1 a INNER JOIN task1 b
ON a.Employee_ID = b.Employee_ID
WHERE a.Rnk =2 AND b.Rnk = 1 

